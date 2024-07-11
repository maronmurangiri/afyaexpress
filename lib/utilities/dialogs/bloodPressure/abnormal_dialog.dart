import 'package:flutter/material.dart';

void showAbnormalDialog(BuildContext context,
    {required int systolic, required int diastolic}) {
  String systolicStatus = '';
  String diastolicStatus = '';

  // Determine status for systolic
  if (systolic < 90) {
    systolicStatus = 'Low';
  } else if (systolic <= 120) {
    systolicStatus = 'Normal';
  } else if (systolic <= 129) {
    systolicStatus = 'Elevated';
  } else if (systolic <= 139) {
    systolicStatus = 'Stage 1 Hypertension';
  } else {
    systolicStatus = 'Stage 2 Hypertension';
  }

  // Determine status for diastolic
  if (diastolic < 60) {
    diastolicStatus = 'Low';
  } else if (diastolic <= 80) {
    diastolicStatus = 'Normal';
  } else if (diastolic <= 89) {
    diastolicStatus = 'High Normal';
  } else if (diastolic <= 99) {
    diastolicStatus = 'Stage 1 Hypertension';
  } else {
    diastolicStatus = 'Stage 2 Hypertension';
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Abnormal Blood Pressure Detected'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your blood pressure levels are out of the normal range:'),
          SizedBox(height: 8),
          Text('Systolic: $systolic mmHg ($systolicStatus)'),
          Text('Diastolic: $diastolic mmHg ($diastolicStatus)'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Navigate to appointment page
            Navigator.of(context).pushNamed('/appointment');
          },
          child: const Text('Book Appointment'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showBloodPressureRecommendations(context);
          },
          child: const Text('Recommendations'),
        ),
      ],
    ),
  );
}

void _showBloodPressureRecommendations(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Daily Recommendations'),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Here are some recommendations to improve your blood pressure:'),
          const SizedBox(height: 8),
          const Text('- Maintain a balanced diet low in sodium'),
          const Text('- Engage in regular physical activity'),
          const Text('- Manage stress levels'),
          const Text('- Monitor your blood pressure regularly'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
