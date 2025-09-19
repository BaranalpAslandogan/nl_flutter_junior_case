import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/core/widgets/cached_network_image/custom_cached_network_image.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';
import '../../../core/models/movie_item_model.dart';

class ProfileMovieCard extends StatelessWidget {
  final List<MovieItem> favoriteMovies;
  final bool isMoviesLoading;
  final String? moviesError;
  final double horizontalPadding;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final double screenWidth;

  const ProfileMovieCard({
    Key? key,
    required this.favoriteMovies,
    required this.isMoviesLoading,
    this.moviesError,
    required this.horizontalPadding,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive grid ayarları
    int crossAxisCount;
    double childAspectRatio;
    double crossAxisSpacing;
    double mainAxisSpacing;
    
    if (isDesktop) {
      crossAxisCount = 4;
      childAspectRatio = 0.7;
      crossAxisSpacing = 16;
      mainAxisSpacing = 20;
    } else if (isTablet) {
      crossAxisCount = 3;
      childAspectRatio = 0.65;
      crossAxisSpacing = 14;
      mainAxisSpacing = 18;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.6;
      crossAxisSpacing = 12;
      mainAxisSpacing = 16;
    }

    return isMoviesLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: isMobile ? 2.5 : (isTablet ? 3.0 : 3.5),
            ),
          )
        : favoriteMovies.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    moviesError ?? AppLocalizations.of(context)!.noFavoriteMovies,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.grey[400],
                      fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                  ),
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return _buildMovieCard(movie, screenWidth, isMobile, isTablet, isDesktop);
                  },
                ),
              );
  }

  Widget _buildMovieCard(MovieItem movie, double screenWidth, bool isMobile, bool isTablet, bool isDesktop) {
    final titleFontSize = isMobile ? 14.0 : (isTablet ? 16.0 : 18.0);
    final descriptionFontSize = isMobile ? 12.0 : (isTablet ? 14.0 : 16.0);
    final borderRadius = isMobile ? 10.0 : (isTablet ? 12.0 : 15.0);

    return GestureDetector(
      onTap: () {
        // Movie detail functionality can be added here
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: CustomNetworkImage(
                  imageUrl: movie.posterUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 6 : (isTablet ? 8 : 10)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 2 : 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 1 : 2),
                Text(
                  movie.description,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.grey[400],
                    fontSize: descriptionFontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}