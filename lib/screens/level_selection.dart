import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/medium_img.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_app_bar.dart';
import 'complete_beginner.dart';
import 'test_level.dart';
import '../utils/smooth_route.dart';

class LevelSelection extends StatefulWidget {
  const LevelSelection({super.key, required this.title});

  final String title;

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
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
                  const Spacer(),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const MediumImg(imageUrl: 'assets/img/heria.png'),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TypoH5(
                                      'Virtual Assistant',
                                      color: Colors.white,
                                    ),
                                    TypoH2(
                                      'Chris Heria AI',
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TypoH5(
                                'Great to meet you!',
                                color: Colors.white70,
                                height: 2.0,
                              ),
                              TypoH6(
                                "Since we already know each other, what is your fitness level?",
                                color: Colors.white,
                                height: 2.0,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 32),
                            PrimaryButton(
                              text: "I'm a complete beginner",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SmoothRoute(
                                    page: const CompleteBeginner(
                                      title: 'Complete Beginner',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: "I want to test it right now",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SmoothRoute(
                                    page: const TestLevel(title: 'Test Level'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
