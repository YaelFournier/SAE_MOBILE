import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sae_mobile/services/supabase_services.dart';

class ImageService {
  final supabaseService = SupabaseServices();
  final String _bucketName = 'images';
  final String _tableName = 'IMAGES';

  Future<void> insertImage(dynamic image, int idResto) async {
    try {
      final supabase = supabaseService.supabase;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'resto/$idResto/$fileName';

      Uint8List fileBytes;

      if (kIsWeb) {
        if (image is Uint8List) {
          fileBytes = image;
        } else if (image is PlatformFile) {
          fileBytes = image.bytes!;
        } else {
          throw Exception("Format non pris en charge sur le web");
        }
      } else {
        if (image is PlatformFile) {
          if (image.bytes != null) {
            fileBytes = image.bytes!;
          } else if (image.path != null) {
            fileBytes = await File(image.path!).readAsBytes();
          } else {
            throw Exception("Fichier vide");
          }
        } else if (image is File) {
          fileBytes = await image.readAsBytes();
        } else {
          throw Exception("Format non pris en charge sur mobile");
        }
      }

      final response = await supabase.storage
          .from(_bucketName)
          .uploadBinary(filePath, fileBytes);

      if (response.isEmpty) {
        throw Exception("Erreur d'upload Supabase");
      }

      final publicUrl = supabase.storage
          .from(_bucketName)
          .getPublicUrl(filePath);

      await supabase
          .from(_tableName)
          .insert({'idR': idResto, 'url': publicUrl});
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    try {
      final filePath = 'resto/$fileName';

      await supabaseService.supabase.storage
          .from(_bucketName)
          .uploadBinary(filePath, bytes);

      final url = supabaseService.supabase.storage
          .from(_bucketName)
          .getPublicUrl(filePath);

      return url;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getImages(int idResto) async {
    try {
      final response = await supabaseService.supabase
          .from(_tableName)
          .select('url')
          .eq('idR', idResto);

      return List<String>.from(response.map((item) => item['url']));
    } catch (e) {
      return [];
    }
  }
}
