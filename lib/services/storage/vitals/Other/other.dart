import 'package:afyaexpress/services/storage/vitals/Other/other_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'diabetes_vitals_constants.dart';

class OtherVitalsEntry {
  final String entryId;
  final String condition;
  final String briefExplanation;
  final Timestamp timestamp;

  OtherVitalsEntry({
    required this.entryId,
    required this.timestamp,
    required this.condition,
    required this.briefExplanation,
  });

  OtherVitalsEntry.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : entryId = snapshot.id,
        //userId = snapshot.data()[userIdFieldName] ?? '',
        timestamp = snapshot.data()[timestampFieldName] ?? Timestamp.now(),
        condition = snapshot.data()[conditionFieldName] ?? 0.0,
        briefExplanation = snapshot.data()[briefExplanationFieldName] ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      //userIdFieldName: userId,
      timestampFieldName: timestamp,
      conditionFieldName: condition,
      briefExplanationFieldName: briefExplanation,
    };
  }

  static doc(String entryId) {}
}
