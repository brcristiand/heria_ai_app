import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text.dart';
import '../widgets/primary_input.dart';
import '../widgets/info_card.dart';

class ProgressionExercisesScreen extends StatefulWidget {
  final String progressionId;
  final String progressionName;

  const ProgressionExercisesScreen({
    super.key,
    required this.progressionId,
    required this.progressionName,
  });

  @override
  State<ProgressionExercisesScreen> createState() =>
      _ProgressionExercisesScreenState();
}

class _ProgressionExercisesScreenState
    extends State<ProgressionExercisesScreen> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addExercise() async {
    final name = _exerciseNameController.text.trim();
    final levelStr = _levelController.text.trim();

    if (name.isEmpty || levelStr.isEmpty) return;

    final level = int.tryParse(levelStr);
    if (level == null) return;

    try {
      await _firestore
          .collection('progressions')
          .doc(widget.progressionId)
          .collection('exercises')
          .add({
            'name': name,
            'level': level,
            'createdAt': FieldValue.serverTimestamp(),
          });

      _exerciseNameController.clear();
      _levelController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercise added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding exercise: $e')));
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            TypoH5(widget.progressionName, color: Colors.white70),
            const TypoH1('Exercises', color: Colors.white),
            const SizedBox(height: 24),
            InfoCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PrimaryInput(
                    hintText: 'Exercise Name',
                    controller: _exerciseNameController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryInput(
                          hintText: 'Level (e.g. 1)',
                          controller: _levelController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        text: 'Add Exercise',
                        onPressed: _addExercise,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('progressions')
                    .doc(widget.progressionId)
                    .collection('exercises')
                    .orderBy('level', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: TypoH5('No exercises yet.', color: Colors.white70),
                    );
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return InfoCard(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TypoH6(
                                'Lvl ${data['level']}',
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TypoH4(
                                data['name'] ?? 'Unnamed',
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () => _firestore
                                  .collection('progressions')
                                  .doc(widget.progressionId)
                                  .collection('exercises')
                                  .doc(doc.id)
                                  .delete(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
