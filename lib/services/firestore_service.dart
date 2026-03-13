import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/checkin_record.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService._internal();

  // Sync check-in to Firestore
  Future<void> syncCheckIn(CheckInRecord record) async {
    try {
      await _firestore.collection('check_ins').add({
        'studentId': record.studentId,
        'checkInTime': record.checkInTime,
        'gpsLat': record.gpsLat,
        'gpsLng': record.gpsLng,
        'qrCodeData': record.qrCodeData,
        'previousTopic': record.previousTopic,
        'expectedTopic': record.expectedTopic,
        'moodBefore': record.moodBefore,
        'syncedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silent fail for offline scenarios - SQLite already has the data
      debugPrint('Firestore sync failed (check-in): $e');
    }
  }

  // Sync check-out to Firestore
  Future<void> syncCheckOut(CheckOutRecord record) async {
    try {
      await _firestore.collection('check_outs').add({
        'studentId': record.studentId,
        'checkOutTime': record.checkOutTime,
        'gpsLat': record.gpsLat,
        'gpsLng': record.gpsLng,
        'qrCodeData': record.qrCodeData,
        'whatLearned': record.whatLearned,
        'feedback': record.feedback,
        'syncedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silent fail for offline scenarios
      debugPrint('Firestore sync failed (check-out): $e');
    }
  }

  // Get all check-ins from Firestore
  Future<List<Map<String, dynamic>>> getAllCheckIns() async {
    try {
      final snapshot = await _firestore
          .collection('check_ins')
          .orderBy('checkInTime', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Firestore read failed: $e');
      return [];
    }
  }

  // Get all check-outs from Firestore
  Future<List<Map<String, dynamic>>> getAllCheckOuts() async {
    try {
      final snapshot = await _firestore
          .collection('check_outs')
          .orderBy('checkOutTime', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Firestore read failed: $e');
      return [];
    }
  }
}
