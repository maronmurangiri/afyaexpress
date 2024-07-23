import 'package:afyaexpress/enums/menu_actions.dart';
import 'package:afyaexpress/global/global.dart';
import 'package:afyaexpress/screens/appointment.dart';
import 'package:afyaexpress/screens/appointment_card.dart';
import 'package:afyaexpress/screens/doctor.dart';
import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/screens/profiles/user_profile.dart';
import 'package:afyaexpress/screens/vitals_capture.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/auth/bloc/auth_bloc.dart';
import 'package:afyaexpress/services/auth/bloc/auth_event.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_patient_profile.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:afyaexpress/utilities/dialogs/logout_dialog.dart';
import 'package:afyaexpress/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final currentUser;
  late FirebasePatientProfile currentPatient;
  Map<String, dynamic>? currentProfile;
  bool isLoading = true;
  List<Map<String, dynamic>> doctors = [];

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _fetchDoctors();
  }

  Future<void> _initializeUser() async {
    currentUser = AuthService.firebase().currentUser!;
    currentPatient = FirebasePatientProfile();
    currentProfile = (await currentPatient.getPatientById(currentUser.id))
        as Map<String, dynamic>?;
    print(currentProfile);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchDoctors() async {
    try {
      FirebaseDoctorProfile firebaseDoctorProfile = FirebaseDoctorProfile();
      List<Map<String, dynamic>> fetchedDoctors =
          await firebaseDoctorProfile.fetchDoctors();
      setState(() {
        doctors = fetchedDoctors;
      });
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  final List<Map<String, dynamic>> medCat = const [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynae",
    },
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Navigate to Home page
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VitalsCapture()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Appointment()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AfyaExpress'),
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
                      'Hi ${currentProfile?['first_name'] ?? 'User'}',
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
                              builder: (context) => const UserProfile()),
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
                Config.spaceBig,
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                SizedBox(
                  height: Config.heightSize * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return Card(
                        margin: const EdgeInsets.only(right: 20),
                        color: IndexPage.primaryBlue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FaIcon(medCat[index]['icon'],
                                  color: Colors.white),
                              const SizedBox(width: 20),
                              Text(
                                medCat[index]['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
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
                const AppointmentCard(),
                Config.spaceSmall,
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                Column(
                  children: doctors.map((doctor) {
                    return DoctorCard(
                      doctorName: doctor['name'] ?? 'Unknown Doctor',
                      specialization:
                          doctor['specialization'] ?? 'Unknown Specialization',
                    );
                  }).toList(),
                ),
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
            label: 'Capture Vitals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
