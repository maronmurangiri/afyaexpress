import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile_constants.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePatientProfile {
  final AuthUser? user;
  late final CollectionReference patientProfile;

  FirebasePatientProfile() : user = FirebaseAuthProvider().currentUser {
    if (user != null) {
      patientProfile = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .collection('patientProfile');
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> deletePatientProfile({required String documentId}) async {
    try {
      await patientProfile.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteProfileException();
    }
  }

  Future<void> updatePatientProfile({
    required String documentId,
    List<String>? medicalHistory,
    String? gender,
    String? phoneNumber,
    int? age,
    List<String>? allergies,
    String? address,
    String? names,
    List<String>? currentMedications,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (medicalHistory != null) {
        updates[medicalHistoryFieldName] = medicalHistory;
      }
      if (gender != null) updates[genderFieldName] = gender;
      if (phoneNumber != null) updates[phoneNumberFieldName] = phoneNumber;
      if (age != null) updates[ageFieldName] = age;
      if (allergies != null) updates[allergiesFieldName] = allergies;
      if (address != null) updates[addressFieldName] = address;
      if (names != null) updates[patientNameFieldName] = names;
      if (currentMedications != null) {
        updates[currentMedicationFieldName] = currentMedications;
      }

      await patientProfile.doc(documentId).update(updates);
    } catch (e) {
      throw CouldNotUpdateProfileException();
    }
  }

  Stream<Iterable<PatientProfile>> viewProfile({required String documentId}) {
    final profile = patientProfile
        .where(patientUserIdFieldName, isEqualTo: documentId)
        .snapshots()
        .map((event) => event.docs.map((doc) => PatientProfile.fromSnapshot(
            doc.data() as QueryDocumentSnapshot<Map<String, dynamic>>)));
    return profile;
  }

  Future<PatientProfile> createNewPatientProfile(
      {required String userId}) async {
    try {
      final document = await patientProfile.add({
        patientUserIdFieldName: userId,
        medicalHistoryFieldName: [],
        genderFieldName: '',
        phoneNumberFieldName: '',
        ageFieldName: 0,
        allergiesFieldName: [],
        addressFieldName: '',
        patientNameFieldName: '',
        currentMedicationFieldName: []
      });
      final fetchedProfile = await document.get();
      return PatientProfile(
        documentId: fetchedProfile.id,
        userId: userId,
        medicalHistory: [],
        gender: '',
        phoneNumber: '',
        age: 0,
        allergies: [],
        address: '',
        names: '',
        currentMedications: [],
      );
    } catch (e) {
      throw CouldNotCreateProfileException();
    }
  }

  Future<PatientProfile?> getPatientProfileByUserId(String userId) async {
    try {
      // Step 1: Get the user document by user_id
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(patientUserIdFieldName, isEqualTo: userId)
          .get();

      if (userQuerySnapshot.docs.isEmpty) {
        return null;
      }

      final userDoc = userQuerySnapshot.docs.first;
      print("user doc id");
      print(userDoc.id);
      // Step 2: Get the patient profile from the subcollection
      final patientProfileQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('patientProfile')
          .get();

      if (patientProfileQuerySnapshot.docs.isEmpty) {
        return null;
      }

      final patientProfileDoc = patientProfileQuerySnapshot.docs.first;
      print("ni hapa");
      print(patientProfileDoc.id);
      print(patientProfileDoc);
      return PatientProfile.fromSnapshot(patientProfileDoc);
    } catch (e) {
      print('Error getting patient profile: $e');
      return null;
    }
  }
}
