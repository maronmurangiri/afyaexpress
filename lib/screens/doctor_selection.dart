import 'package:flutter/material.dart';

class DoctorSelection extends StatelessWidget {
  final DateTime selectedDate;

  const DoctorSelection({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder list of doctors
    final List<String> doctors = ['Dr. Smith', 'Dr. Johnson', 'Dr. Lee', 'Dr. Patel'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Doctor'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(doctors[index]),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Booking'),
                  content: Text('Do you want to book an appointment with ${doctors[index]} on ${selectedDate.toLocal()}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Confirm booking logic here
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Appointment booked with ${doctors[index]} on ${selectedDate.toLocal()}'),
                          ),
                        );
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
