import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/vitals/diabetes/Firebase_diabetes.dart';
import 'package:afyaexpress/utilities/dialogs/diabetes/abnormal_dialog.dart';
import 'package:afyaexpress/utilities/dialogs/diabetes/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiabetesEntryPage extends StatefulWidget {
  const DiabetesEntryPage({Key? key}) : super(key: key);

  @override
  _DiabetesEntryPageState createState() => _DiabetesEntryPageState();
}

class _DiabetesEntryPageState extends State<DiabetesEntryPage> {
  final TextEditingController _fastingController = TextEditingController();
  final TextEditingController _randomController = TextEditingController();

  @override
  void dispose() {
    _fastingController.dispose();
    _randomController.dispose();
    super.dispose();
  }

  Future<void> _submitDiabetesData() async {
    final fastingBloodSugar = double.tryParse(_fastingController.text);
    final randomBloodSugar = double.tryParse(_randomController.text);
    final timestamp = Timestamp.now();
    final entryId = DateTime.now().toIso8601String();

    if (fastingBloodSugar == null || randomBloodSugar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid blood sugar levels')),
      );
      return;
    }

    try {
      final userId = FirebaseAuthProvider().currentUser!.id;
      final patientProfileDocumentId =
          await FirebaseDiabetesService.getPatientProfileDocumentId(userId);

      if (patientProfileDocumentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kindly update your profile first')),
        );
        return;
      }

      final diabetesService = FirebaseDiabetesService(
          patientProfileDocumentId: patientProfileDocumentId);

      await diabetesService.addOrUpdateDiabetesEntry(
          entryId: entryId,
          fastingBloodSugar: fastingBloodSugar,
          randomBloodSugar: randomBloodSugar,
          timestamp: timestamp);
      _analyzeData(fastingBloodSugar, randomBloodSugar);
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vitals submitted successfully')),
      );*/
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  void _analyzeData(double fastingBloodSugar, double randomBloodSugar) {
    // Example ranges, adjust as needed
    double fbs = fastingBloodSugar;
    double rbs = randomBloodSugar;

    if (fbs >= 70 && fbs <= 99 && rbs >= 70 && rbs <= 140) {
      showNormalDialog(context);
    } else {
      showAbnormalDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diabetes Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter Blood Sugar Levels (mmol/L)',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fastingController,
              decoration: const InputDecoration(
                labelText: 'Fasting Blood Sugar ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _randomController,
              decoration: const InputDecoration(
                labelText: 'Random Blood Sugar ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitDiabetesData();
                // Handle save or submit action
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
