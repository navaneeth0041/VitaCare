import 'package:flutter/material.dart';
import 'package:vitacare/components/appointment_card.dart';
import 'package:vitacare/components/doctor_card.dart';
import 'package:vitacare/components/doctor_details_page.dart';
import 'package:vitacare/components/hospital_card.dart';
import 'package:vitacare/components/hospital_details_page.dart';

class DoctorAppointmentPage extends StatefulWidget {
  const DoctorAppointmentPage({super.key});

  @override
  _DoctorAppointmentPageState createState() => _DoctorAppointmentPageState();
}

class _DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingHorizontal = screenWidth * 0.04; // 4% of screen width
    final paddingVertical = screenHeight * 0.03; // 3% of screen height

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05), // 3% of screen height
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search doctors, specialties, hospitals...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.03), // 3% of screen height
            const Text(
              "Your Upcoming Appointments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height
            AppointmentCard(
              doctorName: "Dr. William James",
              specialization: "Neurologist",
              date: "Aug 20, 2024",
              time: "10:00 AM",
              icon: Icons.person,
            ),
            SizedBox(height: screenHeight * 0.03), // 3% of screen height
            const Text(
              "Top Doctors",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsPage(
                            name: "Dr. Thomas Michael",
                            specialization: "Cardiologist",
                            rate: "\$84/session",
                            experience: "10 years",
                            rating: 4.5,
                            patients: "1200",
                          ),
                        ),
                      );
                    },
                    child: DoctorCard(
                      name: "Dr. Thomas Michael",
                      specialization: "Cardiologist",
                      rate: "\$84/session",
                      icon: Icons.person,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04), // 4% of screen width
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailsPage(
                            name: "Dr. William James",
                            specialization: "Neurologist",
                            rate: "\$95/session",
                            experience: "8 years",
                            rating: 4.7,
                            patients: "1500",
                          ),
                        ),
                      );
                    },
                    child: DoctorCard(
                      name: "Dr. William James",
                      specialization: "Neurologist",
                      rate: "\$95/session",
                      icon: Icons.person,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // 3% of screen height
            const Text(
              "Top Hospitals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HospitalDetailsPage(
                            hospitalName: "City Hospital",
                            doctors: [
                              DoctorCard(
                                name: "Dr. Alice Smith",
                                specialization: "Dermatologist",
                                rate: "\$70/session",
                                icon: Icons.person,
                              ),
                              DoctorCard(
                                name: "Dr. Bob Johnson",
                                specialization: "Orthopedic",
                                rate: "\$90/session",
                                icon: Icons.person,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: HospitalCard(
                      name: "City Hospital",
                      location: "Downtown",
                      icon: Icons.local_hospital,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04), // 4% of screen width
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HospitalDetailsPage(
                            hospitalName: "General Hospital",
                            doctors: [
                              DoctorCard(
                                name: "Dr. Charlie Brown",
                                specialization: "Pediatrician",
                                rate: "\$80/session",
                                icon: Icons.person,
                              ),
                              DoctorCard(
                                name: "Dr. David Wilson",
                                specialization: "Surgeon",
                                rate: "\$100/session",
                                icon: Icons.person,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: HospitalCard(
                      name: "General Hospital",
                      location: "Uptown",
                      icon: Icons.local_hospital,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}