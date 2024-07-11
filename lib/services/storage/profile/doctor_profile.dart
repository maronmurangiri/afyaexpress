import 'package:afyaexpress/services/storage/profile/doctor_profile_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class DoctorProfile {
  final String documentId;
  final String doctorUserId;
  final String specialization;
  final String charges;
  final String medicIdentifier;
  final double latitude;
  final double longitude;
  final String address;
  final bool isAvailable;
  final String identityCardNo;

  const DoctorProfile(
      {required this.documentId,
      required this.doctorUserId,
      required this.specialization,
      required this.charges,
      required this.medicIdentifier,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.isAvailable,
      required this.identityCardNo});

  DoctorProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        doctorUserId = snapshot.data()[doctorUserIdFieldName] ?? '',
        specialization = snapshot.data()[specializationFieldName] ?? '',
        charges = snapshot.data()[chargesFieldName] ?? '',
        medicIdentifier = snapshot.data()[medicIdentifierFieldName] ?? '',
        latitude = snapshot.data()[latitudeFieldName] ?? 0.00,
        longitude = snapshot.data()[longitudeFieldName] ?? 0.00,
        address = snapshot.data()[addressFieldName] ?? '',
        isAvailable = snapshot.data()[isAvailableFieldName] ?? true,
        identityCardNo = snapshot.data()[identityCardNoFieldName] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'userId': doctorUserId,
      'specialization': specialization,
      'charges': charges,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isAvailable': isAvailable,
      'identityCardNo': identityCardNo,
      'medicIdentifier': medicIdentifier
    };
  }
}
