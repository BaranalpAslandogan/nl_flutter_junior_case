import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;

  const CustomNetworkImage({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // URL boş veya null ise placeholder göster
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(context);
    }

    // IMDb URL'leri için özel kontrol
    if (imageUrl!.contains('imdb.com') || imageUrl!.contains('media-imdb.com')) {
      return _buildIMDbImage(context);
    }

    // Normal network image
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      httpHeaders: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
        'DNT': '1',
        'Connection': 'keep-alive',
      },
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => _buildLoadingPlaceholder(context),
      errorWidget: (context, url, error) => _buildErrorWidget(context),
    );
  }

  Widget _buildIMDbImage(BuildContext context) {
    // IMDb resimleri için özel widget
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(
                  imageUrl!,
                  headers: {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                    'Referer': 'https://www.imdb.com/',
                    'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                    'Accept-Encoding': 'gzip, deflate, br',
                    'Accept-Language': 'en-US,en;q=0.9',
                    'Cache-Control': 'no-cache',
                    'Pragma': 'no-cache',
                  },
                ),
                fit: fit,
                onError: (exception, stackTrace) {
                  print('IMDb image error: $exception');
                },
              )
            : null,
      ),
      child: imageUrl == null ? _buildPlaceholder(context) : null,
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
    final indicatorSize = isMobile ? 24.0 : (isTablet ? 28.0 : 32.0);
    final strokeWidth = isMobile ? 2.5 : (isTablet ? 3.0 : 3.5);

    return Container(
      width: width,
      height: height,
      color: Colors.grey[900],
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.red,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
    // Responsive boyutlar
    final iconSize = isMobile ? 40.0 : (isTablet ? 56.0 : 72.0);
    final fontSize = isMobile ? 11.0 : (isTablet ? 13.0 : 15.0);
    final spacing = isMobile ? 6.0 : (isTablet ? 8.0 : 10.0);

    return placeholder ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie,
                color: Colors.white54,
                size: iconSize,
              ),
              SizedBox(height: spacing),
              Text(
                'Film Posteri',
                style: GoogleFonts.instrumentSans(
                  color: Colors.white54,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive breakpoints
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
    // Responsive boyutlar
    final iconSize = isMobile ? 40.0 : (isTablet ? 56.0 : 72.0);
    final fontSize = isMobile ? 11.0 : (isTablet ? 13.0 : 15.0);
    final spacing = isMobile ? 6.0 : (isTablet ? 8.0 : 10.0);

    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[800],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.white38,
                size: iconSize,
              ),
              SizedBox(height: spacing),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12.0 : (isTablet ? 16.0 : 20.0),
                ),
                child: Text(
                  'Resim Yüklenemedi',
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white38,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
  }
}