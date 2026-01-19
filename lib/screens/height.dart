import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/info_card.dart';
import '../widgets/circle_icon.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_input.dart';
import 'level_selection.dart';
import '../utils/smooth_route.dart';

class Height extends StatelessWidget {
  const Height({super.key});

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
                              'Height',
                              color: Colors.white70,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const TypoH1(
                              'What Is Your \nHeight?',
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            const PrimaryInput(
                              hintText: 'Please insert your height (cm)...',
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
                            Navigator.push(
                              context,
                              SmoothRoute(
                                page: const LevelSelection(
                                  title: 'Select Level',
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
