import 'package:flutter/material.dart';

class HospitalCard extends StatelessWidget {
  final String name;
  final String location;
  final IconData icon;

  const HospitalCard({
    Key? key,
    required this.name,
    required this.location,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(location, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}