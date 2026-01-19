import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleIcon extends StatelessWidget {
  final String icon;

  const CircleIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final bool isSvg = icon.toLowerCase().endsWith('.svg');
    final bool isNetwork = icon.startsWith('http');

    Widget iconWidget;
    if (isSvg) {
      if (isNetwork) {
        iconWidget = SvgPicture.network(
          icon,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        );
      } else {
        iconWidget = SvgPicture.asset(
          icon,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        );
      }
    } else {
      if (isNetwork) {
        iconWidget = Image.network(
          icon,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        );
      } else {
        iconWidget = Image.asset(
          icon,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        );
      }
    }

    return Container(
      width: 124,
      height: 124,
      decoration: const BoxDecoration(
        color: Color(0xFF9FA4A7),
        shape: BoxShape.circle,
      ),
      child: Center(child: iconWidget),
    );
  }
}
