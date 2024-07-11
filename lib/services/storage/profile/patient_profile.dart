import 'package:afyaexpress/services/storage/profile/patient_profile_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class PatientProfile {
  final String documentId;
  final String userId;
  final List<String> medicalHistory;
  final String gender;
  final String phoneNumber;
  final int age;
  final List<String> allergies;
  final String address;
  final String names;
  final List<String> currentMedications;

  const PatientProfile({
    required this.documentId,
    required this.userId,
    required this.medicalHistory,
    required this.gender,
    required this.phoneNumber,
    required this.age,
    required this.allergies,
    required this.address,
    required this.names,
    required this.currentMedications,
  });

  PatientProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[patientUserIdFieldName] ?? '',
        medicalHistory =
            List<String>.from(snapshot.data()[medicalHistoryFieldName] ?? []),
        gender = snapshot.data()[genderFieldName] ?? '',
        phoneNumber = snapshot.data()[phoneNumberFieldName] ?? '',
        age = snapshot.data()[ageFieldName] ?? 0,
        allergies =
            List<String>.from(snapshot.data()[allergiesFieldName] ?? []),
        address = snapshot.data()[addressFieldName] ?? '',
        names = snapshot.data()[patientNameFieldName] ?? '',
        currentMedications = List<String>.from(
            snapshot.data()[currentMedicationFieldName] ?? []);

  Map<String, dynamic> toMap() {
    return {
      patientUserIdFieldName: userId,
      medicalHistoryFieldName: medicalHistory,
      genderFieldName: gender,
      phoneNumberFieldName: phoneNumber,
      ageFieldName: age,
      allergiesFieldName: allergies,
      addressFieldName: address,
      patientNameFieldName: names,
      currentMedicationFieldName: currentMedications,
    };
  }
}
