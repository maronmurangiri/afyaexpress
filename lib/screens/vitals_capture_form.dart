import 'package:flutter/material.dart';

class VitalsCaptureForm extends StatelessWidget {
  final Map<String, dynamic> vitalsData;
  final Map<String, dynamic> patientDetails;

  const VitalsCaptureForm({
    Key? key,
    required this.vitalsData,
    required this.patientDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Details:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text('Name: ${patientDetails['name'] ?? 'N/A'}'),
        Text('Age: ${patientDetails['age'] ?? 'N/A'}'),
        Text('Gender: ${patientDetails['gender'] ?? 'N/A'}'),
        SizedBox(height: 10),
        Text(
          'Vitals:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text('Blood Pressure: ${vitalsData['bloodPressure'] ?? 'N/A'}'),
        Text('Blood Sugar: ${vitalsData['bloodSugar'] ?? 'N/A'}'),
        Text('Temperature: ${vitalsData['temperature'] ?? 'N/A'}'),
        // Add more vitals as needed
      ],
    );
  }
}
