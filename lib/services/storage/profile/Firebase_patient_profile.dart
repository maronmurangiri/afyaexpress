import 'dart:io';

import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile_constants.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    String? medicalHistory,
    String? gender,
    String? email,
    String? doctorName,
    String? doctorContact,
    String? phoneNumber,
    int? age,
    List<String>? allergies,
    String? address,
    String? firstName,
    String? lastName,
    String? profileImage,
    String? medicalHistoryFile,
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
      if (firstName != null) updates[patientFirstNameFieldName] = firstName;
      if (lastName != null) updates[patientLastNameFieldName] = lastName;
      if (email != null) updates[emailFieldName] = email;
      if (doctorName != null) updates[doctorNameFieldName] = doctorName;
      if (doctorContact != null) {
        updates[doctorContactFieldName] = doctorContact;
      }
      if (currentMedications != null) {
        updates[currentMedicationFieldName] = currentMedications;
      }
      if (profileImage != null) {
        updates[profileImageFieldName] = profileImage;
      }
      if (medicalHistoryFile != null) {
        updates[medicalHistoryFileNameFieldName] = medicalHistoryFile;
      }

      await patientProfile.doc(documentId).update(updates);
      print("document ID");
      print(documentId);
    } catch (e) {
      print('Error updating profile: $e');
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
        medicalHistoryFieldName: '',
        genderFieldName: '',
        phoneNumberFieldName: '',
        ageFieldName: 0,
        allergiesFieldName: [],
        addressFieldName: '',
        patientFirstNameFieldName: '',
        patientLastNameFieldName: '',
        currentMedicationFieldName: [],
        profileImageFieldName: null,
        medicalHistoryFileNameFieldName: null,
      });
      final fetchedProfile = await document.get();
      return PatientProfile(
        documentId: fetchedProfile.id,
        userId: userId,
        medicalHistory: '',
        gender: '',
        phoneNumber: '',
        age: 0,
        allergies: [],
        address: '',
        firstName: '',
        lastName: '',
        profileImage: null,
        medicalHistoryFile: null,
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

  Future<String?> uploadFile(String filePath, String destinationPath) async {
    try {
      // Get a reference to the storage service
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(destinationPath);

      // Create a file from the given file path
      final File file = File(filePath);

      // Upload the file to the storage reference
      final UploadTask uploadTask = storageReference.putFile(file);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      // Handle errors (e.g., upload failed)
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPatientById(String userId) async {
    try {
      // Step 1: Get the user document by userId
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDocSnapshot.exists) {
        print('User not found');
        return null;
      }

      // Step 2: Get the patient profile from the subcollection
      final patientProfileQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('patientProfile')
          .get();

      if (patientProfileQuerySnapshot.docs.isEmpty) {
        print('Patient profile not found');
        return null;
      }

      final patientProfileDoc = patientProfileQuerySnapshot.docs.first;
      Map<String, dynamic> patientData = patientProfileDoc.data();
      patientData['userId'] = userId; // Adding userId to the patient data
      print(patientData);

      return patientData;
    } catch (e) {
      print('Error fetching patient profile: $e');
      throw e;
    }
  }
}
