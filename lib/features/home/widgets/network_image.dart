import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      return _buildPlaceholder();
    }

    // IMDb URL'leri için özel kontrol
    if (imageUrl!.contains('imdb.com') || imageUrl!.contains('media-imdb.com')) {
      return _buildIMDbImage();
    }

    // Normal network image
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      width: width,
      height: height,
      httpHeaders: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Referer': 'https://www.imdb.com/',
      },
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
    );
  }

  Widget _buildIMDbImage() {
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
      child: imageUrl == null ? _buildPlaceholder() : null,
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie,
                color: Colors.white54,
                size: 48,
              ),
              SizedBox(height: 8),
              Text(
                'Film Posteri',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[800],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.white38,
                size: 48,
              ),
              SizedBox(height: 8),
              Text(
                'Resim Yüklenemedi',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
  }
}