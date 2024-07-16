import 'package:afyaexpress/enums/menu_actions.dart';
import 'package:afyaexpress/screens/doctors_appointment_card.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:afyaexpress/services/storage/profile/doctor_profile.dart';
import 'package:afyaexpress/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'index.dart'; // Assuming this contains your primary color definitions
import 'package:afyaexpress/screens/appointment.dart';
import 'package:afyaexpress/screens/appointment_card.dart';
import 'package:afyaexpress/screens/doctor.dart';
import 'package:afyaexpress/screens/profiles/doctors_profile.dart';
import 'package:afyaexpress/screens/vitals_capture.dart';
import 'package:afyaexpress/utils/config.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int _selectedIndex = 0;
  bool _hasNewBooking = true; // Mocking new booking notification
  int _notificationCount = 5; // Mocking notification count

  // Dummy data for vitals, replace with actual data from vitals_capture.dart
  Map<String, dynamic>? _latestVitals;
  bool isLoading = true;
  Map<String, dynamic>? doctor;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  void updateLatestVitals(Map<String, dynamic> vitals) {
    setState(() {
      _latestVitals = vitals;
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Navigate to Home page
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VitalsCapture()),
        ).then((value) {
          // Assuming value is the vitals data returned from VitalsCapture
          if (value != null) {
            updateLatestVitals(value);
          }
        });
        break;
      case 2:
        // Navigate to Appointment page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Appointment()),
        );
        break;
      case 3:
        // Navigate to Profile page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorProfilePage()),
        );
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchPressed() {
    // Implement search functionality here
    // This method should handle searching for patients or any other global search functionality
    // You can show a search dialog or navigate to a search screen
    print('Search button pressed');
  }

  void _onNoteTakingPressed() {
    bool showPrescriptionOptions =
        false; // Flag to show/hide prescription options

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Take Notes'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your notes here...',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  if (showPrescriptionOptions) ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          onPressed: _onAddLabReportPressed,
                          label: Text('Lab Report'),
                          icon: Icon(Icons.description),
                          backgroundColor: Colors.blue,
                        ),
                        Config.spaceSmall,
                        FloatingActionButton.extended(
                          onPressed: _onAddPrescriptionPressed,
                          label: Text('Drug Prescription'),
                          icon: Icon(Icons.local_hospital),
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showPrescriptionOptions = true;
                        });
                      },
                      child: Text('Prescriptions'),
                    ),
                  ],
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    // Implement saving notes functionality
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> fetchDoctorDetails() async {
    final currentUser = AuthService.firebase().currentUser!;
    try {
      final fetchedDoctor =
          await FirebaseDoctorProfile().getDoctorById(currentUser.id);

      setState(() {
        doctor = fetchedDoctor;
        print('doctor name');
        print(doctor?['name']);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching appointment details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onAddLabReportPressed() {
    // Implement functionality to add lab report
    print('Add Lab Report pressed');
    // Example: Show a dialog to input lab report details
  }

  void _onAddPrescriptionPressed() {
    // Implement functionality to add prescription
    print('Add Prescription pressed');
    // Example: Show a dialog to input prescription details
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AfyaExpress'),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: _hasNewBooking
                    ? () {
                        // Display new booking popup
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('New Booking'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'You have a new booking!',
                                    style: TextStyle(
                                      color: IndexPage.primaryDanger,
                                    ),
                                  ),
                                  if (_latestVitals != null) ...[
                                    SizedBox(height: 10),
                                    Text(
                                      'Patient Vitals:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                        'Blood Pressure: ${_latestVitals!['bloodPressure']}'),
                                    Text(
                                        'Blood Sugar: ${_latestVitals!['bloodSugar']}'),
                                    Text(
                                        'Temperature: ${_latestVitals!['temperature']}'),
                                  ],
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('View Details'),
                                  onPressed: () {
                                    // Handle viewing details, e.g., navigate to details screen
                                    // Or expand details in the popup itself
                                    // For now, close the dialog
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    setState(() {
                                      _hasNewBooking = false;
                                      _notificationCount = 0;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: IndexPage.primaryDanger,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Welcome ${doctor?['name'] ?? 'Doctor'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DoctorProfilePage()),
                        );
                      },
                      child: const SizedBox(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('images/doc.png'),
                        ),
                      ),
                    ),
                  ],
                ),

                Config.spaceSmall,
                const Text(
                  'Appointment Today',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                const DoctorsAppointmentCard(),
                Config.spaceSmall,
                const Text(
                  'Captured Vitals',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                VitalsCaptureForm(),
                Config.spaceSmall,
                const Text(
                  'Patients Attended To',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                PatientsAttendedList(), // Integrating the PatientsAttendedList widget here
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: IndexPage.primaryMuted,
        selectedItemColor: IndexPage.primaryDark,
        unselectedItemColor: IndexPage.primaryBlue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onNoteTakingPressed,
        tooltip: 'Take Notes',
        child: Icon(Icons.note_add),
      ),
    );
  }
}

class VitalsCaptureForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Here we will fetch the data entered by the patient from the database
    // For simplicity(for now), we'll use static data.
    final vitalsData = [
      {
        'patient': 'John Doe',
        'bloodPressure': '120/80',
        'bloodSugar': '5.5',
        'temperature': '37.0'
      },
      {
        'patient': 'Jane Smith',
        'bloodPressure': '130/85',
        'bloodSugar': '6.0',
        'temperature': '36.8'
      },
    ];

    return Column(
      children: vitalsData.map((vital) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text('Patient: ${vital['patient']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blood Pressure: ${vital['bloodPressure']}'),
                Text('Blood Sugar: ${vital['bloodSugar']}'),
                Text('Temperature: ${vital['temperature']}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class PatientsAttendedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Here we will fetch the list of patients attended to from the database or API.

    final patients = [
      {
        'name': 'John Doe',
        'age': 45,
        'diagnosedDisease': 'Hypertension',
        'dateTreated': '2024-07-01',
        'charges': '200 USD',
      },
      {
        'name': 'Jane Muriithi',
        'age': 34,
        'diagnosedDisease': 'Diabetes',
        'dateTreated': '2024-07-02',
        'charges': '150 USD',
      },
      {
        'name': 'Michael Johnson',
        'age': 50,
        'diagnosedDisease': 'Cardiovascular Disease',
        'dateTreated': '2024-07-03',
        'charges': '300 USD',
      },
    ];

    return Column(
      children: patients.map((patient) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text('${patient['name']}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Patient Details'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Name: ${patient['name']}'),
                        Text('Age: ${patient['age']}'),
                        Text(
                            'Diagnosed Disease: ${patient['diagnosedDisease']}'),
                        Text('Date Treated: ${patient['dateTreated']}'),
                        Text('Charges: ${patient['charges']}'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
