import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _contactCollection = 'contact_submissions';

  /// Submit a contact form to Firestore
  static Future<bool> submitContactForm({
    required String name,
    required String email,
    String? projectType,
    String? budget,
    required String message,
  }) async {
    try {
      await _firestore.collection(_contactCollection).add({
        'name': name,
        'email': email,
        'projectType': projectType ?? '',
        'budget': budget ?? '',
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'new', // new, read, replied
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
  static Stream<QuerySnapshot> getContactSubmissions() {
    return _firestore
        .collection(_contactCollection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Update contact submission status
  static Future<bool> updateContactStatus(String docId, String status) async {
    try {
      await _firestore.collection(_contactCollection).doc(docId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating contact status: $e');
      }
      return false;
    }
  }
}
