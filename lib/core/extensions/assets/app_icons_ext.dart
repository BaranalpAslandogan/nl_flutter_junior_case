import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const FavoriteButton({
    Key? key,
    required this.isLiked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.115,
        height: MediaQuery.of(context).size.width * 0.17,
        decoration: BoxDecoration(
          color: !isLiked ? Colors.transparent : Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: !isLiked ? Colors.grey.shade600 : Colors.white,
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: !isLiked ? Colors.white : Colors.red,
            size: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ),
    );
  }
}
