import 'package:flutter/material.dart';

void showNormalDialog(BuildContext context,
    {required int systolic, required int diastolic}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Normal Blood Pressure'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your blood pressure levels are within the normal range:'),
          SizedBox(height: 8),
          Text('Systolic: $systolic mmHg'),
          Text('Diastolic: $diastolic mmHg'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showBloodPressureRecommendations(context);
          },
          child: const Text('Ok'),
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
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Here are some tips to maintain your blood pressure:'),
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
