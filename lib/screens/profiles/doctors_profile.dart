import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile.dart';
import 'package:afyaexpress/utilities/current_location.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  DoctorProfile? _doctorProfile;
  late FirebaseDoctorProfile _doctorService;
  late final TextEditingController nameController;
  late final TextEditingController experienceController;
  late final TextEditingController specializationController;
  late final TextEditingController chargesController;
  late final TextEditingController phoneController;
  late final TextEditingController licenseController;
  late final TextEditingController emailController;
  late final TextEditingController locationController;

  bool _isAvailable = true;
  String? profileImage;
  double _latitude = 0.0; // Default value
  double _longitude = 0.0; // Default value
  bool _isLocationPicked = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    experienceController = TextEditingController();
    specializationController = TextEditingController();
    chargesController = TextEditingController();
    phoneController = TextEditingController();
    licenseController = TextEditingController();
    emailController = TextEditingController();
    locationController = TextEditingController();
    _doctorService = FirebaseDoctorProfile();

    _initializeProfile();
  }

  void _initializeProfile() async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final existingProfile =
        await _doctorService.getDoctorProfileByUserId(userId);

    if (existingProfile != null) {
      setState(() {
        _doctorProfile = existingProfile;
        nameController.text = existingProfile.name;
        emailController.text = existingProfile.email;
        phoneController.text = existingProfile.phone;
        locationController.text = existingProfile.address;
        experienceController.text = existingProfile.experience;
        specializationController.text = existingProfile.specialization;
        chargesController.text = existingProfile.charges;
        licenseController.text = existingProfile.licenseNumber;
        _isAvailable = existingProfile.isAvailable;
      });
    } else {
      final newProfile =
          await _doctorService.createNewDoctorProfile(doctorUserId: userId);
      setState(() {
        _doctorProfile = newProfile;
        nameController.text = newProfile.name;
        emailController.text = newProfile.email;
        phoneController.text = newProfile.phone;
        locationController.text = newProfile.address;
        experienceController.text = newProfile.experience;
        specializationController.text = newProfile.specialization;
        chargesController.text = newProfile.charges;
        licenseController.text = newProfile.licenseNumber;
        _isAvailable = newProfile.isAvailable;
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
      profileImageUrl = await _doctorService.uploadFile(
          profileImage!, 'profiles/$userId/profileImage');
    }
    final doctorProfile = _doctorProfile;

    if (doctorProfile == null) return;
    // Update profile data
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      address: locationController.text,
      experience: experienceController.text,
      specialization: specializationController.text,
      charges: chargesController.text,
      licenseNumber: licenseController.text,
      isAvailable: _isAvailable,
      profileImage: profileImageUrl,
      latitude: _latitude,
      longitude: _longitude,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Background color
            foregroundColor: Colors.white, // Foreground color
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Doctor Profile'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: chargesController,
                  decoration: const InputDecoration(
                    labelText: 'Charges',
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
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: licenseController,
                  decoration: const InputDecoration(
                    labelText: 'License Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchLocation,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 60), // Adjust padding as needed
                  ),
                  child: const Text('Pick Location'),
                ),
                const SizedBox(height: 15),
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
                  title: const Text('Available for consultation?'),
                  value: _isAvailable,
                  onChanged: (bool value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitProfile,
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
