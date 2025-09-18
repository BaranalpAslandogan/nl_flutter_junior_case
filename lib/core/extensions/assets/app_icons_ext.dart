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

// İkinci Buton Widget - Kırmızı Kalp
// class RedHeartButton extends StatelessWidget {
//   final bool isLiked;
//   final VoidCallback onTap;

//   const RedHeartButton({
//     Key? key,
//     required this.isLiked,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.10,
//         height: MediaQuery.of(context).size.width * 0.17,
//         decoration: BoxDecoration(
//           color: Color(0xFF2A2A2A),
//           borderRadius: BorderRadius.circular(60),
//           border: Border.all(
//             color: Colors.grey.shade600,
//             width: 1,
//           ),
//         ),
//         child: Center(
//           child: Icon(
//             Icons.favorite,
//             color: Colors.red,
//             size: MediaQuery.of(context).size.width * 0.05,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Daha esnek kullanım için parametreli buton
// class HeartButton extends StatelessWidget {
//   final bool isLiked;
//   final VoidCallback onTap;
//   final Color heartColor;
//   final double width;
//   final double height;
//   final double iconSize;

//   const HeartButton({
//     Key? key,
//     required this.isLiked,
//     required this.onTap,
//     this.heartColor = Colors.white,
//     this.width = 120,
//     this.height = 180,
//     this.iconSize = 40,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: Color(0xFF2A2A2A),
//           borderRadius: BorderRadius.circular(width / 2),
//           border: Border.all(
//             color: Colors.grey.shade600,
//             width: 1.5,
//           ),
//           boxShadow: isLiked ? [
//             BoxShadow(
//               color: heartColor.withOpacity(0.3),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ] : [],
//         ),
//         child: Center(
//           child: AnimatedScale(
//             scale: isLiked ? 1.1 : 1.0,
//             duration: Duration(milliseconds: 200),
//             child: Icon(
//               isLiked ? Icons.favorite : Icons.favorite_border,
//               color: heartColor,
//               size: iconSize,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }