import 'package:flutter/material.dart';
import '../widgets/app_text.dart';
import 'home_screen.dart';
import 'user_dashboard.dart';
import '../services/user_service.dart';
import '../utils/smooth_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  void _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final userId = await _userService.getCurrentUserId();

    if (mounted) {
      if (userId != null) {
        // Existing user, go to Dashboard
        Navigator.pushReplacement(
          context,
          SmoothRoute(page: const UserDashboard()),
        );
      } else {
        // New user or cleared data, go to Home
        Navigator.pushReplacement(
          context,
          SmoothRoute(page: const HomeScreen(title: 'Heria AI')),
        );
      }
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
