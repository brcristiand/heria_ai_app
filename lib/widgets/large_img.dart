import 'package:flutter/material.dart';

class LargeImg extends StatelessWidget {
  final String imageUrl;

  const LargeImg({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      height: 124,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
