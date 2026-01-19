import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heria AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent, // Set to transparent
        canvasColor: const Color(0xFFECECEC),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.normal,
          ),
          displayMedium: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w500, // Medium
          ),
          displaySmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),
          headlineLarge: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
          ),
          headlineSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Medium
          ),
        ),
      ),
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFECECEC), Color(0xFF515459)],
            ),
          ),
          child: child,
        );
      },
      home: const SplashScreen(),
    );
  }
}
