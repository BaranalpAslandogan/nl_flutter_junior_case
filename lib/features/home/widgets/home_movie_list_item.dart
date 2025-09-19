import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/core/extensions/assets/app_icons_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/cached_network_image/custom_cached_network_image.dart';
import '../../../core/models/movie_item_model.dart';

class HomeMovieListItem extends StatelessWidget {
  final List<MovieItem> movies;
  final PageController pageController;
  final Function(int) onPageChanged;
  final Function(String, String) onShowDescription;
  final Function(String, int) onToggleFavorite;
  final Map<String, double> responsiveSizes;
  final BoxConstraints constraints;

  const HomeMovieListItem({
    Key? key,
    required this.movies,
    required this.pageController,
    required this.onPageChanged,
    required this.onShowDescription,
    required this.onToggleFavorite,
    required this.responsiveSizes,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieScreen(movie, index);
      },
    );
  }

  Widget _buildMovieScreen(MovieItem movie, int movieIndex) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image - tam ekran
          CustomNetworkImage(
            imageUrl: movie.posterUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          
          // Gradient overlay - daha yumuşak geçiş
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          
          // Content overlay - Netflix logosu
          Positioned(
            bottom: responsiveSizes['logoBottomPosition']! /1.2,
            left: responsiveSizes['contentLeftPadding']!,
            child: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 216, 5, 16),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image(
                image: Image.asset('assets/IconText.png').image,
                width: responsiveSizes['logoSize']!/1.5,
                height: responsiveSizes['logoSize']!/1.5,
              ),
            ),
          ),
          
          // Film bilgileri
          Positioned(
            bottom: responsiveSizes['contentBottomPosition']! /1.2,
            left: responsiveSizes['contentLeftPadding']! + responsiveSizes['logoSize']! + 20,
            right: responsiveSizes['contentRightPadding']!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Film başlığı - opacity 0.8
                Text(
                  movie.title,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: responsiveSizes['titleFontSize'],
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: constraints.maxHeight * 0.01),
                
                // Film açıklaması ve "Devamını oku" - kesilen metin için özel çözüm
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Metin boyutunu hesapla
                    final textStyle = GoogleFonts.instrumentSans(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: responsiveSizes['descriptionFontSize'],
                      height: 1.4,
                    );
                    
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: movie.description,
                        style: textStyle,
                      ),
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                    );
                    
                    textPainter.layout(maxWidth: constraints.maxWidth);
                    
                    // Eğer metin 2 satırdan fazlaysa, kısalt ve "Devamını Oku" ekle
                    final didExceedMaxLines = textPainter.didExceedMaxLines;
                    
                    if (didExceedMaxLines) {
                      // Metnin bir kısmını kes ve "Devamını Oku" için yer aç
                      String truncatedText = movie.description;
                      final readMoreText = ' Devamını Oku';
                      
                      // Metin + "Devamını Oku" için yer hesapla
                      while (true) {
                        final testPainter = TextPainter(
                          text: TextSpan(
                            text: truncatedText + '...' + readMoreText,
                            style: textStyle,
                          ),
                          maxLines: 2,
                          textDirection: TextDirection.ltr,
                        );
                        
                        testPainter.layout(maxWidth: constraints.maxWidth);
                        
                        if (!testPainter.didExceedMaxLines) {
                          break;
                        }
                        
                        if (truncatedText.length <= 10) break;
                        truncatedText = truncatedText.substring(0, truncatedText.length - 12);
                      }
                      
                      return GestureDetector(
                        onTap: () {
                          onShowDescription(movie.title, movie.description);
                        },
                        child: Text.rich(
                          TextSpan(
                            style: textStyle.copyWith(
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            children: [
                              TextSpan(text: truncatedText + '...'),
                              TextSpan(
                                text: readMoreText,
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.white,
                                  fontSize: responsiveSizes['descriptionFontSize'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 2,
                        ),
                      );
                    } else {
                      // Metin kısa, sadece açıklamayı göster
                      return Text(
                        movie.description,
                        style: textStyle.copyWith(
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        maxLines: 2,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Kalp butonu - tasarım değişmeyecek (ayrı positioned)
          Positioned(
            bottom: responsiveSizes['heartBottomPosition']!,
            right: responsiveSizes['heartRightPosition']!,
            child: FavoriteButton(
              isLiked: movie.isFavorite ?? false,
              onTap: () => onToggleFavorite(movie.id, movieIndex),
            ),
          ),
        ],
      ),
    );
  }
}