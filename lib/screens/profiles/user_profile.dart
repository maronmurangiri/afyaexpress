//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart'
//  hide String, double;

import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_patient_profile.dart';
import 'package:afyaexpress/services/storage/profile/patient_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:afyaexpress/utilities/current_location.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  PatientProfile? _patientProfile;
  late FirebasePatientProfile _patientService;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController ageController;

  late final TextEditingController locationController;
  late final TextEditingController medicalHistoryController;
  late final TextEditingController medicationController;
  late final TextEditingController doctorNameController;
  late final TextEditingController doctorContactController;
  late final TextEditingController allergiesController;

  String? selectedGender;
  String? profileImage;
  late double _latitude;
  late double _longitude;
  bool _isLocationPicked = false;

  bool underMedication = false;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
    locationController = TextEditingController();
    medicalHistoryController = TextEditingController();
    medicationController = TextEditingController();
    doctorNameController = TextEditingController();
    doctorContactController = TextEditingController();
    allergiesController = TextEditingController();
    _patientService = FirebasePatientProfile();

    _initializeProfile();
  }

  void _initializeProfile() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final existingProfile =
        await _patientService.getPatientProfileByUserId(userId);
    print(existingProfile!.documentId);
    print(existingProfile!.firstName);
    if (existingProfile != null) {
      setState(() {
        _patientProfile = existingProfile;
        firstNameController.text = existingProfile.firstName;
        lastNameController.text = existingProfile.lastName;
        emailController.text = currentUser.email;
        phoneController.text = existingProfile.phoneNumber;
        ageController.text = existingProfile.age.toString();
        locationController.text = existingProfile.address;
        selectedGender = existingProfile.gender;
        medicalHistoryController.text = existingProfile.medicalHistory!;
        doctorNameController.text = existingProfile.doctorName!;
        doctorContactController.text = existingProfile.doctorContact!;
        allergiesController.text = existingProfile.allergies!.join(', ');
        medicationController.text =
            existingProfile.currentMedications!.join(', ');
      });
    } else {
      final newProfile =
          await _patientService.createNewPatientProfile(userId: userId);
      setState(() {
        _patientProfile = newProfile;
        firstNameController.text = newProfile.firstName;
        lastNameController.text = newProfile.lastName;
        emailController.text = newProfile.email!;
        phoneController.text = newProfile.phoneNumber;
        ageController.text = newProfile.age.toString();
        locationController.text = newProfile.address;
        selectedGender = newProfile.gender;
        medicalHistoryController.text = newProfile.medicalHistory!;
        doctorNameController.text = newProfile.doctorName!;
        doctorContactController.text = newProfile.doctorContact!;
        allergiesController.text = newProfile.allergies!.join(', ');
        medicationController.text = newProfile.currentMedications!.join(', ');
      });
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        profileImage = pickedImage.path;
      });
    }
  }

  Future<void> _pickFile() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        medicalHistoryController.text = pickedFile.path;
      });
    }
  }

  Future<void> _fetchLocation() async {
    LocationService locationService = LocationService();

    try {
      Map<String, dynamic> locationData =
          await locationService.getCurrentLocation();
      setState(() {
        _latitude = locationData['latitude'];
        _longitude = locationData['longitude'];
        locationController.text = locationData['address'];
        _isLocationPicked = locationData['isLocationPicked'];
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _submitProfile() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    // Upload profile image
    String? profileImageUrl;
    if (profileImage != null) {
      profileImageUrl = await _patientService.uploadFile(
          profileImage!, 'profiles/$userId/profileImage');
    }
    final patientProfile = _patientProfile;

    if (patientProfile == null) return;
    // Update profile data
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      age: int.tryParse(ageController.text),
      address: locationController.text,
      gender: selectedGender,
      profileImage: profileImageUrl,
      currentMedications: medicationController.text.split(', '),
      //medicalHistory: medicalHistoryController.text.split(', '),
      //doctorName: doctorNameController.text,
      //doctorContact: doctorContactController.text,
      //allergies: allergiesController.text.split(', '),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  Future<void> _submitMedicalHistory() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    // Upload medical history file
    String? medicalHistoryFileUrl;
    if (medicalHistoryController.text.isNotEmpty) {
      medicalHistoryFileUrl = await _patientService.uploadFile(
          medicalHistoryController.text, 'profiles/$userId/medicalHistory');
    }

    final patientProfile = _patientProfile;
    if (patientProfile == null) return;
    // Update profile data with medical history
    await _patientService.updatePatientProfile(
      documentId: patientProfile.documentId,
      medicalHistoryFile: medicalHistoryFileUrl,
      medicalHistory: medicalHistoryController.text,
      doctorName: doctorNameController.text,
      doctorContact: doctorContactController.text,
      allergies: allergiesController.text.split(', '),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medical history updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: IndexPage.primaryBlue,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: IndexPage.primaryBlue, // Background color
            foregroundColor: Colors.white, // Foreground color
          ),
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('User Profile'),
            backgroundColor: IndexPage.primaryBlue,
            foregroundColor: Colors.white,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Profile'),
                Tab(text: 'Medical History'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildProfileTab(context),
              _buildMedicalHistoryTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImage != null
                    ? FileImage(File(profileImage!))
                    : null,
                child: profileImage == null
                    ? const Icon(Icons.add_a_photo, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Adjust alignment as needed
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text('Male'),
                  ],
                ),
                const SizedBox(width: 20),
                // Add some spacing between the options
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'Other',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text('Other'),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _fetchLocation,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    vertical: 9, horizontal: 60), // Adjust padding as needed
              ),
              child: const Text('Pick Location'),
            ),
            SizedBox(height: 15),
            if (_isLocationPicked)
              TextField(
                controller: locationController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Are you under any current medication?'),
              value: underMedication,
              onChanged: (bool value) {
                setState(() {
                  underMedication = value;
                });
                if (value) {
                  _showMedicationDialog(context);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the update logic here
                /* final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                final email = emailController.text;
                final phone = phoneController.text;
                final age = ageController.text;
                final location = locationController.text;
                final gender = selectedGender;
                final medicalHistory = medicalHistoryController.text;
                final doctorName = doctorNameController.text;
                final doctorContact = doctorContactController.text;
                final allegies = allergiesController.text;
                final medication = medicationController.text;*/
                // You can now use these values to update the user profile
                // For example, send them to a backend service
                _submitProfile();
                /*ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile updated successfully!')),
                );*/
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryTab(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: medicalHistoryController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Medical History',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Upload Medical History (PDF, JPEG, PNG)'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: doctorNameController,
              decoration: const InputDecoration(
                labelText: 'Doctor\'s Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: doctorContactController,
              decoration: const InputDecoration(
                labelText: 'Doctor\'s Contact',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: allergiesController,
              decoration: const InputDecoration(
                labelText: 'Allergies',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _submitMedicalHistory();
                /*ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Medical History updated successfully!')),
                );*/
              },
              child: const Text('Update Medical History'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMedicationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Current Medication'),
          content: TextField(
            controller: medicationController,
            decoration: const InputDecoration(
              labelText: 'Specify Medication',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
