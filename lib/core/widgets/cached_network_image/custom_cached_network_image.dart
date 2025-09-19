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

    // IMDb URL'lerini dönüştür - daha güvenilir endpoint kullan
    String processedUrl = _processImageUrl(imageUrl!);

    return CachedNetworkImage(
      imageUrl: processedUrl,
      httpHeaders: _getOptimizedHeaders(processedUrl),
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => _buildLoadingPlaceholder(context),
      errorWidget: (context, url, error) {
        print('Image load error for URL: $url');
        print('Error: $error');
        return _buildErrorWidget(context);
      },
      // Timeout ayarları
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      // Cache ayarları - null check ekledik
      memCacheHeight: height != null && height!.isFinite ? height!.toInt() : null,
      memCacheWidth: width != null && width!.isFinite ? width!.toInt() : null,
      maxHeightDiskCache: 1000,
      maxWidthDiskCache: 1000,
    );
  }

  String _processImageUrl(String url) {
    // IMDb URL'lerini işle
    if (url.contains('ia.media-imdb.com') || url.contains('m.media-amazon.com')) {
      // Yeni IMDb image format'ına çevir
      if (url.contains('ia.media-imdb.com')) {
        // Eski format: http://ia.media-imdb.com/images/M/MV5B...
        // Yeni format: https://m.media-amazon.com/images/M/MV5B...
        url = url.replaceAll('http://ia.media-imdb.com', 'https://m.media-amazon.com');
        url = url.replaceAll('https://ia.media-imdb.com', 'https://m.media-amazon.com');
      }
      
      // URL'den gereksiz parametreleri temizle ve boyut ekle
      if (!url.contains('._V1_')) {
        // Boyut parametresi yoksa ekle (600px genişlik)
        url = url.replaceAll('.jpg', '._V1_FMjpg_UX600_.jpg');
        url = url.replaceAll('.png', '._V1_FMpng_UX600_.png');
        url = url.replaceAll('.webp', '._V1_FMwebp_UX600_.webp');
      }
    }

    // HTTP'yi HTTPS'e çevir
    if (url.startsWith('http://')) {
      url = url.replaceAll('http://', 'https://');
    }

    return url;
  }

  Map<String, String> _getOptimizedHeaders(String url) {
    // IMDb/Amazon images için özel headers
    if (url.contains('media-amazon.com') || url.contains('imdb.com')) {
      return {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
        'Accept': 'image/webp,image/apng,image/jpeg,image/png,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
        'Referer': 'https://www.imdb.com/',
        'Origin': 'https://www.imdb.com',
        'Sec-Fetch-Dest': 'image',
        'Sec-Fetch-Mode': 'no-cors',
        'Sec-Fetch-Site': 'cross-site',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
        'DNT': '1',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
      };
    }

    // Diğer image URL'leri için genel headers
    return {
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
      'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
      'Cache-Control': 'no-cache',
      'DNT': '1',
      'Connection': 'keep-alive',
    };
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
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