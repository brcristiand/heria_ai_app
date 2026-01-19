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
        debugPrint('UserService: No sync needed, data is up-to-date');
      }
    } catch (e) {
      debugPrint('UserService: Error syncing progressions: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
