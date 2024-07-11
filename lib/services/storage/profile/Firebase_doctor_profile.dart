import 'package:afyaexpress/services/auth/auth_exceptions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/auth_user.dart';
import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_constants.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> updateDoctorProfile({
    required String documentId,
    String? specialization,
    String? charges,
    String? medicIdentifier,
    double? latitude,
    double? longitude,
    String? address,
    bool? isAvailable,
    String? identityCardNo,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (specialization != null) {
        updates[specializationFieldName] = specialization;
      }
      if (charges != null) updates[chargesFieldName] = charges;
      if (medicIdentifier != null) {
        updates[medicIdentifierFieldName] = medicIdentifier;
      }
      if (latitude != null) updates[latitudeFieldName] = latitude;
      if (longitude != null) updates[longitudeFieldName] = longitude;
      if (address != null) updates[addressFieldName] = address;
      if (isAvailable != null) updates[isAvailableFieldName] = isAvailable;
      if (identityCardNo != null) {
        updates[identityCardNoFieldName] = identityCardNo;
      }
      if (isAvailable != null) {
        updates[isAvailableFieldName] = isAvailable;
      }

      await doctorProfile.doc(documentId).update(updates);
    } catch (e) {
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
        medicIdentifierFieldName: '',
        latitudeFieldName: 0.000,
        longitudeFieldName: 0.00,
        addressFieldName: '',
        isAvailableFieldName: true,
        identityCardNoFieldName: ''
      });
      final fetchedProfile = await document.get();
      return DoctorProfile(
        documentId: fetchedProfile.id,
        doctorUserId: doctorUserId,
        specialization: '',
        charges: '',
        medicIdentifier: '',
        latitude: 0.00,
        longitude: 0.00,
        address: '',
        isAvailable: true,
        identityCardNo: '',
      );
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
  //static final FirebaseDoctorProfile _shared =
  //  FirebaseDoctorProfile._sharedInstance();
  //FirebaseDoctorProfile._sharedInstance();
  //factory FirebaseDoctorProfile() => _shared;
}
