import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/info_card.dart';
import '../widgets/circle_icon.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_input.dart';
import 'admin_dashboard.dart';
import '../utils/smooth_route.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  void _handleLogin() {
    setState(() {
      _errorMessage = null;
    });

    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'admin') {
      Navigator.pushReplacement(
        context,
        SmoothRoute(page: const AdminDashboard()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        leftWidget: PrimaryButton(
          text: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                60,
          ),
          child: IntrinsicHeight(
            child: SafeArea(
              top: false,
              bottom: true,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: InfoCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 40),
                            const CircleIcon(icon: 'assets/img/heria.png'),
                            const SizedBox(height: 16),
                            const TypoH4(
                              'Admin Portal',
                              color: Colors.white70,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const TypoH1(
                              'Login',
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            PrimaryInput(
                              hintText: 'Username',
                              controller: _usernameController,
                            ),
                            const SizedBox(height: 16),
                            PrimaryInput(
                              hintText: 'Password',
                              controller: _passwordController,
                              obscureText: true,
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ],
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: 'Login',
                          onPressed: _handleLogin,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
