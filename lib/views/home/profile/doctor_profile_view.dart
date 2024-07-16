import 'package:afyaexpress/enums/menu_actions.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/auth/bloc/auth_state.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile.dart';
import 'package:afyaexpress/utilities/dialogs/logout_dialog.dart';
import 'package:afyaexpress/utilities/generics/get_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({Key? key}) : super(key: key);

  @override
  _DoctorProfileViewState createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  DoctorProfile? _doctorProfile;
  late final FirebaseDoctorProfile _doctorService;
  late final TextEditingController _specializationsController;
  late final TextEditingController _chargesController;
  late final TextEditingController _medicIdController;
  late final TextEditingController _addressController;
  late final TextEditingController _idCardController;

  bool _isAvailable = true;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _doctorService = FirebaseDoctorProfile();
    _specializationsController = TextEditingController();
    _chargesController = TextEditingController();
    _medicIdController = TextEditingController();
    _addressController = TextEditingController();
    _idCardController = TextEditingController();
    _isAvailable = true;

    _specializationsController.addListener(_specializationsControllerListener);
    _chargesController.addListener(_chargesControllerListener);
    _medicIdController.addListener(_medicIdControllerListener);
    _addressController.addListener(_addressControllerListener);
    _idCardController.addListener(_idCardControllerListener);

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
        _specializationsController.text = existingProfile.specialization;
        _chargesController.text = existingProfile.charges;
        // _medicIdController.text = existingProfile.medicIdentifier;
        //_addressController.text = existingProfile.address;
        //_idCardController.text = existingProfile.identityCardNo;
        _isAvailable = existingProfile.isAvailable;
        _latitude = existingProfile.latitude;
        _longitude = existingProfile.longitude;
      });
    } else {
      final newProfile =
          await _doctorService.createNewDoctorProfile(doctorUserId: userId);
      setState(() {
        _doctorProfile = newProfile;
        _specializationsController.text = newProfile.specialization;
        _chargesController.text = newProfile.charges;
        _medicIdController.text = newProfile.licenseNumber;
        _addressController.text = newProfile.address;
        _idCardController.text = newProfile.licenseNumber;
        _isAvailable = newProfile.isAvailable;
        _latitude = newProfile.latitude;
        _longitude = newProfile.longitude;
      });
    }
  }

  void _specializationsControllerListener() async {
    final doctorProfile = _doctorProfile;
    if (doctorProfile == null) return;

    final specialization = _specializationsController.text;
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      specialization: specialization,
    );
  }

  void _chargesControllerListener() async {
    final doctorProfile = _doctorProfile;
    if (doctorProfile == null) return;
    final charges = _chargesController.text;
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      charges: charges,
    );
  }

  void _medicIdControllerListener() async {
    final doctorProfile = _doctorProfile;
    if (doctorProfile == null) return;
    final medicId = _medicIdController.text;
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      licenseNumber: medicId,
    );
  }

  void _addressControllerListener() async {
    final doctorProfile = _doctorProfile;
    if (doctorProfile == null) return;
    final address = _addressController.text;
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      address: address,
    );
  }

  void _idCardControllerListener() async {
    final doctorProfile = _doctorProfile;
    if (doctorProfile == null) return;
    final idCard = _idCardController.text;
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      //identityCardNo: idCard,
    );
  }

  void _isAvailableControllerListener() async {
    final doctorProfile = _doctorProfile;
    if (doctorProfile == null) return;
    final isAvailable = _isAvailable;
    await _doctorService.updateDoctorProfile(
      documentId: doctorProfile.documentId,
      isAvailable: isAvailable,
    );
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> getCurrentLocation() async {
    await requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _addressController.text =
          placemarks.first.street! + ", " + placemarks.first.locality!;
    });
  }

  @override
  void dispose() {
    _specializationsController.dispose();
    _addressController.dispose();
    _chargesController.dispose();
    _idCardController.dispose();
    _medicIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
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
                controller: _specializationsController,
                decoration: InputDecoration(labelText: 'Specializations'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your specializations';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _chargesController,
                decoration: InputDecoration(labelText: 'Charges'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your charges in Ksh';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _medicIdController,
                decoration:
                    InputDecoration(labelText: 'Medical Identity Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your medical identity number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idCardController,
                decoration:
                    const InputDecoration(labelText: 'Identity Card Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your medical identity number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              ElevatedButton(
                onPressed: getCurrentLocation,
                child: Text('Pick Location'),
              ),
              SwitchListTile(
                title: Text('Available'),
                value: _isAvailable,
                onChanged: (bool value) async {
                  setState(() {
                    _isAvailable = value;
                  });
                  final doctorProfile = _doctorProfile;
                  if (doctorProfile != null) {
                    await _doctorService.updateDoctorProfile(
                        documentId: doctorProfile.documentId,
                        isAvailable: _isAvailable);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
