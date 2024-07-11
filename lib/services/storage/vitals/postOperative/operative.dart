import 'package:afyaexpress/services/storage/vitals/postOperative/operative_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostoperativeVitalsEntry {
  final String entryId;
  final double bloodPressure;
  final double temperature;
  final int pulseRate;
  final int oxygenSaturation;
  final int painLevel;
  final double hydrationLevel;
  final Timestamp timestamp;

  PostoperativeVitalsEntry({
    required this.entryId,
    required this.bloodPressure,
    required this.temperature,
    required this.pulseRate,
    required this.oxygenSaturation,
    required this.painLevel,
    required this.hydrationLevel,
    required this.timestamp,
  });

  PostoperativeVitalsEntry.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : entryId = snapshot.id,
        timestamp =
            snapshot.data()[postoperativeTimestampFieldName] ?? Timestamp.now(),
        bloodPressure = snapshot.data()[bloodPressureFieldName] ?? 0.0,
        temperature = snapshot.data()[temperatureFieldName] ?? 0.0,
        pulseRate = snapshot.data()[pulseRateFieldName] ?? 0,
        oxygenSaturation = snapshot.data()[oxygenSaturationFieldName] ?? 0,
        painLevel = snapshot.data()[painLevelFieldName] ?? 0,
        hydrationLevel = snapshot.data()[hydrationLevelFieldName] ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      postoperativeTimestampFieldName: timestamp,
      bloodPressureFieldName: bloodPressure,
      temperatureFieldName: temperature,
      pulseRateFieldName: pulseRate,
      oxygenSaturationFieldName: oxygenSaturation,
      painLevelFieldName: painLevel,
      hydrationLevelFieldName: hydrationLevel,
    };
  }
}
