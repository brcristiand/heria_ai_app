import 'package:flutter/material.dart';

class MediumImg extends StatelessWidget {
  final String imageUrl;

  const MediumImg({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
      ),
    );
  }
}
