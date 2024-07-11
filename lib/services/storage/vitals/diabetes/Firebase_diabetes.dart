import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:afyaexpress/services/storage/vitals/diabetes/diabetes.dart';
import 'package:afyaexpress/services/storage/vitals/diabetes/diabetes_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDiabetesService {
  final AuthUser? user;
  late final CollectionReference diabetesEntries;

  late final String? patientProfileDocumentId;

  FirebaseDiabetesService({required String patientProfileDocumentId})
      : user = FirebaseAuthProvider().currentUser {
    if (user != null) {
      diabetesEntries = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .collection('patientProfile')
          .doc(
              patientProfileDocumentId) // Use the passed or retrieved document ID
          .collection('diabetes');
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  //get the patient profile doc id
  static Future<String?> getPatientProfileDocumentId(String userId) async {
    print("user id");
    print(userId);
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

  Future<void> addOrUpdateDiabetesEntry({
    required String entryId,
    required double fastingBloodSugar,
    required double randomBloodSugar,
    required Timestamp timestamp,
  }) async {
    try {
      await diabetesEntries.doc(entryId).set({
        fastingBloodSugarFieldName: fastingBloodSugar,
        randomBloodSugarFieldName: randomBloodSugar,
        timestampFieldName: timestamp,
      });
    } catch (e) {
      print('Error updating diabetes entry: $e');
      throw CouldNotUpdateProfileException();
    }
  }

  Future<DiabetesVitalsEntry?> getDiabetesEntryByDate(String entryId) async {
    try {
      final docSnapshot = await diabetesEntries.doc(entryId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return DiabetesVitalsEntry.fromSnapshot(
          docSnapshot as QueryDocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error getting diabetes entry: $e');
      return null;
    }
  }

  Stream<Iterable<DiabetesVitalsEntry>> getAllDiabetesEntries() {
    return diabetesEntries.snapshots().map((snapshot) => snapshot.docs.map(
        (doc) => DiabetesVitalsEntry.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
  }
}
