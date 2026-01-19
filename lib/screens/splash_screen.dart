import 'package:flutter/material.dart';
import '../widgets/app_text.dart';
import 'home_screen.dart';
import '../utils/smooth_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        SmoothRoute(page: const HomeScreen(title: 'Heria AI')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypoH2('Heria', color: Colors.black54),
            SizedBox(height: 8),
            TypoH5('AI', color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
