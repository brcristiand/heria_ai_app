import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSyncing = false;

  Future<String> createUser({
    required String username,
    required String age,
    required String weight,
    required String height,
  }) async {
    try {
      debugPrint('UserService: Creating user $username');
      // Fetch all progressions to initialize levels
      final progressionsSnapshot = await _firestore
          .collection('progressions')
          .get();

      final Map<String, int> progressionLevels = {};
      for (var doc in progressionsSnapshot.docs) {
        progressionLevels[doc.id] = 1; // Start at level 1
      }

      // Create user document with a unique ID
      final docRef = await _firestore.collection('users').add({
        'username': username,
        'age': age,
        'weight': weight,
        'height': height,
        'progressionLevels': progressionLevels,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Initialize exercises for the new user
      await _syncExercises(docRef.id);

      // Initialize injuries and equipment
      await _initializeInjuries(docRef.id);
      await _initializeEquipment(docRef.id);

      // Store user ID locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', docRef.id);
      debugPrint('UserService: User created with ID ${docRef.id}');

      return docRef.id;
    } catch (e) {
      debugPrint('UserService: Error creating user: $e');
      rethrow;
    }
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> syncUserProgressions(String userId) async {
    if (_isSyncing) {
      debugPrint('UserService: Sync already in progress for $userId');
      return;
    }
    _isSyncing = true;
    debugPrint('UserService: Starting sync for user $userId');

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        debugPrint('UserService: User document $userId does not exist');
        _isSyncing = false;
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final Map<String, dynamic> userProgressionLevels =
          Map<String, dynamic>.from(userData['progressionLevels'] ?? {});

      final progressionsSnapshot = await _firestore
          .collection('progressions')
          .get();

      bool updated = false;
      for (var doc in progressionsSnapshot.docs) {
        if (!userProgressionLevels.containsKey(doc.id)) {
          debugPrint('UserService: Adding new progression ${doc.id} to user');
          userProgressionLevels[doc.id] =
              1; // Default level 1 for new progressions
          updated = true;
        }
      }

      // Optional: Cleanup deleted progressions
      final existingProgressionIds = progressionsSnapshot.docs
          .map((d) => d.id)
          .toSet();
      final keysToRemove = userProgressionLevels.keys
          .where((k) => !existingProgressionIds.contains(k))
          .toList();

      for (var key in keysToRemove) {
        debugPrint('UserService: Removing deleted progression $key from user');
        userProgressionLevels.remove(key);
        updated = true;
      }

      if (updated) {
        debugPrint('UserService: Updating user document in Firestore...');
        await _firestore.collection('users').doc(userId).update({
          'progressionLevels': userProgressionLevels,
        });
        debugPrint('UserService: Sync completed successfully');
      } else {
        debugPrint('UserService: No sync needed for progression levels');
      }

      // Sync exercises independently
      await _syncExercises(userId);

      // Initialize injuries and equipment if they don't exist
      await _initializeInjuries(userId);
      await _initializeEquipment(userId);
    } catch (e) {
      debugPrint('UserService: Error syncing progressions: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _initializeInjuries(String userId) async {
    final injuries = [
      'Head',
      'Abs',
      'Biceps',
      'Legs',
      'Calves',
      'Arms',
      'Shoulders',
      'Triceps',
      'Back',
    ];
    final injuriesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('injuries');

    try {
      final snapshot = await injuriesRef.limit(1).get();
      if (snapshot.docs.isNotEmpty) return; // Already initialized

      debugPrint('UserService: Initializing injuries for $userId');
      final batch = _firestore.batch();
      for (var injury in injuries) {
        batch.set(injuriesRef.doc(injury), {
          'status': 'not injured',
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('UserService: Error initializing injuries: $e');
    }
  }

  Future<void> _initializeEquipment(String userId) async {
    final equipmentList = [
      'Parallettes',
      'Weight Vest',
      'Half Bar',
      'Dips Bars',
      'Box',
      'Resistance Band',
    ];
    final equipmentRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('equipment');

    try {
      final snapshot = await equipmentRef.limit(1).get();
      if (snapshot.docs.isNotEmpty) return; // Already initialized

      debugPrint('UserService: Initializing equipment for $userId');
      final batch = _firestore.batch();
      for (var equipment in equipmentList) {
        batch.set(equipmentRef.doc(equipment), {
          'status': 'not available',
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('UserService: Error initializing equipment: $e');
    }
  }

  Future<void> _syncExercises(String userId) async {
    debugPrint('UserService: Starting exercise sync for $userId');
    try {
      final progressionsSnapshot = await _firestore
          .collection('progressions')
          .get();

      final batch = _firestore.batch();
      bool hasUpdates = false;

      for (var progDoc in progressionsSnapshot.docs) {
        final progressionId = progDoc.id;
        final progressionName = progDoc.data()['name'] ?? 'Unnamed';

        final exercisesSnapshot = await _firestore
            .collection('progressions')
            .doc(progressionId)
            .collection('exercises')
            .get();

        for (var exDoc in exercisesSnapshot.docs) {
          final exerciseId = exDoc.id;
          final exerciseData = exDoc.data();
          final exerciseName = exerciseData['name'] ?? 'Unnamed';

          // Use unique ID composite of progression and exercise
          final userExId = '${progressionId}_$exerciseId';
          final userExRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('exercises')
              .doc(userExId);

          final userExDoc = await userExRef.get();

          if (!userExDoc.exists) {
            debugPrint('UserService: Syncing new exercise: $exerciseName');
            batch.set(userExRef, {
              'exerciseName': exerciseName,
              'progressionId': progressionId,
              'progressionName': progressionName,
              'ExerciseKt': 0,
              'ExerciseLevel': 1, // Default value as requested
              'ExerciseXp': 0,
              'ExerciseMax': 0,
              'lastUpdated': FieldValue.serverTimestamp(),
            });
            hasUpdates = true;
          }
        }
      }

      if (hasUpdates) {
        await batch.commit();
        debugPrint('UserService: Exercise sync batch committed');
      } else {
        debugPrint('UserService: No new exercises to sync');
      }
    } catch (e) {
      debugPrint('UserService: Error in _syncExercises: $e');
    }
  }
}
