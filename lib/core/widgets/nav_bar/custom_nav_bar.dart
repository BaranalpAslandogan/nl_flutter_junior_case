import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';

// Localization import

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavbar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;
    
    // Responsive spacing ve padding
    final horizontalPadding = isMobile ? 0.0 : (isTablet ? 16.0 : 32.0);
    final verticalPadding = isMobile ? 20.0 : (isTablet ? 24.0 : 28.0);
    final itemSpacing = screenWidth * (isMobile ? 0.02 : (isTablet ? 0.03 : 0.04));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        spacing: itemSpacing,
        mainAxisAlignment: isDesktop ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context: context,
            activeAsset: 'assets/Home-fill.png',
            inactiveAsset: 'assets/Home.png',
            label: AppLocalizations.of(context)!.home,
            index: 0,
            isActive: currentIndex == 0,
            screenWidth: screenWidth,
            isDesktop: isDesktop,
            isTablet: isTablet,
            isMobile: isMobile,
          ),
          _buildNavItem(
            context: context,
            activeAsset: 'assets/Profile-fill.png',
            inactiveAsset: 'assets/Profile.png',
            label: AppLocalizations.of(context)!.profile,
            index: 1,
            isActive: currentIndex == 1,
            screenWidth: screenWidth,
            isDesktop: isDesktop,
            isTablet: isTablet,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String activeAsset,
    required String inactiveAsset,
    required String label,
    required int index,
    required bool isActive,
    required double screenWidth,
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    // Responsive boyutlar
    double itemWidth;
    if (isDesktop) {
      itemWidth = 200; // Sabit genişlik desktop için
    } else if (isTablet) {
      itemWidth = screenWidth * 0.35;
    } else {
      itemWidth = screenWidth * 0.44;
    }

    final iconSize = isMobile ? 24.0 : (isTablet ? 28.0 : 32.0);
    final fontSize = isMobile ? 11.0 : (isTablet ? 12.0 : 14.0);
    final horizontalPadding = isMobile ? 20.0 : (isTablet ? 24.0 : 28.0);
    final verticalPadding = isMobile ? 10.0 : (isTablet ? 12.0 : 14.0);
    final spacing = isMobile ? 4.0 : (isTablet ? 6.0 : 8.0);

    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Container(
        alignment: Alignment.center,
        width: itemWidth,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            tileMode: TileMode.clamp,
            center: Alignment.topCenter,
            radius: 1.6,
            colors: isActive ? [
              Color.fromARGB(255, 255, 17, 0),
              Color(0xFFAF0810),
            ] : [Colors.transparent],
            stops: isActive ? [0.0, 1.0] : [0.0],
          ),
          border: Border.all(
            color: isActive ? Colors.white : Colors.white24,
            width: isMobile ? 0.6 : (isTablet ? 0.8 : 1.0),
          ),
          color: isActive
              ? Color.fromARGB(255, 255, 17, 0)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isActive ? activeAsset : inactiveAsset,
              width: iconSize,
              height: iconSize,
              color: isActive ? Colors.white : Colors.grey[400],
            ),
            SizedBox(height: spacing, width: spacing),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.instrumentSans(
                  color: isActive ? Colors.white : Colors.grey[400],
                  fontSize: fontSize,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}