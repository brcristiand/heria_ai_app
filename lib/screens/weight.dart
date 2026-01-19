import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/info_card.dart';
import '../widgets/circle_icon.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_input.dart';
import 'height.dart';
import '../utils/smooth_route.dart';

class Weight extends StatefulWidget {
  final String username;
  final String age;
  const Weight({super.key, required this.username, required this.age});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
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
                60, // PrimaryAppBar height
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
                            const CircleIcon(icon: 'assets/img/stats.png'),
                            const SizedBox(height: 16),
                            const TypoH4(
                              'Weight',
                              color: Colors.white70,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const TypoH1(
                              'What Is Your \nWeight?',
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            PrimaryInput(
                              hintText: 'Please insert your weight (kg)...',
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                            ),
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
                          text: 'Continue',
                          onPressed: () {
                            if (_weightController.text.trim().isEmpty) return;
                            Navigator.push(
                              context,
                              SmoothRoute(
                                page: Height(
                                  username: widget.username,
                                  age: widget.age,
                                  weight: _weightController.text.trim(),
                                ),
                              ),
                            );
                          },
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
