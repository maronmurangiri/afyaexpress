import 'package:afyaexpress/services/storage/vitals/diabetes/diabetes_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'diabetes_vitals_constants.dart';

class DiabetesVitalsEntry {
  final String entryId;
  final double fastingBloodSugar;
  final double randomBloodSugar;
  final Timestamp timestamp;

  DiabetesVitalsEntry({
    required this.entryId,
    required this.timestamp,
    required this.fastingBloodSugar,
    required this.randomBloodSugar,
  });

  DiabetesVitalsEntry.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : entryId = snapshot.id,
        //userId = snapshot.data()[userIdFieldName] ?? '',
        timestamp = snapshot.data()[timestampFieldName] ?? Timestamp.now(),
        fastingBloodSugar = snapshot.data()[fastingBloodSugarFieldName] ?? 0.0,
        randomBloodSugar = snapshot.data()[randomBloodSugarFieldName] ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      //userIdFieldName: userId,
      timestampFieldName: timestamp,
      fastingBloodSugarFieldName: fastingBloodSugar,
      randomBloodSugarFieldName: randomBloodSugar,
    };
  }
}
