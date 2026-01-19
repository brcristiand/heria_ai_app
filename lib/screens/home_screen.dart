import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/medium_img.dart';
import '../widgets/circle_icon.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_app_bar.dart';

import 'name_screen.dart';
import 'admin_login_screen.dart';
import '../utils/smooth_route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        rightWidget: IconButton(
          icon: const Icon(Icons.admin_panel_settings, color: Colors.white24),
          onPressed: () => Navigator.push(
            context,
            SmoothRoute(page: const AdminLoginScreen()),
          ),
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
                                'Hello!',
                                color: Colors.white70,
                                height: 2.0,
                              ),
                              TypoH6(
                                "I'm Chris Heria AI, your virtual assistant here in the app. I'm excited to help you out—let's get to know each other!",
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
                              const CircleIcon(icon: 'assets/img/hello.png'),
                              Transform.translate(
                                offset: const Offset(0, -24),
                                child: PrimaryButton(
                                  text: 'Say Hi!',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      SmoothRoute(page: const NameScreen()),
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
