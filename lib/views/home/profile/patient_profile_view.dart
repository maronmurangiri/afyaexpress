import 'package:afyaexpress/enums/menu_actions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_patient_profile.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile.dart';
import 'package:afyaexpress/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientProfileView extends StatefulWidget {
  const PatientProfileView({Key? key}) : super(key: key);

  @override
  _PatientProfileViewState createState() => _PatientProfileViewState();
}

class _PatientProfileViewState extends State<PatientProfileView> {
  PatientProfile? _patientProfile;
  late final FirebasePatientProfile _patientService;
  late final TextEditingController _medicalHistoryController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _ageController;
  late final TextEditingController _addressController;
  late final TextEditingController _namesController;
  late final TextEditingController _currentMedicationsController;
  late final TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _patientService = FirebasePatientProfile();
    _medicalHistoryController = TextEditingController();
    _allergiesController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _ageController = TextEditingController();
    _addressController = TextEditingController();
    _namesController = TextEditingController();
    _currentMedicationsController = TextEditingController();
    _genderController = TextEditingController();

    _medicalHistoryController.addListener(_medicalHistoryControllerListener);
    _allergiesController.addListener(_allergiesControllerListener);
    _phoneNumberController.addListener(_phoneNumberControllerListener);
    _ageController.addListener(_ageControllerListener);
    _addressController.addListener(_addressControllerListener);
    _namesController.addListener(_namesControllerListener);
    _currentMedicationsController
        .addListener(_currentMedicationsControllerListener);
    _genderController.addListener(_genderControllerListener);

    _initializeProfile();
  }

  void _initializeProfile() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final existingProfile =
        await _patientService.getPatientProfileByUserId(userId);

    if (existingProfile != null) {
      setState(() {
        _patientProfile = existingProfile;
        _medicalHistoryController.text =
            existingProfile.medicalHistory.join(', ');
        _allergiesController.text = existingProfile.allergies.join(', ');
        _phoneNumberController.text = existingProfile.phoneNumber;
        _ageController.text = existingProfile.age.toString();
        _addressController.text = existingProfile.address;
        _namesController.text = existingProfile.names;
        _currentMedicationsController.text =
            existingProfile.currentMedications.join(', ');
        _genderController.text = existingProfile.gender;
      });
    } else {
      final newProfile =
          await _patientService.createNewPatientProfile(userId: userId);
      setState(() {
        _patientProfile = newProfile;
        _medicalHistoryController.text = newProfile.medicalHistory.join(', ');
        _allergiesController.text = newProfile.allergies.join(', ');
        _phoneNumberController.text = newProfile.phoneNumber;
        _ageController.text = newProfile.age.toString();
        _addressController.text = newProfile.address;
        _namesController.text = newProfile.names;
        _currentMedicationsController.text =
            newProfile.currentMedications.join(', ');
        _genderController.text = newProfile.gender;
      });
    }
  }

  void _medicalHistoryControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final medicalHistory = _medicalHistoryController.text.split(',').toList();
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      medicalHistory: medicalHistory,
    );
  }

  void _allergiesControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final allergies = _allergiesController.text.split(',').toList();
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      allergies: allergies,
    );
  }

  void _phoneNumberControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final phoneNumber = _phoneNumberController.text;
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      phoneNumber: phoneNumber,
    );
  }

  void _ageControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final age = int.tryParse(_ageController.text);
    if (age != null) {
      await _patientService.updatePatientProfile(
        documentId: patientProfile.documentId,
        age: age,
      );
    }
  }

  void _addressControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final address = _addressController.text;
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      address: address,
    );
  }

  void _namesControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final names = _namesController.text;
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      names: names,
    );
  }

  void _currentMedicationsControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final currentMedications = _currentMedicationsController.text;
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      currentMedications: currentMedications.split(',').toList(),
    );
  }

  void _genderControllerListener() async {
    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    final gender = _genderController.text;
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      gender: gender,
    );
  }

  @override
  void dispose() {
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _namesController.dispose();
    _currentMedicationsController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Patient Profile'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _namesController,
                decoration: InputDecoration(labelText: 'Names'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medicalHistoryController,
                decoration: InputDecoration(labelText: 'Medical History'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your medical history';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(labelText: 'Allergies'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your allergies';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _currentMedicationsController,
                decoration: InputDecoration(labelText: 'Current Medications'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current medications';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
