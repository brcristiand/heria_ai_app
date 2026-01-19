import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/medium_img.dart';
import '../widgets/circle_icon.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_app_bar.dart';

import 'age.dart';
import 'user_dashboard.dart';
import '../utils/smooth_route.dart';

class TestLevel extends StatefulWidget {
  const TestLevel({super.key, required this.title});

  final String title;

  @override
  State<TestLevel> createState() => _TestLevelState();
}

class _TestLevelState extends State<TestLevel> {
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
                            MediumImg(imageUrl: 'assets/img/heria.png'),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const TypoH5(
                                      'Virtual Assistant',
                                      color: Colors.white,
                                    ),
                                    const TypoH2(
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
                                'Awesome!',
                                color: Colors.white70,
                                height: 2.0,
                              ),
                              TypoH6(
                                "Awesome! Before we begin, I just need to know your weight and age. This will help me create a personalized fitness level test just for you.",
                                color: Colors.white,
                                height: 2.0,
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 24),
                          child: Column(
                            children: [
                              const CircleIcon(icon: 'assets/img/power.png'),
                              Transform.translate(
                                offset: const Offset(0, -24),
                                child: PrimaryButton(
                                  text: 'Go to User Dashboard',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      SmoothRoute(page: const UserDashboard()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
