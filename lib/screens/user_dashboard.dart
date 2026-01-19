import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text.dart';
import '../widgets/info_card.dart';

import '../services/user_service.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final UserService _userService = UserService();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final id = await _userService.getCurrentUserId();
    if (mounted) {
      setState(() {
        _userId = id;
      });
      if (id != null) {
        await _userService.syncUserProgressions(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        leftWidget: PrimaryButton(
          text: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: TypoH1('My Journey', color: Colors.white),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_userId)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                }
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Center(
                    child: Text(
                      'User data not found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final userLevels = Map<String, dynamic>.from(
                  userData['progressionLevels'] ?? {},
                );

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('progressions')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, progressionsSnapshot) {
                    if (progressionsSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${progressionsSnapshot.error}'),
                      );
                    }
                    if (progressionsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = progressionsSnapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(
                        child: TypoH5(
                          'No active progressions found.',
                          color: Colors.white70,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: docs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final progId = docs[index].id;
                        final progData =
                            docs[index].data() as Map<String, dynamic>;
                        final currentLevel = userLevels[progId] ?? 1;

                        return InfoCard(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TypoH4(
                                      progData['name'] ?? 'Unnamed Progression',
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TypoH6(
                                      'Level $currentLevel',
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                  text: 'Start Progression',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Starting ${progData['name']} at Level $currentLevel...',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
