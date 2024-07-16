import 'package:afyaexpress/services/storage/profile/patient_profile_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class PatientProfile {
  final String documentId;
  final String userId;
  final String? medicalHistory;
  final String gender;
  final String? email;
  final String phoneNumber;
  final int age;
  final List<String>? allergies;
  final String address;
  final String firstName;
  final String lastName;
  final String? doctorName;
  final String? doctorContact;
  final List<String>? currentMedications;
  final String? profileImage;
  final String? medicalHistoryFile;

  const PatientProfile({
    required this.documentId,
    required this.userId,
    this.medicalHistory,
    required this.gender,
    required this.phoneNumber,
    required this.age,
    this.email,
    this.allergies,
    required this.address,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    this.medicalHistoryFile,
    this.doctorName,
    this.doctorContact,
    this.currentMedications,
  });

  PatientProfile.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[patientUserIdFieldName] ?? '',
        medicalHistory = (snapshot.data()[medicalHistoryFieldName] is String
            ? snapshot.data()[medicalHistoryFieldName]
            : ''),
        gender = snapshot.data()[genderFieldName] ?? '',
        email = snapshot.data()[emailFieldName] is String
            ? snapshot.data()[emailFieldName]
            : '',
        phoneNumber = snapshot.data()[phoneNumberFieldName] ?? '',
        age = snapshot.data()[ageFieldName] ?? 0,
        allergies = List<String>.from(
            snapshot.data()[allergiesFieldName] is List
                ? List<String>.from(snapshot.data()[allergiesFieldName])
                : []),
        address = snapshot.data()[addressFieldName] ?? '',
        firstName = snapshot.data()[patientFirstNameFieldName] ?? '',
        lastName = snapshot.data()[patientLastNameFieldName] ?? '',
        doctorName = snapshot.data()[doctorNameFieldName] is String
            ? snapshot.data()[doctorNameFieldName]
            : '',
        doctorContact = snapshot.data()[doctorContactFieldName] is String
            ? snapshot.data()[doctorContactFieldName]
            : '',
        currentMedications = List<String>.from(
          snapshot.data()[currentMedicationFieldName] is List
              ? List<String>.from(snapshot.data()[currentMedicationFieldName])
              : [],
        ),
        profileImage = snapshot.data()[profileImageFieldName] is String
            ? snapshot.data()[profileImageFieldName]
            : null,
        medicalHistoryFile =
            snapshot.data()[medicalHistoryFileNameFieldName] is String
                ? snapshot.data()[medicalHistoryFileNameFieldName]
                : null;

  Map<String, dynamic> toMap() {
    return {
      patientUserIdFieldName: userId,
      medicalHistoryFieldName: medicalHistory,
      genderFieldName: gender,
      phoneNumberFieldName: phoneNumber,
      ageFieldName: age,
      allergiesFieldName: allergies,
      addressFieldName: address,
      patientLastNameFieldName: firstName,
      patientFirstNameFieldName: lastName,
      currentMedicationFieldName: currentMedications,
      profileImageFieldName: profileImage,
      doctorNameFieldName: doctorName,
      doctorContactFieldName: doctorContact,
      medicalHistoryFileNameFieldName: medicalHistoryFile,
      emailFieldName: email
    };
  }
}
