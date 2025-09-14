import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.home,
            label: 'Anasayfa',
            index: 0,
            isActive: currentIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person,
            label: 'Profil',
            index: 1,
            isActive: currentIndex == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          
        } else {
          onTap(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.white.withOpacity(0.2) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[400],
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[400],
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}