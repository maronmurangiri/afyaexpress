import 'package:afyaexpress/services/storage/vitals/bloodPressure/pressure_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'diabetes_vitals_constants.dart';

class PressureVitalsEntry {
  final String entryId;
  final int systolic;
  final int diastolic;
  final Timestamp timestamp;

  PressureVitalsEntry({
    required this.entryId,
    required this.timestamp,
    required this.systolic,
    required this.diastolic,
  });

  PressureVitalsEntry.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : entryId = snapshot.id,
        //userId = snapshot.data()[userIdFieldName] ?? '',
        timestamp = snapshot.data()[timestampFieldName] ?? Timestamp.now(),
        systolic = snapshot.data()[systolicFieldName] ?? 0,
        diastolic = snapshot.data()[diastolicFieldName] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      //userIdFieldName: userId,
      timestampFieldName: timestamp,
      systolicFieldName: systolic,
      diastolicFieldName: diastolic,
    };
  }

  static snapshots() {}
}
