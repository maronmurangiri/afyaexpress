import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:afyaexpress/services/storage/vitals/bloodPressure/pressure.dart';
import 'package:afyaexpress/services/storage/vitals/bloodPressure/pressure_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePressureService {
  final AuthUser? user;
  late final CollectionReference pressureEntries;

  late final String? patientProfileDocumentId;

  FirebasePressureService({required String patientProfileDocumentId})
      : user = FirebaseAuthProvider().currentUser {
    if (user != null) {
      pressureEntries = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .collection('patientProfile')
          .doc(
              patientProfileDocumentId) // Use the passed or retrieved document ID
          .collection('bloodPressure');
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

  Future<void> addOrUpdatePressureEntry({
    required String entryId,
    required int systolic,
    required int diastolic,
    required Timestamp timestamp,
  }) async {
    try {
      await pressureEntries.doc(entryId).set({
        systolicFieldName: systolic,
        diastolicFieldName: diastolic,
        timestampFieldName: timestamp,
      });
    } catch (e) {
      print('Error updating pressure entry: $e');
      throw CouldNotUpdateProfileException();
    }
  }

  Future<PressureVitalsEntry?> getPressureEntryByDate(String entryId) async {
    try {
      final docSnapshot = await pressureEntries.doc(entryId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return PressureVitalsEntry.fromSnapshot(
          docSnapshot as QueryDocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print('Error getting pressure entry: $e');
      return null;
    }
  }

  Stream<Iterable<PressureVitalsEntry>> getAllPressureEntries() {
    return PressureVitalsEntry.snapshots().map((snapshot) => snapshot.docs.map(
        (doc) => PressureVitalsEntry.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
  }
}
