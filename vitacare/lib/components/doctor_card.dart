import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String rate;
  final IconData icon;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.rate,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Set a fixed width to avoid overflow
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                specialization,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                rate,
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}