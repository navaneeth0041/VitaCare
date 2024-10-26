import 'package:flutter/material.dart';

class MoodEmoji extends StatelessWidget {
  final String icon;

  const MoodEmoji({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Text(
          icon,
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}