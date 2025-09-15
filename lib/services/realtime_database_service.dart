import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class RealtimeDatabaseService {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static const String _contactPath = 'contact_submissions';
  static const String _viewsPath = 'views';

  /// Submit a contact form to Realtime Database
  static Future<bool> submitContactForm({
    required String name,
    required String email,
    String? projectType,
    String? budget,
    required String message,
  }) async {
    try {
      final ref = _database.ref(_contactPath);
      final newRef = ref.push();

      await newRef.set({
        'name': name,
        'email': email,
        'projectType': projectType ?? '',
        'budget': budget ?? '',
        'message': message,
        'timestamp': ServerValue.timestamp,
        'status': 'new', // new, read, replied
        'id': newRef.key,
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error submitting contact form: $e');
      }
      return false;
    }
  }

  /// Get all contact submissions (for admin purposes)
  static Stream<DatabaseEvent> getContactSubmissions() {
    return _database.ref(_contactPath).onValue;
  }

  /// Update contact submission status
  static Future<bool> updateContactStatus(
    String submissionId,
    String status,
  ) async {
    try {
      await _database.ref('$_contactPath/$submissionId').update({
        'status': status,
        'updatedAt': ServerValue.timestamp,
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating contact status: $e');
      }
      return false;
    }
  }

  /// Delete a contact submission
  static Future<bool> deleteContactSubmission(String submissionId) async {
    try {
      await _database.ref('$_contactPath/$submissionId').remove();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting contact submission: $e');
      }
      return false;
    }
  }

  /// Increment the total views count
  static Future<bool> incrementViews() async {
    try {
      debugPrint('🔥 Starting views increment...');
      final viewsRef = _database.ref('$_viewsPath/total');

      // Use transaction to safely increment the counter
      await viewsRef.runTransaction((Object? currentViews) {
        int currentCount = 0;
        if (currentViews != null) {
          currentCount = currentViews as int;
        }
        debugPrint(
          '📊 Current views: $currentCount, incrementing to: ${currentCount + 1}',
        );
        return Transaction.success(currentCount + 1);
      });

      // Update the last updated timestamp
      await _database.ref('$_viewsPath/lastUpdated').set(ServerValue.timestamp);

      debugPrint('✅ Views incremented successfully!');
      return true;
    } catch (e) {
      debugPrint('❌ Error incrementing views: $e');
      if (kDebugMode) {
        debugPrint('Full error details: $e');
      }
      return false;
    }
  }

  /// Get the current total views count
  static Future<int> getTotalViews() async {
    try {
      debugPrint('📖 Fetching total views...');
      final snapshot = await _database.ref('$_viewsPath/total').get();
      if (snapshot.exists) {
        final views = snapshot.value as int;
        debugPrint('📊 Total views found: $views');
        return views;
      }
      debugPrint('📊 No views data found, returning 0');
      return 0;
    } catch (e) {
      debugPrint('❌ Error getting total views: $e');
      if (kDebugMode) {
        debugPrint('Full error details: $e');
      }
      return 0;
    }
  }

  /// Stream of total views count for real-time updates
  static Stream<DatabaseEvent> getViewsStream() {
    return _database.ref('$_viewsPath/total').onValue;
  }
}
