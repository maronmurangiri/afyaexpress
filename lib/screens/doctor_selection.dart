import 'package:afyaexpress/services/auth/auth_service.dart';
import 'package:afyaexpress/services/storage/appointment/firebase_appointment.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:flutter/material.dart';

class DoctorSelection extends StatefulWidget {
  final DateTime selectedDate;

  const DoctorSelection({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  _DoctorSelectionState createState() => _DoctorSelectionState();
}

class _DoctorSelectionState extends State<DoctorSelection> {
  late Future<List<Map<String, dynamic>>> futureDoctors;

  @override
  void initState() {
    super.initState();
    futureDoctors = FirebaseDoctorProfile().fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Doctor'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureDoctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors available.'));
          } else {
            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return ListTile(
                  title: Text(doctor['name'] ?? 'Unknown Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Specialization: ${doctor['specialization'] ?? 'Unknown Specialization'}'),
                      Text('Charges: Ksh ${doctor['charges'] ?? 'Unknown'}'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Booking'),
                        content: Text(
                            'Do you want to book an appointment with ${doctor['name']}, a  ${doctor['specialization']} on ${widget.selectedDate.toLocal()}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Confirm booking logic here
                              /*Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Appointment booked with ${doctor['specialization']} on ${widget.selectedDate.toLocal()}'),
                                ),
                              );*/
                              // Save the appointment to Firestore
                              try {
                                final userId =
                                    AuthService.firebase().currentUser!.id;
                                await saveAppointment(
                                  userId: userId,
                                  doctorId: doctor['userId'],
                                  appointmentDate: widget.selectedDate,
                                  status: 'confirmed',
                                );
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Appointment booked successfully!'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Failed to book appointment: $e'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
