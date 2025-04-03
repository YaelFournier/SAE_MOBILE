import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sae_mobile/models/resto.dart';

class PhotoPicker extends StatefulWidget {
  final Resto resto;

  PhotoPicker({required this.resto});

  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  List<dynamic> _imageFiles = []; // Supports File (mobile) and Uint8List (web)

  void _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: kIsWeb, // Needed for web
    );

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          _imageFiles.addAll(result.files.map((file) => file.bytes));
        } else {
          _imageFiles.addAll(result.paths.whereType<String>().map((path) => File(path)));
        }
      });
    }
  }

  void _openGalleryView() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GalleryView(images: _imageFiles, resto: widget.resto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Images pour ${widget.resto.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 150, // Increased height
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: _imageFiles.length > index
                          ? DecorationImage(
                        image: kIsWeb
                            ? MemoryImage(_imageFiles[index]) as ImageProvider
                            : FileImage(_imageFiles[index]),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageFiles.length > index
                        ? null
                        : const Icon(Icons.add_a_photo, color: Colors.grey, size: 50),
                  ),
                ),
              );
            }),
            IconButton(
              icon: const Icon(Icons.add, size: 30),
              onPressed: _openGalleryView,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImages,
          child: const Text('Ajouter des images depuis les fichiers'),
        ),
      ],
    );
  }
}

class GalleryView extends StatelessWidget {
  final List<dynamic> images; // Supports both File and Uint8List
  final Resto resto;

  GalleryView({required this.images, required this.resto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(resto.name)),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image(
            image: kIsWeb
                ? MemoryImage(images[index]) as ImageProvider
                : FileImage(images[index]),
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
