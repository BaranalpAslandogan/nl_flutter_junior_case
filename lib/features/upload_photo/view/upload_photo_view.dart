// upload_photo_view.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';
import 'dart:io';

// Localization import'u
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 20 : 24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 35 : 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Text(
                AppLocalizations.of(context)!.selectPhoto,
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt,
                    label: AppLocalizations.of(context)!.camera,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromSource(ImageSource.camera);
                    },
                    screenWidth: screenWidth,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                  _buildPickerOption(
                    icon: Icons.photo_library,
                    label: AppLocalizations.of(context)!.gallery,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromSource(ImageSource.gallery);
                    },
                    screenWidth: screenWidth,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 20),
            ],
          ),
        ),
      );
    } catch (e) {
      _showSnackBar('${AppLocalizations.of(context)!.errorPrefix}$e', isError: true);
    }
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required double screenWidth,
    required bool isMobile,
    required bool isTablet,
  }) {
    final containerSize = screenWidth * (isMobile ? 0.35 : (isTablet ? 0.30 : 0.25));
    final iconSize = isMobile ? 26.0 : (isTablet ? 30.0 : 34.0);
    final fontSize = isMobile ? 12.0 : (isTablet ? 14.0 : 16.0);
    final padding = isMobile ? 16.0 : (isTablet ? 18.0 : 20.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerSize,
        height: containerSize * 0.8,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            SizedBox(height: isMobile ? 6 : 8),
            Text(
              label,
              style: GoogleFonts.instrumentSans(
                color: Colors.white,
                fontSize: fontSize,
              ),
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
      _showSnackBar(AppLocalizations.of(context)!.photoSelectionError, isError: true);
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showSnackBar(AppLocalizations.of(context)!.pleaseSelectPhoto, isError: true);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final result = await AuthService.uploadPhoto(photoFile: _selectedImage!);
      
      if (result['success']) {
        Navigator.pop(context, _selectedImage);
      } else {
        _showSnackBar(result['message'] ?? AppLocalizations.of(context)!.uploadError, isError: true);
      }
    } catch (e) {
      _showSnackBar(AppLocalizations.of(context)!.uploadError, isError: true);
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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Responsive değerler
    final horizontalPadding = screenWidth * (isMobile ? 0.05 : (isTablet ? 0.08 : 0.12));
    final verticalPadding = isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);
    final iconContainerSize = isMobile ? 70.0 : (isTablet ? 80.0 : 90.0);
    final photoContainerSize = screenWidth * (isMobile ? 0.55 : (isTablet ? 0.45 : 0.35));
    final titleFontSize = isMobile ? 22.0 : (isTablet ? 26.0 : 30.0);
    final subtitleFontSize = isMobile ? 13.0 : (isTablet ? 15.0 : 17.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            tileMode: TileMode.clamp,
            center: Alignment.topCenter,
            radius: 2,
            colors: [
              Color.fromARGB(255, 216, 5, 16),
              Color.fromARGB(255, 158, 12, 22),
              Color.fromARGB(255, 53, 5, 5),
              Color(0xFF090909),
            ],
            stops: [0.0, 0.1, 0.2, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(screenWidth, isMobile, isTablet, isDesktop),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.07))),
                      Container(
                        width: iconContainerSize,
                        height: iconContainerSize,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/Profile-fill.png',
                          fit: BoxFit.contain,
                          width: iconContainerSize * 0.4,
                          height: iconContainerSize * 0.4,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : (isTablet ? 24 : 28)),
                      Text(
                        AppLocalizations.of(context)!.uploadPhoto,
                        style: GoogleFonts.instrumentSans(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isMobile ? 6 : (isTablet ? 8 : 10)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Text(
                          AppLocalizations.of(context)!.uploadPhotoSubtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.grey[400],
                            fontSize: subtitleFontSize,
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.07))),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _selectedImage != null
                            ? Container(
                                width: photoContainerSize,
                                height: photoContainerSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: FileImage(_selectedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: photoContainerSize,
                                height: photoContainerSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    color: Colors.grey[700]!,
                                    dashPattern: [10, 5],
                                    strokeWidth: isMobile ? 1 : (isTablet ? 1.5 : 2),
                                    padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 16 : 20)),
                                    radius: Radius.circular(20),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/Plus.png',
                                      fit: BoxFit.contain,
                                      width: photoContainerSize * 0.2,
                                      height: photoContainerSize * 0.2,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (_selectedImage != null) ...[
                        SizedBox(height: isMobile ? 24 : (isTablet ? 28 : 32)),
                        GestureDetector(
                          onTap: _discardImage,
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 6 : (isTablet ? 8 : 10)),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: isMobile ? 26 : (isTablet ? 30 : 34),
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
                                padding: EdgeInsets.symmetric(
                                  vertical: isMobile ? 14 : (isTablet ? 16 : 18),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isUploading
                                  ? SizedBox(
                                      width: isMobile ? 18 : (isTablet ? 20 : 22),
                                      height: isMobile ? 18 : (isTablet ? 20 : 22),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: isMobile ? 2 : 2.5,
                                      ),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!.continueText,
                                      style: GoogleFonts.instrumentSans(
                                        color: _selectedImage != null ? Colors.white : Colors.white54,
                                        fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 12 : (isTablet ? 14 : 16)),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.skip,
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.white,
                                  fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 16 : (isTablet ? 18 : 20)),
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

  Widget _buildHeader(double screenWidth, bool isMobile, bool isTablet, bool isDesktop) {
    final horizontalPadding = screenWidth * (isMobile ? 0.05 : (isTablet ? 0.08 : 0.12));
    final verticalPadding = isMobile ? 12.0 : (isTablet ? 16.0 : 20.0);
    final titleFontSize = isMobile ? 18.0 : (isTablet ? 20.0 : 22.0);
    final iconSize = isMobile ? 18.0 : (isTablet ? 20.0 : 22.0);
    final buttonSize = isMobile ? 40.0 : (isTablet ? 44.0 : 48.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: buttonSize,
              height: buttonSize,
              padding: EdgeInsets.all(isMobile ? 10 : (isTablet ? 12 : 14)),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[700]!,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                "assets/Arrow.png",
                color: Colors.white,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
          
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.profileDetail,
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(width: buttonSize), 
        ],
      ),
    );
  }
}