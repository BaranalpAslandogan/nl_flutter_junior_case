// profile_view.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/core/helpers/localization_helper.dart';
import 'package:jr_case_boilerplate/core/models/movie_item_model.dart';
import 'package:jr_case_boilerplate/core/widgets/bottom_sheet/offer_bottom_sheet.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/services/movie_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/profile/widgets/profile_movie_card.dart';
import 'package:jr_case_boilerplate/features/upload_photo/view/upload_photo_view.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';
import '../../../core/models/user_model.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _currentUser;
  int _currentNavIndex = 1;
  
  List<MovieItem> _favoriteMovies = [];
  bool _isMoviesLoading = true;
  String? _moviesError;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndMovies();
  }

  Future<void> _loadUserDataAndMovies() async {
    setState(() {
      _isMoviesLoading = true;
    });
    try {
      final user = await AuthService.getProfile();
      User _user = user['user'];
      setState(() {
        _currentUser = _user;
      });
      await _loadFavoriteMovies();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isMoviesLoading = false;
        });
      }
    }
  }

  Future<void> _loadFavoriteMovies() async {
    final result = await MovieService.getFavoriteMovies();
    if (mounted) {
      setState(() {
        if (result['success']) {
          final List moviesData = result['movies'];
          _favoriteMovies = moviesData.map((json) => MovieItem.fromJson(json)).toList();
          _moviesError = null;
        } else {
          _moviesError = result['message'];
          _favoriteMovies = [];
        }
        _isMoviesLoading = false;
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

  void _showLimitedOfferPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LimitedOfferPopup(),
    );
  }

  void _showLogoutDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            AppLocalizations.of(context)!.logout,
            style: GoogleFonts.instrumentSans(
              color: Colors.white,
              fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.logoutConfirmation,
            style: GoogleFonts.instrumentSans(
              color: Colors.white70,
              fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.instrumentSans(
                  color: Colors.grey,
                  fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: GoogleFonts.instrumentSans(
                  color: Colors.red,
                  fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;
    
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileInfo(screenWidth, screenHeight, isMobile, isTablet, isDesktop),
                      Divider(
                        thickness: 1,
                        color: Colors.white.withOpacity(0.15),
                        indent: screenWidth * (isMobile ? 0.05 : 0.08),
                        endIndent: screenWidth * (isMobile ? 0.05 : 0.08),
                      ),
                      SizedBox(height: isMobile ? 20 : (isTablet ? 25 : 30)),
                      _buildLikedSection(screenWidth, isMobile, isTablet, isDesktop),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              CustomNavbar(
                currentIndex: _currentNavIndex,
                onTap: (index) {
                  setState(() {
                    _currentNavIndex = index;
                  });
                  if (index == 0) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, bool isMobile, bool isTablet, bool isDesktop) {
    final horizontalPadding = screenWidth * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.08));
    final verticalPadding = isMobile ? 16.0 : (isTablet ? 20.0 : 24.0);
    final titleFontSize = isMobile ? 22.0 : (isTablet ? 26.0 : 30.0);
    final buttonFontSize = isMobile ? 11.0 : (isTablet ? 12.0 : 14.0);
    final iconSize = isMobile ? 14.0 : (isTablet ? 16.0 : 18.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.profile,
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: isMobile ? 8 : (isTablet ? 10 : 12)),
              LocalizationHelper.buildLanguageButton(
                context,
                null,
                null,
              ),
            ],
          ),
          
          Row(
            children: [
              // Dil seçimi butonu
              
              
              // Sınırlı teklif butonu
              GestureDetector(
                onTap: _showLimitedOfferPopup,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : (isTablet ? 14 : 16),
                    vertical: isMobile ? 6 : (isTablet ? 7 : 8),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 216, 5, 16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/Gem.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                      SizedBox(width: isMobile ? 4 : 6),
                      Text(
                        AppLocalizations.of(context)!.limitedOffer,
                        style: GoogleFonts.instrumentSans(
                          color: Colors.white,
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(double screenWidth, double screenHeight, bool isMobile, bool isTablet, bool isDesktop) {
    final horizontalPadding = screenWidth * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.08));
    final avatarRadius = isMobile ? 28.0 : (isTablet ? 36.0 : 44.0);
    final nameFontSize = isMobile ? 20.0 : (isTablet ? 24.0 : 28.0);
    final idFontSize = isMobile ? 12.0 : (isTablet ? 14.0 : 16.0);
    final buttonWidth = screenWidth * (isMobile ? 0.25 : (isTablet ? 0.22 : 0.20));
    final buttonHeight = screenHeight * (isMobile ? 0.045 : (isTablet ? 0.05 : 0.055));
    final logoutIconSize = isMobile ? 24.0 : (isTablet ? 28.0 : 32.0);

    return Container(
      padding: EdgeInsets.all(horizontalPadding),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.grey[800],
            backgroundImage: 
               _currentUser?.photoUrl != null ?
                NetworkImage(_currentUser!.photoUrl!) as ImageProvider : 
                AssetImage("assets/Profile.png"),
          ),
          SizedBox(width: isMobile ? 10 : (isTablet ? 12 : 15)),
          Expanded(
            flex: isDesktop ? 3 : 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser?.name ?? AppLocalizations.of(context)!.user,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  'ID: ${_currentUser?.id?.substring(0, 6) ?? AppLocalizations.of(context)!.noId}',
                  style: GoogleFonts.instrumentSans(
                    color: Colors.grey[400],
                    fontSize: idFontSize,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isMobile ? 8 : 10),
          Container(
            width: buttonWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPhotoView(),
                  ),
                );
                if (result != null && result is File) {
                  setState(() {
                  });
                  _refreshProfileData();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.09),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : (isTablet ? 10 : 12),
                  vertical: isMobile ? 6 : (isTablet ? 8 : 10),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppLocalizations.of(context)!.addPhoto,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 10 : (isTablet ? 11 : 12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          GestureDetector(
            onTap: _showLogoutDialog,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 6 : 8),
              child: Icon(
                Icons.logout,
                color: Colors.white70,
                size: logoutIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLikedSection(double screenWidth, bool isMobile, bool isTablet, bool isDesktop) {
    final horizontalPadding = screenWidth * (isMobile ? 0.05 : (isTablet ? 0.06 : 0.08));
    final titleFontSize = isMobile ? 18.0 : (isTablet ? 20.0 : 24.0);
    
    // Responsive grid ayarları
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            AppLocalizations.of(context)!.myLikes,
            style: GoogleFonts.instrumentSans(
              color: Colors.white,
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 12 : (isTablet ? 14 : 16)),
        ProfileMovieCard(
          favoriteMovies: _favoriteMovies,
          isMoviesLoading: _isMoviesLoading,
          moviesError: _moviesError,
          horizontalPadding: horizontalPadding,
          isMobile: isMobile,
          isTablet: isTablet,
          isDesktop: isDesktop,
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Future<void> _refreshProfileData() async {
    final result = await AuthService.refreshProfile();
    if (mounted) {
      if (result['success']) {
        setState(() {
          _currentUser = result['user'];
        });
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    }
  }
}