import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/vitals/bloodPressure/Firebase_pressure.dart';
import 'package:afyaexpress/utilities/dialogs/bloodPressure/abnormal_dialog.dart';
import 'package:afyaexpress/utilities/dialogs/bloodPressure/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodPressureEntryPage extends StatefulWidget {
  const BloodPressureEntryPage({Key? key}) : super(key: key);

  @override
  _BloodPressureEntryPage createState() => _BloodPressureEntryPage();
}

class _BloodPressureEntryPage extends State<BloodPressureEntryPage> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  Future<void> _submitBloodPressureData() async {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);
    final timestamp = Timestamp.now();
    final entryId = DateTime.now().toIso8601String();

    if (systolic == null || diastolic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter valid systolic and diastolic readings')),
      );
      return;
    }

    try {
      final userId = FirebaseAuthProvider().currentUser!.id;
      final patientProfileDocumentId =
          await FirebasePressureService.getPatientProfileDocumentId(userId);

      if (patientProfileDocumentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kindly update your profile first')),
        );
        return;
      }

      final pressureService = FirebasePressureService(
          patientProfileDocumentId: patientProfileDocumentId);

      await pressureService.addOrUpdatePressureEntry(
          entryId: entryId,
          systolic: systolic,
          diastolic: diastolic,
          timestamp: timestamp);
      _analyzeData(systolic, diastolic);
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vitals submitted successfully')),
      );*/
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  void _analyzeData(int systolic, int diastolic) {
    if (systolic >= 90 &&
        systolic <= 120 &&
        diastolic >= 60 &&
        diastolic <= 80) {
      showNormalDialog(context, systolic: systolic, diastolic: diastolic);
    } else {
      showAbnormalDialog(context, systolic: systolic, diastolic: diastolic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter Blood Pressure Readings',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _systolicController,
              decoration: const InputDecoration(
                labelText: 'Systolic (100-130)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diastolicController,
              decoration: const InputDecoration(
                labelText: 'Diastolic (60-85)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save or submit action
                _submitBloodPressureData();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
