import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:afyaexpress/services/storage/vitals/postOperative/operative.dart';
import 'package:afyaexpress/services/storage/vitals/postOperative/operative_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePostoperativeService {
  final AuthUser? user;
  late final CollectionReference postoperativeEntries;

  late final String? patientProfileDocumentId;

  FirebasePostoperativeService({required String patientProfileDocumentId})
      : user = FirebaseAuthProvider().currentUser {
    if (user != null) {
      postoperativeEntries = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .collection('patientProfile')
          .doc(patientProfileDocumentId)
          .collection('postoperative');
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  // Get the patient profile document ID
  static Future<String?> getPatientProfileDocumentId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('patientProfile')
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc
            .docs.first.id; // Assuming there is one patient profile document
      }
    } catch (e) {
      print('Error fetching patient profile document ID: $e');
    }
    return null;
  }

  Future<void> addOrUpdatePostoperativeEntry({
    required String entryId,
    required double bloodPressure,
    required double temperature,
    required int pulseRate,
    required int oxygenSaturation,
    required int painLevel,
    required double hydrationLevel,
    required Timestamp timestamp,
  }) async {
    try {
      await postoperativeEntries.doc(entryId).set({
        bloodPressureFieldName: bloodPressure,
        temperatureFieldName: temperature,
        pulseRateFieldName: pulseRate,
        oxygenSaturationFieldName: oxygenSaturation,
        painLevelFieldName: painLevel,
        hydrationLevelFieldName: hydrationLevel,
        postoperativeTimestampFieldName: timestamp,
      });
    } catch (e) {
      print('Error updating postoperative entry: $e');
      throw CouldNotUpdateProfileException();
    }
  }

  Future<PostoperativeVitalsEntry?> getPostoperativeEntryByDate(
      String entryId) async {
    try {
      final docSnapshot = await postoperativeEntries.doc(entryId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return PostoperativeVitalsEntry.fromSnapshot(
          docSnapshot as QueryDocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error getting postoperative entry: $e');
      return null;
    }
  }

  Stream<Iterable<PostoperativeVitalsEntry>> getAllPostoperativeEntries() {
    return postoperativeEntries.snapshots().map((snapshot) => snapshot.docs.map(
        (doc) => PostoperativeVitalsEntry.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
  }
}
