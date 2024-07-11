import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/vitals/Other/Firebase_other.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OtherConditionEntryPage extends StatefulWidget {
  const OtherConditionEntryPage({Key? key}) : super(key: key);

  @override
  _OtherConditionEntryPageState createState() =>
      _OtherConditionEntryPageState();
}

class _OtherConditionEntryPageState extends State<OtherConditionEntryPage> {
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _briefDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _conditionController.dispose();
    _briefDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitOtherConditionData() async {
    final condition = _conditionController.text;
    final briefDescription = _briefDescriptionController.text;
    final timestamp = Timestamp.now();
    final entryId = DateTime.now().toIso8601String();

    if (condition.isEmpty || briefDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final userId = FirebaseAuthProvider().currentUser!.id;
      final patientProfileDocumentId =
          await FirebasOtherConditionsService.getPatientProfileDocumentId(
              userId);

      if (patientProfileDocumentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kindly update your profile first')),
        );
        return;
      }

      final othersService = FirebasOtherConditionsService(
          patientProfileDocumentId: patientProfileDocumentId);

      await othersService.addOrUpdateOthersEntry(
          entryId: entryId,
          condition: condition,
          briefDescription: briefDescription,
          timestamp: timestamp);
      //  _analyzeData(fastingBloodSugar, randomBloodSugar);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vitals submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  List<Widget> conditionWidgets = [];

  void addCondition() {
    setState(() {
      conditionWidgets.add(_buildConditionWidget());
    });
  }

  Widget _buildConditionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          TextField(
            controller: _conditionController,
            decoration: const InputDecoration(
              labelText: 'Condition',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _briefDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Brief Explanation',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Conditions Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...conditionWidgets,
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addCondition,
              child: const Text('Add Condition'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitOtherConditionData();
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
