import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String name;
  final String specialization;
  final String rate;
  final String experience;
  final double rating;
  final String patients;

  const DoctorDetailsPage({
    super.key,
    required this.name,
    required this.specialization,
    required this.rate,
    required this.experience,
    required this.rating,
    required this.patients,
  });

  @override
  _DoctorDetailsPageState createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  final Map<String, List<String>> _availableSlots = {
    '2023-10-09': ['10:00 AM - 11:00 AM', '11:00 AM - 12:00 PM'], // Monday
    '2023-10-10': ['11:00 AM - 12:00 PM', '12:00 PM - 01:00 PM'], // Tuesday
    '2023-10-11': ['12:00 PM - 01:00 PM', '01:00 PM - 02:00 PM'], // Wednesday
  };

  String? _selectedDay;

  void _bookSlot(String day, int index) {
    setState(() {
      _availableSlots[day]!.removeAt(index);
      if (_availableSlots[day]!.isEmpty) {
        _availableSlots.remove(day);
        _selectedDay = null;
      }
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[100],
          title: const Text('Appointment Booked', style: TextStyle(color: Colors.black)),
          content: const Text('Your appointment has been successfully booked.', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final List<String> days = _availableSlots.keys.toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.45,
                        color: Colors.lightBlue[50],
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 20,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.black),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, color: Colors.black),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 70,
                        right: 0,
                        child: Container(
                          height: screenHeight * 0.35,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/doctor_bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 100, // Adjusted to move the text down
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.specialization,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.rate,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatBox('Rating', '${widget.rating}'),
                            _buildStatBox('Experience', widget.experience),
                            _buildStatBox('Patients', widget.patients),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About the Doctor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Dr. William James is a neurologist with extensive experience in treating various neurological disorders. He has an experience of over 8 years treating more than 1000 patients .',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Appointments',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: days.map((day) {
                              final DateTime date = DateTime.parse(day);
                              final String formattedDate = DateFormat('EEEE, MMM d').format(date);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDay = day;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _selectedDay == day ? Colors.blue[700] : const Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: _selectedDay == day ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedDay != null) ...[
                          const Text(
                            'Available Slots',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._availableSlots[_selectedDay]!.asMap().entries.map((entry) {
                            int index = entry.key;
                            String time = entry.value;
                            return ListTile(
                              title: Text(time),
                              trailing: ElevatedButton(
                                onPressed: () => _bookSlot(_selectedDay!, index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                ),
                                child: const Text(
                                  "Book",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        SizedBox(height: 20),
                      ],
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

  Widget _buildStatBox(String title, String value) {
    return Container(
      width: 100, // Set a fixed width for consistency
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}