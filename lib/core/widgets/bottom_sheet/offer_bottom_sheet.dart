import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';

// Localization import

class LimitedOfferPopup extends StatelessWidget {
  const LimitedOfferPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  AppLocalizations.of(context)!.limitedOffer,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white30,
                        width: 1,
                      ),
                      color: Colors.black.withOpacity(0.07),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                   Text(
                    AppLocalizations.of(context)!.limitedOfferDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white30,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                         Text(
                          AppLocalizations.of(context)!.bonusesYouWillGet,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBonusIcon(
                              context: context,
                              icon: 'assets/GemGrad.png',
                              label: AppLocalizations.of(context)!.premiumAccount,
                              color: Color.fromARGB(255, 102, 8, 14),
                            ),
                            _buildBonusIcon(
                              context: context,
                              icon: 'assets/MultiHeart.png',
                              label: AppLocalizations.of(context)!.more,
                              color: Color.fromARGB(255, 102, 8, 14),
                              isSelected: true,
                            ),
                            _buildBonusIcon(
                              context: context,
                              icon: 'assets/Rectangle.png',
                              label: AppLocalizations.of(context)!.priority,
                              color:Color.fromARGB(255, 102, 8, 14),
                            ),
                            _buildBonusIcon(
                              context: context,
                              icon: 'assets/HeartGrad.png',
                              label: AppLocalizations.of(context)!.moreVariety,
                              color: Color.fromARGB(255, 102, 8, 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                   Text(
                    AppLocalizations.of(context)!.selectTokenPackage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTokenPackage(
                            context: context,
                            discount: '-10%',
                            tokens: '200',
                            price: '300',
                            originalPrice: '₺99,99',
                            subtitle: '${AppLocalizations.of(context)!.weekly}',
                            discountColor: const Color(0xFFE74C3C),
                            cardColor: const Color(0xFF8B1538),
                            secondaryCardColor: Color(0xFFCC0000),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: _buildTokenPackage(
                            context: context,
                            discount: '-70%',
                            tokens: '2.000',
                            price: '3.375',
                            originalPrice: '₺799,99',
                            subtitle: '${AppLocalizations.of(context)!.weekly}',
                            discountColor: const Color(0xFF8B5CF6),
                            cardColor: const Color(0xFF6B46C1),
                            secondaryCardColor: Color(0xFFCC0000),
                            isRecommended: true,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        Expanded(
                          child: _buildTokenPackage(
                            context: context,
                            discount: '+35%',
                            tokens: '1.000',
                            price: '1.350',
                            originalPrice: '₺399,99',
                            subtitle: '${AppLocalizations.of(context)!.weekly}',
                            discountColor: const Color(0xFFE74C3C),
                            cardColor: const Color(0xFF8B1538),
                            secondaryCardColor: Color(0xFFCC0000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 216, 5, 16),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.allTokenPackagesSoon),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child:  Text(
                        AppLocalizations.of(context)!.showAllTokens,
                        style: GoogleFonts.instrumentSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusIcon({
    required BuildContext context,
    required String icon,
    required String label,
    required Color color,
    bool isSelected = false,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 5,
                spreadRadius: -1,
                offset: const Offset(-1, -1),
              ),
            ],
          ),
          child: Image.asset(
            icon,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style:  GoogleFonts.instrumentSans(
            color: Colors.white,
            fontSize: 11,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTokenPackage({
    required BuildContext context,
    required String discount,
    required String tokens,
    required String price,
    required String originalPrice,
    required String subtitle,
    required Color discountColor,
    required Color cardColor,
    required Color secondaryCardColor,
    bool isRecommended = false,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.27,
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 2,
              colors: [
                cardColor,
                secondaryCardColor
              ],
              stops: const [0.3, 1.0],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurStyle: BlurStyle.outer,
                color: Colors.white.withOpacity(1),
                blurRadius: 5,
                spreadRadius: -1,
                offset: Offset(-1, -1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 12),
                
                Text(
                  tokens,
                  style:  GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  price,
                  style:  GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 2),
                
                 Text(
                  AppLocalizations.of(context)!.tokens,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                
                Divider(thickness: 0.3, color: Colors.white.withOpacity(0.4),),
                
                Column(
                  children: [
                    Text(
                      originalPrice,
                      style:  GoogleFonts.instrumentSans(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style:  GoogleFonts.instrumentSans(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        
        Positioned(
          top: 0,
          width: MediaQuery.of(context).size.width * 0.15,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.05,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),

              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.white.withOpacity(1),
                  blurRadius: 5,
                  spreadRadius: -1,
                  offset: Offset(-1, -1),
                ),
              ],
            ),
            child: Text(
              discount,
              textAlign: TextAlign.center,
              style:  GoogleFonts.instrumentSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showLimitedOfferPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const LimitedOfferPopup(),
  );
}