import 'package:afyaexpress/services/storage/profile/doctor_profile_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class DoctorProfile {
  final String documentId;
  final String doctorUserId;
  final String specialization;
  final String charges;
  final String licenseNumber;
  final double latitude;
  final double longitude;
  final String address;
  final bool isAvailable;
  final String name;
  final String experience;
  final String phone;
  final String email;
  final String? profileImage;

  const DoctorProfile(
      {required this.documentId,
      required this.doctorUserId,
      required this.specialization,
      required this.charges,
      required this.licenseNumber,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.isAvailable,
      required this.experience,
      required this.phone,
      required this.email,
      this.profileImage,
      required this.name});

  DoctorProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        doctorUserId = snapshot.data()[doctorUserIdFieldName] ?? '',
        specialization = snapshot.data()[specializationFieldName] ?? '',
        charges = snapshot.data()[chargesFieldName] ?? '',
        licenseNumber = snapshot.data()[licenseNumberFieldName] ?? '',
        latitude = snapshot.data()[latitudeFieldName] ?? 0.00,
        longitude = snapshot.data()[longitudeFieldName] ?? 0.00,
        address = snapshot.data()[addressFieldName] ?? '',
        isAvailable = snapshot.data()[isAvailableFieldName] ?? true,
        name = snapshot.data()[medicNameFieldName] ?? '',
        experience = snapshot.data()[medicExperienceFieldName] ?? '',
        phone = snapshot.data()[phoneNumberFieldName] ?? '',
        email = snapshot.data()[medicEmailFieldName] ?? '',
        profileImage = snapshot.data()[profileImageFieldName] is String
            ? snapshot.data()[profileImageFieldName]
            : null;

  Map<String, dynamic> toMap() {
    return {
      'userId': doctorUserId,
      'specialization': specialization,
      'charges': charges,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isAvailable': isAvailable,
      'name': name,
      'licenseNumber': licenseNumber,
      'experience': experience,
      'phone': phone,
      'email': email,
      'profile_image': profileImage
    };
  }
}
