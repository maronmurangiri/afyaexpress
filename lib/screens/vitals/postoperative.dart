import 'package:afyaexpress/services/auth/firebase_auth_provider.dart';
import 'package:afyaexpress/services/storage/vitals/postOperative/firebase_operative.dart';
import 'package:afyaexpress/utilities/dialogs/postOperative/abnormal_dialoog.dart';
import 'package:afyaexpress/utilities/dialogs/postOperative/normal_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostOperativeCarePage extends StatefulWidget {
  const PostOperativeCarePage({Key? key}) : super(key: key);

  @override
  _PostOperativeCarePageState createState() => _PostOperativeCarePageState();
}

class _PostOperativeCarePageState extends State<PostOperativeCarePage> {
// Normal range constants (example values)
  double bloodPressureMin = 90.0;
  double bloodPressureMax = 120.0;
  double temperatureMin = 36.0;
  double temperatureMax = 37.5;
  int pulseRateMin = 60;
  int pulseRateMax = 100;
  int oxygenSaturationMin = 95;
  int oxygenSaturationMax = 100;
  int painLevelMin = 1;
  int painLevelMax = 10;
  int hydrationLevelMin = 1;
  int hydrationLevelMax = 8;

  double _hydrationLevel = 1;
  Color _hydrationColor = Colors.green; // Default color

  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _pulseRateController = TextEditingController();
  final TextEditingController _oxygenSaturationController =
      TextEditingController();
  final TextEditingController _painLevelController = TextEditingController();

  @override
  void dispose() {
    _bloodPressureController.dispose();
    _temperatureController.dispose();
    _pulseRateController.dispose();
    _oxygenSaturationController.dispose();
    _painLevelController.dispose();
    //_hydrationLevelController.dispose();
    super.dispose();
  }

  Future<void> _submitPostOperativeData() async {
    final bloodPressure = double.tryParse(_bloodPressureController.text);
    final temperature = double.tryParse(_temperatureController.text);
    final pulseRate = int.tryParse(_pulseRateController.text);
    final oxygenSaturation = int.tryParse(_oxygenSaturationController.text);
    final painLevel = int.tryParse(_painLevelController.text);
    final hydrationLevel = _hydrationLevel;
    final timestamp = Timestamp.now();
    final entryId = DateTime.now().toIso8601String();

    if (bloodPressure == null ||
        temperature == null ||
        pulseRate == null ||
        oxygenSaturation == null ||
        painLevel == null ||
        hydrationLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid data for all fields')),
      );
      return;
    }

    try {
      final userId = FirebaseAuthProvider().currentUser!.id;
      final patientProfileDocumentId =
          await FirebasePostoperativeService.getPatientProfileDocumentId(
              userId);

      if (patientProfileDocumentId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kindly update your profile first')),
        );
        return;
      }

      final postoperativeService = FirebasePostoperativeService(
          patientProfileDocumentId: patientProfileDocumentId);

      await postoperativeService.addOrUpdatePostoperativeEntry(
        entryId: entryId,
        bloodPressure: bloodPressure,
        temperature: temperature,
        pulseRate: pulseRate,
        oxygenSaturation: oxygenSaturation,
        painLevel: painLevel,
        hydrationLevel: hydrationLevel,
        timestamp: timestamp,
      );

      _analyzeData(bloodPressure, temperature, pulseRate, oxygenSaturation,
          painLevel, hydrationLevel);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  void _analyzeData(double bloodPressure, double temperature, int pulseRate,
      int oxygenSaturation, int painLevel, double hydrationLevel) {
    // Example ranges, adjust as needed
    // Implement your logic to determine if data is abnormal
    bool isAbnormal = false;

    if (isAbnormal) {
      showAbnormalPostoperativeDialog(context);
    } else {
      showNormalPostoperativeDialog(context);
    }
  }

  bool _isDataAbnormal(
    double bloodPressure,
    double temperature,
    int pulseRate,
    int oxygenSaturation,
    int painLevel,
    int hydrationLevel,
  ) {
    bool isAbnormal = false;

    // Check each vital sign against its normal range
    if (bloodPressure < bloodPressureMin || bloodPressure > bloodPressureMax) {
      isAbnormal = true;
    } else if (temperature < temperatureMin || temperature > temperatureMax) {
      isAbnormal = true;
    } else if (pulseRate < pulseRateMin || pulseRate > pulseRateMax) {
      isAbnormal = true;
    } else if (oxygenSaturation < oxygenSaturationMin ||
        oxygenSaturation > oxygenSaturationMax) {
      isAbnormal = true;
    } else if (painLevel < painLevelMin || painLevel > painLevelMax) {
      isAbnormal = true;
    } else if (hydrationLevel < hydrationLevelMin ||
        hydrationLevel > hydrationLevelMax) {
      isAbnormal = true;
    }

    return isAbnormal;
  }

  void _updateHydrationColor(double level) {
    setState(() {
      if (level <= 2) {
        _hydrationColor = Colors.green;
      } else if (level <= 4) {
        _hydrationColor = Colors.yellow;
      } else if (level <= 6) {
        _hydrationColor = Colors.orange;
      } else {
        _hydrationColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postoperative Care'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Postoperative Care',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Category 1: Checking Vitals',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bloodPressureController,
                decoration: const InputDecoration(
                  labelText: 'Blood Pressure',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _temperatureController,
                decoration: const InputDecoration(
                  labelText: 'Temperature',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _pulseRateController,
                decoration: const InputDecoration(
                  labelText: 'Pulse Rate',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _oxygenSaturationController,
                decoration: const InputDecoration(
                  labelText: 'Oxygen Saturation Rate',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Category 2: Pain Management',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('For kids: Check from vitals'),
              const SizedBox(height: 8),
              TextField(
                controller: _painLevelController,
                decoration: const InputDecoration(
                  labelText: 'Pain Level (1-10)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Category 3: Hydration Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                  'Hydration Level (1-8, where 1 is hydrated and 8 is severely dehydrated)'),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) {
                  // Parse the entered value to double
                  double parsedValue = double.tryParse(value) ?? 1.0;
                  // Ensure hydration level stays within bounds (1-8)
                  if (parsedValue < 1) {
                    parsedValue = 1;
                  } else if (parsedValue > 8) {
                    parsedValue = 8;
                  }
                  // Update hydration level and color
                  _hydrationLevel = parsedValue;
                  _updateHydrationColor(parsedValue);
                },
                decoration: InputDecoration(
                  labelText: 'Enter Hydration Level (1-8)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Slider(
                value: _hydrationLevel,
                min: 1,
                max: 8,
                divisions: 7,
                label: _hydrationLevel.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _hydrationLevel = value;
                    _updateHydrationColor(value);
                  });
                },
                activeColor: _hydrationColor,
                inactiveColor: Colors.grey,
              ),
              Container(
                height: 50,
                color: _hydrationColor,
                child: Center(
                  child: Text(
                    'Hydration Level: ${_hydrationLevel.round()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _submitPostOperativeData();
                  // Handle save or submit action
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
