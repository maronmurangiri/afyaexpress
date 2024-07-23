import 'package:afyaexpress/screens/doctor.dart';
import 'package:afyaexpress/services/storage/profile/Firebase_doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final FirebaseDoctorProfile firebaseDoctorProfile = FirebaseDoctorProfile();

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    return await firebaseDoctorProfile.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          } else {
            final doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return DoctorCard(
                  doctorName: doctor['name'] ?? 'Unknown',
                  specialization: doctor['specialization'] ?? 'Unknown',
                  //rating: doctor['rating']?.toDouble() ?? 0.0,
                  //reviews: doctor['reviews']?.toInt() ?? 0,
                );
              },
            );
          }
        },
      ),
    );
  }
}
