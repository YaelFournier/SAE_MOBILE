import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sae_mobile/models/resto.dart';
import 'package:sae_mobile/services/images_services.dart';


class PhotoPicker extends StatefulWidget {
  final Resto resto;

  PhotoPicker({required this.resto});

  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  final ImageService _imageService = ImageService();
  List<String> imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _fetchImages() async {
    setState(() {
      _isLoading = true;
    });

    final urls = await _imageService.getImages(widget.resto.id);

    if (mounted) {
      setState(() {
        imageUrls = urls;
        _isLoading = false;
      });
    }
  }

  void _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });

        for (final file in result.files) {
          try {
            await _imageService.insertImage(file, widget.resto.id);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de l\'upload de ${file.name}: $e')),
            );
          }
        }

        _fetchImages();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection des fichiers: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openGalleryView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryView(resto: widget.resto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Images pour ${widget.resto.name}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : Row(
          children: [
            ...List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: imageUrls.length > index
                        ? () => _showFullImage(context, imageUrls[index])
                        : null,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        image: imageUrls.length > index
                            ? DecorationImage(
                          image: NetworkImage(imageUrls[index]),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: imageUrls.length > index
                          ? null
                          : const Icon(Icons.add_a_photo,
                          color: Colors.grey, size: 50),
                    ),
                  ),
                ),
              );
            }),
            IconButton(
              icon: const Icon(Icons.collections, size: 30),
              onPressed: _openGalleryView,
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickImages,
            icon: Icon(Icons.add_photo_alternate),
            label: Text('Ajouter des images'),
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class GalleryView extends StatefulWidget {
  final Resto resto;

  GalleryView({required this.resto});

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final ImageService _imageService = ImageService();
  List<String> imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() async {
    setState(() {
      _isLoading = true;
    });

    final urls = await _imageService.getImages(widget.resto.id);

    if (mounted) {
      setState(() {
        imageUrls = urls;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos de ${widget.resto.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : imageUrls.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Aucune image disponible pour ce restaurant'),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullImage(context, imageUrls[index]),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.red),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
