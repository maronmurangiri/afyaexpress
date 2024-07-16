import 'package:afyaexpress/services/storage/vitals/bloodPressure/Firebase_pressure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveAppointment({
  required String userId,
  required String doctorId,
  required DateTime appointmentDate,
  required String status,
}) async {
  try {
    await FirebaseFirestore.instance.collection('appointments').add({
      'patient_id': userId,
      'doctor_id': doctorId,
      'appointment_date': appointmentDate,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Appointment saved successfully');
  } catch (e) {
    print('Error saving appointment: $e');
    throw e;
  }
}

Future<List<Map<String, dynamic>>> fetchAppointments(String userId) async {
  try {
    final appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patient_id', isEqualTo: userId)
        .get();
    print("appointment snapshot");
    print(appointmentsSnapshot);
    List<Map<String, dynamic>> appointments = [];

    for (var doc in appointmentsSnapshot.docs) {
      print('doc');
      print(doc);
      appointments.add(doc.data());
    }
    print('appointment');
    print(appointments);
    return appointments;
  } catch (e) {
    print('Error fetching appointments: $e');
    throw e;
  }
}

Future<List<Map<String, dynamic>>> fetchDoctorAppointments(
    String userId) async {
  try {
    final appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctor_id', isEqualTo: userId)
        .get();
    print("appointment snapshot");
    print(appointmentsSnapshot);
    List<Map<String, dynamic>> appointments = [];

    for (var doc in appointmentsSnapshot.docs) {
      print('doc');
      print(doc);
      appointments.add(doc.data());
    }
    print('appointment');
    print(appointments);
    return appointments;
  } catch (e) {
    print('Error fetching appointments: $e');
    throw e;
  }
}

Future<List<Map<String, dynamic>>> fetchPatientConditions(String userId) async {
  final List<String> conditionCollections = [
    'bloodPressure',
    'diabetes',
    'postoperative',
    'other'
  ];
  final List<Map<String, dynamic>> allConditions = [];

  for (final collection in conditionCollections) {
    try {
      QuerySnapshot querySnapshot;

      if (collection == 'other') {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('patientProfile')
            .doc(await FirebasePressureService.getPatientProfileDocumentId(
                userId))
            .collection(collection)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('patientProfile')
            .doc(await FirebasePressureService.getPatientProfileDocumentId(
                userId))
            .collection(collection)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          if (collection == 'other') {
            final conditionName = doc['condition']
                as String; // Ensure 'condition' is cast to String
            final conditionData = {
              'condition': conditionName,
              'type': collection,
            };
            allConditions.add(conditionData);
          } else {
            final conditionData = doc.data() as Map<String,
                dynamic>; // Explicit cast to Map<String, dynamic>
            conditionData['type'] = collection;
            allConditions.add(conditionData);
          }
        });
      }
    } catch (e) {
      print('Error fetching $collection conditions: $e');
    }
  }

  return allConditions;
}
