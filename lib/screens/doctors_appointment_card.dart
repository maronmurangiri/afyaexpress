import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/storage/appointment/firebase_appointment.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_patient_profile.dart';
import 'package:afyaexpress/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorsAppointmentCard extends StatefulWidget {
  const DoctorsAppointmentCard({Key? key}) : super(key: key);

  @override
  State<DoctorsAppointmentCard> createState() => _DoctorsAppointmentCardState();
}

class _DoctorsAppointmentCardState extends State<DoctorsAppointmentCard> {
  Map<String, dynamic>? appointment;
  Map<String, dynamic>? patient;
  List<Map<String, dynamic>> conditions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final currentUser = AuthService.firebase().currentUser!;
    try {
      final fetchedAppointments = await fetchDoctorAppointments(currentUser.id);
      print("appointment details");
      print(fetchedAppointments);
      if (fetchedAppointments.isNotEmpty) {
        final appointmentData = fetchedAppointments.first;
        final patientId = appointmentData['patient_id'];
        final fetchedPatient =
            await FirebasePatientProfile().getPatientById(patientId);

        final fetchedConditions = await fetchPatientConditions(patientId);
        print('conditions');
        print(fetchedConditions);

        setState(() {
          appointment = appointmentData;
          patient = fetchedPatient;
          conditions = fetchedConditions;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching appointment details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appointment == null) {
      return const Center(child: Text('No appointments found'));
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: IndexPage.primaryBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('images/doc.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        // ignore: avoid_print

                        patient!['first_name'] ?? 'Patient ',

                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _buildConditionsText(), // Display conditions
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ],
              ),
              Config.spaceSmall,
              ScheduleCard(
                appointmentDate:
                    (appointment!['appointment_date'] as Timestamp).toDate(),
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IndexPage.primaryDanger,
                      ),
                      child: const Text(
                        'Reschedule',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed:
                          () {}, // reschedule appointment logic goes here
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IndexPage.primaryDark,
                      ),
                      child: const Text(
                        'Complete',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {}, // complete appointment logic goes here
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildConditionsText() {
    if (conditions.isEmpty) {
      return 'Consultation';
    }

    List<String> conditionNames = conditions.map((condition) {
      if (condition.containsKey('type')) {
        return condition['type'] as String; // Explicitly cast to String
      }
      return '';
    }).toList();

    // Filter out empty strings and duplicates
    conditionNames.removeWhere((name) => name.isEmpty);
    conditionNames = conditionNames.toSet().toList(); // Remove duplicates

    return conditionNames.join(', ');
  }
}

class ScheduleCard extends StatelessWidget {
  final DateTime appointmentDate;

  const ScheduleCard({Key? key, required this.appointmentDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEEE, MMM d, yyyy').format(appointmentDate);
    final String formattedTime = DateFormat('HH:mm').format(appointmentDate);
    return Container(
      decoration: BoxDecoration(
        color: IndexPage.primaryMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            formattedDate,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.access_alarm, color: Colors.white, size: 17),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              formattedTime,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
