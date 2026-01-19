import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/medium_img.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_app_bar.dart';
import '../services/user_service.dart';
import 'user_dashboard.dart';
import '../utils/smooth_route.dart';

class LevelSelection extends StatefulWidget {
  final String title;
  final String username;
  final String age;
  final String weight;
  final String height;

  const LevelSelection({
    super.key,
    required this.title,
    required this.username,
    required this.age,
    required this.weight,
    required this.height,
  });

  @override
  State<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends State<LevelSelection> {
  final UserService _userService = UserService();
  bool _isCreatingUser = false;

  Future<void> _handleGoToDashboard() async {
    setState(() {
      _isCreatingUser = true;
    });

    try {
      await _userService.createUser(
        username: widget.username,
        age: widget.age,
        weight: widget.weight,
        height: widget.height,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          SmoothRoute(page: const UserDashboard()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating user: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingUser = false;
        });
      }
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
                              text: _isCreatingUser
                                  ? "Creating User..."
                                  : "Go to the User Dashboard",
                              onPressed: _isCreatingUser
                                  ? null
                                  : _handleGoToDashboard,
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
