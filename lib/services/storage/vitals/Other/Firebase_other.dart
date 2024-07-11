import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:afyaexpress/services/storage/vitals/Other/other.dart';
import 'package:afyaexpress/services/storage/vitals/Other/other_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasOtherConditionsService {
  final AuthUser? user;
  late final CollectionReference othersEntries;

  late final String? patientProfileDocumentId;

  FirebasOtherConditionsService({required String patientProfileDocumentId})
      : user = FirebaseAuthProvider().currentUser {
    if (user != null) {
      othersEntries = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .collection('patientProfile')
          .doc(
              patientProfileDocumentId) // Use the passed or retrieved document ID
          .collection('others');
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

  Future<void> addOrUpdateOthersEntry({
    required String entryId,
    required String condition,
    required String briefDescription,
    required Timestamp timestamp,
  }) async {
    try {
      await othersEntries.doc(entryId).set({
        conditionFieldName: condition,
        briefExplanationFieldName: briefDescription,
        timestampFieldName: timestamp,
      });
    } catch (e) {
      print('Error updating diabetes entry: $e');
      throw CouldNotUpdateProfileException();
    }
  }

  Future<OtherVitalsEntry?> getOthersEntryByDate(String entryId) async {
    try {
      final docSnapshot = await OtherVitalsEntry.doc(entryId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return OtherVitalsEntry.fromSnapshot(
          docSnapshot as QueryDocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error getting diabetes entry: $e');
      return null;
    }
  }

  Stream<Iterable<OtherVitalsEntry>> getAllOtherEntries() {
    return othersEntries.snapshots().map((snapshot) => snapshot.docs.map(
        (doc) => OtherVitalsEntry.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
  }
}
