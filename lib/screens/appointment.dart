import 'package:afyaexpress/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'doctor_selection.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime focusedDay = DateTime.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _navigateToDoctorSelection() {
    if (selectedDate != null && selectedTime != null) {
      final DateTime appointmentDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DoctorSelection(selectedDate: appointmentDateTime),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: IndexPage.primaryBlue,
        title: const Text('Book appointment'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _selectTime(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: IndexPage.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Select Time'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _navigateToDoctorSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: IndexPage.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Next'),
          ),
          if (selectedDate != null)
            Text('Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
          if (selectedTime != null)
            Text('Selected Time: ${selectedTime!.format(context)}'),
        ],
      ),
    );
  }
}
