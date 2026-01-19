import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/info_card.dart';
import '../widgets/circle_icon.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_input.dart';
import 'age.dart';
import '../utils/smooth_route.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    setState(() {
      _isButtonEnabled = _nameController.text.trim().isNotEmpty;
    });
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
                            const CircleIcon(icon: 'assets/img/hello.png'),
                            const SizedBox(height: 16),
                            const TypoH4(
                              'Nice To Meet You!',
                              color: Colors.white70,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const TypoH1(
                              'How Should I \nCall You?',
                              color: Colors.white,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            PrimaryInput(
                              hintText: 'Please insert a username...',
                              controller: _nameController,
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
                          onPressed: _isButtonEnabled
                              ? () {
                                  Navigator.push(
                                    context,
                                    SmoothRoute(
                                      page: Age(
                                        username: _nameController.text.trim(),
                                      ),
                                    ),
                                  );
                                }
                              : null,
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
