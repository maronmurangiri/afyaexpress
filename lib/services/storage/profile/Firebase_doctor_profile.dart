import 'dart:io';

import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_constants.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDoctorProfile {
  final AuthUser? user;
  late final CollectionReference doctorProfile;

  FirebaseDoctorProfile() : user = FirebaseAuthProvider().currentUser {
    if (user != null) {
      doctorProfile = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .collection('doctorProfile');
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> deleteDoctorProfile({required String documentId}) async {
    try {
      await doctorProfile.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteProfileException();
    }
  }

  Future<void> updateDoctorProfile(
      {required String documentId,
      String? specialization,
      String? charges,
      String? licenseNumber,
      double? latitude,
      double? longitude,
      String? address,
      bool? isAvailable,
      String? name,
      String? phoneNumber,
      String? experience,
      String? email,
      String? profileImage}) async {
    try {
      final updates = <String, dynamic>{};

      if (specialization != null) {
        updates[specializationFieldName] = specialization;
      }
      if (charges != null) updates[chargesFieldName] = charges;
      if (licenseNumber != null) {
        updates[licenseNumberFieldName] = licenseNumber;
      }
      if (latitude != null) updates[latitudeFieldName] = latitude;
      if (longitude != null) updates[longitudeFieldName] = longitude;
      if (address != null) updates[addressFieldName] = address;
      if (isAvailable != null) updates[isAvailableFieldName] = isAvailable;
      if (name != null) {
        updates[medicNameFieldName] = name;
      }
      if (phoneNumber != null) {
        updates[phoneNumberFieldName] = phoneNumber;
      }
      if (experience != null) {
        updates[medicExperienceFieldName] = experience;
      }
      if (isAvailable != null) {
        updates[isAvailableFieldName] = isAvailable;
      }
      if (email != null) {
        updates[medicEmailFieldName] = email;
      }
      if (profileImage != null) {
        updates[profileImageFieldName] = profileImage;
      }

      await doctorProfile.doc(documentId).update(updates);
    } catch (e) {
      print('Error updating profile: $e');
      throw CouldNotUpdateProfileException();
    }
  }

  Stream<Iterable<DoctorProfile>> viewProfile({required String documentId}) {
    final profile = doctorProfile
        .where(doctorUserIdFieldName, isEqualTo: documentId)
        .snapshots()
        .map((event) => event.docs.map((doc) => DoctorProfile.fromSnapshot(
            doc.data() as QueryDocumentSnapshot<Map<String, dynamic>>)));
    return profile;
  }

  Future<DoctorProfile> createNewDoctorProfile(
      {required String doctorUserId}) async {
    try {
      final document = await doctorProfile.add({
        doctorUserIdFieldName: doctorUserId,
        specializationFieldName: '',
        chargesFieldName: 0,
        licenseNumberFieldName: '',
        latitudeFieldName: 0.000,
        longitudeFieldName: 0.00,
        addressFieldName: '',
        isAvailableFieldName: true,
        medicNameFieldName: '',
        phoneNumberFieldName: '',
        medicExperienceFieldName: '',
        medicEmailFieldName: '',
        profileImageFieldName: ''
      });
      final fetchedProfile = await document.get();
      return DoctorProfile(
          documentId: fetchedProfile.id,
          doctorUserId: doctorUserId,
          specialization: '',
          charges: '',
          licenseNumber: '',
          latitude: 0.00,
          longitude: 0.00,
          address: '',
          isAvailable: true,
          name: '',
          experience: '',
          email: '',
          profileImage: null,
          phone: '');
    } catch (e) {
      throw CouldNotCreateProfileException();
    }
  }

  Future<DoctorProfile?> getDoctorProfileByUserId(String userId) async {
    try {
      // Step 1: Get the user document by user_id
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userQuerySnapshot.docs.isEmpty) {
        return null;
      }

      final userDoc = userQuerySnapshot.docs.first;
      print("user doc id");
      print(userDoc.id);
      // Step 2: Get the doctor profile from the subcollection
      final doctorProfileQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .collection('doctorProfile')
          .get();

      if (doctorProfileQuerySnapshot.docs.isEmpty) {
        return null;
      }

      final doctorProfileDoc = doctorProfileQuerySnapshot.docs.first;
      print("ni hapa");
      print(doctorProfileDoc.id);
      print(doctorProfileDoc);
      return DoctorProfile.fromSnapshot(doctorProfileDoc);
    } catch (e) {
      print('Error getting doctor profile: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      // Step 1: Get all users with role 'medic'
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Medic')
          .get();

      List<Map<String, dynamic>> doctors = [];

      for (var userDoc in userQuerySnapshot.docs) {
        // Step 2: Get the doctor profile from the subcollection
        final doctorProfileQuerySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('doctorProfile')
            .get();

        if (doctorProfileQuerySnapshot.docs.isNotEmpty) {
          final doctorProfileDoc = doctorProfileQuerySnapshot.docs.first;
          Map<String, dynamic> doctorData = doctorProfileDoc.data();
          doctorData['userId'] = userDoc.id; // Adding userId to the doctor data
          doctors.add(doctorData);
          print(doctors);
        }
      }
      return doctors;
    } catch (e) {
      print('Error fetching doctors: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getDoctorById(String userId) async {
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
      final doctorProfileQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('doctorProfile')
          .get();

      if (doctorProfileQuerySnapshot.docs.isEmpty) {
        print('doctor profile not found');
        return null;
      }

      final doctorProfileDoc = doctorProfileQuerySnapshot.docs.first;
      Map<String, dynamic> doctorData = doctorProfileDoc.data();
      doctorData['userId'] = userId; // Adding userId to the patient data
      print(doctorData);

      return doctorData;
    } catch (e) {
      print('Error fetching patient profile: $e');
      throw e;
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
  //static final FirebaseDoctorProfile _shared =
  //  FirebaseDoctorProfile._sharedInstance();
  //FirebaseDoctorProfile._sharedInstance();
  //factory FirebaseDoctorProfile() => _shared;
}
