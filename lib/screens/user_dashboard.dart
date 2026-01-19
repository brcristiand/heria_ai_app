import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<Map<String, dynamic>?> _getRecommendation(
    String progressionId,
    Map<String, dynamic> userData,
  ) async {
    final payload = {
      'username': userData['username']?.toString() ?? 'User',
      'age': userData['age']?.toString() ?? '',
      'height': userData['height']?.toString() ?? '',
      'weight': userData['weight']?.toString() ?? '',
      'progression': progressionId,
    };

    debugPrint('Sending Webhook Payload: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse(
        'https://heriaaiflutter.app.n8n.cloud/webhook/cbf86aa2-f289-4a1c-b5c3-2da81e79e925',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    debugPrint('Webhook Status: ${response.statusCode}');
    debugPrint('Webhook Body: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception(
          'The server returned an empty response. Ensure your n8n workflow has a "Respond to Webhook" node with data.',
        );
      }
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['recommendation'] != null) {
        return data['recommendation'];
      } else {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      throw Exception(
        'Failed to fetch recommendation (Status: ${response.statusCode})',
      );
    }
  }

  Future<void> _showRecommendationDialog(
    BuildContext context,
    Map<String, dynamic> userData,
    String progressionId,
    String progressionName,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final rec = await _getRecommendation(progressionId, userData);

      if (!context.mounted) return;
      Navigator.pop(context); // Close loading

      if (rec != null) {
        _displayRecommendation(
          context,
          rec,
          progressionName,
          userData,
          progressionId,
        );
      }
    } catch (e) {
      debugPrint('Webhook Error: $e');
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading if fetch failed
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _displayRecommendation(
    BuildContext context,
    Map<String, dynamic> initialRec,
    String progressionName,
    Map<String, dynamic> userData,
    String progressionId,
  ) {
    Map<String, dynamic> currentRec = initialRec;
    bool isStepLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TypoH5(progressionName, color: Colors.white70),
                        const SizedBox(height: 8),
                        if (isStepLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else ...[
                          TypoH3(
                            currentRec['exercise'] ?? 'Recommended Exercise',
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TypoH6(
                              'Level ${currentRec['level']}',
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCol(
                                'Sets',
                                currentRec['sets'].toString(),
                              ),
                              _buildStatCol(
                                'Reps',
                                currentRec['reps'].toString(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const TypoH6('Explanation', color: Colors.white70),
                          const SizedBox(height: 8),
                          Text(
                            currentRec['explanation'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'Next Exercise',
                              onPressed: () async {
                                setModalState(() => isStepLoading = true);
                                try {
                                  // Save current exercise
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(_userId)
                                      .collection('workouts')
                                      .add({
                                        'progressionName': progressionName,
                                        'exercise': currentRec['exercise'],
                                        'level': currentRec['level'],
                                        'sets': currentRec['sets'],
                                        'reps': currentRec['reps'],
                                        'explanation':
                                            currentRec['explanation'],
                                        'timestamp':
                                            FieldValue.serverTimestamp(),
                                      });

                                  // Fetch next exercise
                                  final nextRec = await _getRecommendation(
                                    progressionId,
                                    userData,
                                  );

                                  if (context.mounted) {
                                    setModalState(() {
                                      if (nextRec != null) {
                                        currentRec = nextRec;
                                      }
                                      isStepLoading = false;
                                    });
                                  }
                                } catch (e) {
                                  debugPrint('Error: $e');
                                  if (context.mounted) {
                                    setModalState(() => isStepLoading = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCol(String label, String value) {
    return Column(
      children: [
        TypoH6(label, color: Colors.white70),
        const SizedBox(height: 4),
        TypoH2(value, color: Colors.white),
      ],
    );
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            debugPrint('UserDashboard: User error: ${userSnapshot.error}');
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(
              child: Text(
                'User not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final userLevels = Map<String, dynamic>.from(
            userData['progressionLevels'] ?? {},
          );
          final String username = userData['username'] ?? 'User';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: TypoH1('$username\'s Journey', color: Colors.white),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('progressions')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, progressionsSnapshot) {
                    if (progressionsSnapshot.hasError) {
                      debugPrint(
                        'UserDashboard: Progressions error: ${progressionsSnapshot.error}',
                      );
                      return Center(
                        child: Text('Error: ${progressionsSnapshot.error}'),
                      );
                    }
                    if (progressionsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = progressionsSnapshot.data!.docs;

                    // Reactive sync check
                    if (docs.isNotEmpty) {
                      final globalIds = docs.map((d) => d.id).toSet();
                      final userIds = userLevels.keys.toSet();

                      if (!globalIds.every((id) => userIds.contains(id)) ||
                          !userIds.every((id) => globalIds.contains(id))) {
                        debugPrint(
                          'UserDashboard: Syncing ${globalIds.length} vs ${userIds.length}',
                        );
                        Future.microtask(
                          () => _userService.syncUserProgressions(_userId!),
                        );
                      }
                    }

                    if (docs.isEmpty) {
                      return const Center(
                        child: TypoH5(
                          'No progressions found.',
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
                        final progressionName = progData['name'] ?? 'Unnamed';
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
                                      progressionName,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
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
                                  onPressed: () => _showRecommendationDialog(
                                    context,
                                    userData,
                                    progId,
                                    progressionName,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
