import 'package:flutter/material.dart';
import 'package:vitacare/components/doctor_card.dart';
import 'package:vitacare/components/doctor_details_page.dart';

class HospitalDetailsPage extends StatelessWidget {
  final String hospitalName;
  final List<DoctorCard> doctors;

  const HospitalDetailsPage({
    Key? key,
    required this.hospitalName,
    required this.doctors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hospitalName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailsPage(
                    name: doctor.name,
                    specialization: doctor.specialization,
                    rate: doctor.rate,
                    experience: "10 years",
                    rating: 4.5,
                    patients: "1200",
                  ),
                ),
              );
            },
            child: doctor,
          );
        },
      ),
    );
  }
}