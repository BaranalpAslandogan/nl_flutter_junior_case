import 'package:flutter/material.dart';

class LimitedOfferPopup extends StatelessWidget {
  const LimitedOfferPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A0E0E),
            Color(0xFF8B1538),
            Color(0xFF2D0A0A),
          ],
          stops: [0.0, 0.5, 1.0],
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
            padding: const EdgeInsets.all(16),
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
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
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
                  
                  // Alacağınız Bonuslar başlığı
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
                        color: const Color(0xFF8B1538),
                      ),
                      _buildBonusIcon(
                        icon: Icons.remove_red_eye,
                        label: 'Daha\nFazla',
                        color: const Color(0xFF8B1538),
                        isSelected: true,
                      ),
                      _buildBonusIcon(
                        icon: Icons.trending_up,
                        label: 'Öne\nÇıkarma',
                        color: const Color(0xFF8B1538),
                      ),
                      _buildBonusIcon(
                        icon: Icons.favorite,
                        label: 'Daha\nFazla Değeni',
                        color: const Color(0xFF8B1538),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Paket seçimi başlığı
                  const Text(
                    'Kilidiaçmak için bir jeton paketi seçin',
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
                            tokens: '300',
                            price: '300',
                            originalPrice: '₺99,99',
                            subtitle: 'Başlına haftalık',
                            color: const Color(0xFF8B1538),
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
                            color: const Color(0xFF6B46C1),
                            isRecommended: true,
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
                            color: const Color(0xFF8B1538),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tüm Jetonları Gör butonu
                  SizedBox(
                    width: double.infinity,
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
                        backgroundColor: Colors.red,
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
            color: isSelected ? Colors.green : color,
            shape: BoxShape.circle,
            border: isSelected 
                ? Border.all(color: Colors.green, width: 2)
                : null,
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
    required Color color,
    bool isRecommended = false,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: isRecommended 
            ? Border.all(color: Colors.purple, width: 2)
            : null,
      ),
      child: Column(
        children: [
          // Discount badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isRecommended ? Colors.purple : Colors.red,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
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
          
          const SizedBox(height: 12),
          
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
          
          const Spacer(),
          
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