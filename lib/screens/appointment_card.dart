import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/storage/appointment/firebase_appointment.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:afyaexpress/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({Key? key}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  Map<String, dynamic>? appointment;
  Map<String, dynamic>? doctor;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final currentUser = AuthService.firebase().currentUser!;
    try {
      final fetchedAppointments = await fetchAppointments(currentUser.id);
      print("appointment details");
      print(fetchedAppointments);
      if (fetchedAppointments.isNotEmpty) {
        final appointmentData = fetchedAppointments.first;
        final doctorId = appointmentData['doctor_id'];
        final fetchedDoctor =
            await FirebaseDoctorProfile().getDoctorById(doctorId);

        setState(() {
          appointment = appointmentData;
          doctor = fetchedDoctor;
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
                      backgroundImage: AssetImage(
                          'images/doc.png'), //doctor image to be inserted here
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          doctor!['name'] ?? 'Dr. Unknown',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          doctor!['specialization'] ?? 'Specialization Unknown',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
                Config.spaceSmall,
//I will add schedule info here
                ScheduleCard(
                    appointmentDate:
                        (appointment!['appointment_date'] as Timestamp)
                            .toDate()),
                Config.spaceSmall,

                //action button code sync this with the database....

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: IndexPage.primaryDanger,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {}, //cancel appointment logic goes here
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: IndexPage.primaryDark,
                        ),
                        child: const Text(
                          'Completed',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {}, //appointment logics goes here
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final DateTime appointmentDate;
  // Using intl package to format date and include the day of the week

  const ScheduleCard({
    Key? key,
    required this.appointmentDate,
  }) : super(key: key);
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
            //appointmentDate.toLocal().toString().split(' ')[0]
            formattedDate, // date
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.access_alarm, color: Colors.white, size: 17),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              /*appointmentDate
                  .toLocal()
                  .toString()
                  .split(' ')[1]
                  .substring(0, 5)*/
              formattedTime, // time
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
