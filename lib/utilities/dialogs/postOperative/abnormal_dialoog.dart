import 'package:flutter/material.dart';

void showAbnormalPostoperativeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Abnormal Vitals Detected'),
      content:
          const Text('Your postoperative vitals are out of the normal range.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/appointment');
          },
          child: const Text('Book Appointment'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showRecommendations(context);
          },
          child: const Text('Recommendations'),
        ),
      ],
    ),
  );
}

void _showRecommendations(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Daily Recommendations'),
      content: const Text(
          'Maintain a balanced diet, exercise regularly, and monitor your vitals.'),
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
