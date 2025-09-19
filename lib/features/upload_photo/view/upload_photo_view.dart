// upload_photo_view.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Eklenen import
import '../../auth/services/auth_service.dart';

class UploadPhotoView extends StatefulWidget {
  const UploadPhotoView({Key? key}) : super(key: key);

  @override
  State<UploadPhotoView> createState() => _UploadPhotoViewState();
}

class _UploadPhotoViewState extends State<UploadPhotoView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _discardImage() async {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _pickImage() async {
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fotoğraf Seç',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromSource(ImageSource.camera);
                    },
                  ),
                  _buildPickerOption(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromSource(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    } catch (e) {
      _showSnackBar('Hata: $e', isError: true);
    }
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      _showSnackBar('Fotoğraf seçilirken hata oluştu', isError: true);
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showSnackBar('Lütfen önce bir fotoğraf seçin', isError: true);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Gerçek API çağrısını ekle
      final result = await AuthService.uploadPhoto(photoFile: _selectedImage!);
      
      if (result['success']) {
        _showSnackBar('Fotoğraf başarıyla yüklendi!');
        Navigator.pop(context, _selectedImage); // Başarılı olursa resim dosyasını geri döndür
      } else {
        _showSnackBar(result['message'] ?? 'Yükleme sırasında hata oluştu', isError: true);
      }
    } catch (e) {
      _showSnackBar('Yükleme sırasında hata oluştu', isError: true);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            tileMode: TileMode.clamp,
            center: Alignment.topCenter,
            radius: 1.6,
            colors: [
              Color(0xFFAF0810 ),
              Color(0xFF1F0103),
              Color(0xFF090909),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Fotoğraf Yükle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Profil fotoğrafı için görsel\nyükleyebilirsin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _selectedImage != null
                            ? Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color: Colors.grey[700]!,
                                    dashPattern: [10, 5],
                                    strokeWidth: 1,
                                    padding: EdgeInsets.all(16),
                                    radius: Radius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (_selectedImage != null) ...[
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: _discardImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedImage != null && !_isUploading
                                  ? _uploadImage
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCC0000),
                                foregroundColor: const Color(0xFFFFFFFF),
                                disabledBackgroundColor: const Color(0xFFCC0000).withOpacity(0.5),
                                disabledForegroundColor: const Color(0xFFFFFFFF).withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isUploading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Devam Et',
                                      style: TextStyle(
                                        color: _selectedImage != null ? Colors.white : Colors.white54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Atla',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Profil Detayı',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}