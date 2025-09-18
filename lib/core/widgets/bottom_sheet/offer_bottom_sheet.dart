import 'package:flutter/material.dart';

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
            radius: 1.6,
            colors: [
              Color(0xFFAF0810 ), // Koyu yeşil
              Color(0xFF1F0103), // Daha koyu yeşil
              Color(0xFF090909), // Çok koyu yeşil/siyah
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
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
                const Text(
                  'Sınırlı Teklif',
                  style: TextStyle(
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
                  // Açıklama metni
                  const Text(
                    'Jeton paketini seçerek bonus kazanın ve yeni\nbölümlerin kilidini açın!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Alacağınız Bonuslar kutusu
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
                        const Text(
                          'Alacağınız Bonuslar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Bonus ikonları
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBonusIcon(
                              icon: Icons.flash_on,
                              label: 'Premium\nHesap',
                              color: Color(0xFFAF0810 )
                            ),
                            _buildBonusIcon(
                              icon: Icons.remove_red_eye,
                              label: 'Daha\nFazla',
                              color: Color(0xFFAF0810 ),
                              isSelected: true,
                            ),
                            _buildBonusIcon(
                              icon: Icons.trending_up,
                              label: 'Öne\nÇıkarma',
                              color: Color(0xFFAF0810 ),
                            ),
                            _buildBonusIcon(
                              icon: Icons.favorite,
                              label: 'Daha\nFazla Değeni',
                              color: Color(0xFFAF0810 ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Paket seçimi başlığı
                  const Text(
                    'Kilidi açmak için bir jeton paketi seçin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Jeton paketleri
                  Expanded(
                    child: Row(
                      children: [
                        // 300 Jeton
                        Expanded(
                          child: _buildTokenPackage(
                            discount: '-10%',
                            tokens: '200',
                            price: '300',
                            originalPrice: '₺99,99',
                            subtitle: 'Başlına haftalık',
                            discountColor: const Color(0xFFE74C3C),
                            cardColor: const Color(0xFF8B1538),
                            secondaryCardColor: Color(0xFFCC0000),
                            context: context,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // 2000 Jeton (Önerilen)
                        Expanded(
                          child: _buildTokenPackage(
                            discount: '-70%',
                            tokens: '2.000',
                            price: '3.375',
                            originalPrice: '₺799,99',
                            subtitle: 'Başlına haftalık',
                            discountColor: const Color(0xFF8B5CF6),
                            cardColor: const Color(0xFF6B46C1),
                            secondaryCardColor: Color(0xFFCC0000),
                            isRecommended: true,
                            context: context,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // 1000 Jeton
                        Expanded(
                          child: _buildTokenPackage(
                            discount: '+35%',
                            tokens: '1.000',
                            price: '1.350',
                            originalPrice: '₺399,99',
                            subtitle: 'Başlına haftalık',
                            discountColor: const Color(0xFFE74C3C),
                            cardColor: const Color(0xFF8B1538),
                            secondaryCardColor: Color(0xFFCC0000),
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tüm Jetonları Gör butonu
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE74C3C),
                          Color(0xFFC0392B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
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
                          const SnackBar(
                            content: Text('Tüm jeton paketleri yakında!'),
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
                      child: const Text(
                        'Tüm Jetonları Gör',
                        style: TextStyle(
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
    required IconData icon,
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
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 5,
                spreadRadius: -1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTokenPackage({
    required String discount,
    required String tokens,
    required String price,
    required String originalPrice,
    required String subtitle,
    required Color discountColor,
    required Color cardColor,
    required BuildContext context,
    required Color secondaryCardColor,
    bool isRecommended = false,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Ana token kartı
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.27,
          margin: const EdgeInsets.only(top: 12), // Discount etiketi için boşluk
          decoration: BoxDecoration(
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
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 12), // Discount etiketi için boşluk
                
                // Token amount
                Text(
                  tokens,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Price
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 2),
                
                const Text(
                  'Jeton',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                
                Divider(thickness: 0.3, color: Colors.white.withOpacity(0.4),),
                
                // Original price and subtitle
                Column(
                  children: [
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
        
        // Discount badge - ayrı container olarak üstte

          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width * 0.15,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.05,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),

                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.outer,
                    color: Colors.white.withOpacity(1),
                    blurRadius: 5,
                    spreadRadius: -1,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                discount,
                textAlign: TextAlign.center,
                style: const TextStyle(
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

// Popup'ı göstermek için kullanılacak fonksiyon
void showLimitedOfferPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const LimitedOfferPopup(),
  );
}