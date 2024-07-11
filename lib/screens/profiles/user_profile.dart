import 'package:afyaexpress/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController medicalHistoryController =
      TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorContactController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  String? profileImage;
  bool underMedication = false;
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
              controller: locationController,
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
                final String firstName = firstNameController.text;
                final String lastName = lastNameController.text;
                final String email = emailController.text;
                final String location = locationController.text;

                // You can now use these values to update the user profile
                // For example, send them to a backend service

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile updated successfully!')),
                );
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
