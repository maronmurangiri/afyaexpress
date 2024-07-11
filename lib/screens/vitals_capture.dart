import 'package:afyaexpress/screens/index.dart';
import 'package:flutter/material.dart';
import 'vitals/blood_pressure.dart';
import 'vitals/diabetes.dart';
import 'vitals/other_condition.dart';
import 'vitals/postoperative.dart';

class VitalsCapture extends StatelessWidget {
  const VitalsCapture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Vitals'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout(context);
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildVitalsButton(context, 'Diabetes', const DiabetesEntryPage()),
              _buildVitalsButton(context, 'Blood Pressure', const BloodPressureEntryPage()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildVitalsButton(context, 'Postoperative care', const PostOperativeCarePage()),
              _buildVitalsButton(context, 'Other', const OtherConditionEntryPage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildVitalsButton(context, 'Diabetes', const DiabetesEntryPage()),
              _buildVitalsButton(context, 'Blood Pressure', const BloodPressureEntryPage()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildVitalsButton(context, 'Postoperative', const PostOperativeCarePage()),
              _buildVitalsButton(context, 'Other', const OtherConditionEntryPage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: IndexPage.primaryBlue,
        foregroundColor: IndexPage.primaryDark,
      ),
      child: Text(title),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: (index) {
        // Handle navigation to different pages based on index
        // Placeholder for demonstration:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on navigation item $index')),
        );
      },

    );

  }
}

void main() {
  runApp(const MaterialApp(
    home: VitalsCapture(),
  ));
}
