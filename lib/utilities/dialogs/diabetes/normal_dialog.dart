import 'package:flutter/material.dart';

void showNormalDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Vitals are Normal'),
      content: const Text(
          'Keep up the good work! Here are some tips to maintain your health.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showRecommendations(context);
          },
          child: const Text('Ok'),
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
          'Maintain a balanced diet, exercise regularly, and monitor your blood sugar levels.'),
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
