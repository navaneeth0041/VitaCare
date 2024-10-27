import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Hello, Rakib 👋",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "How are you today?",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        CircleAvatar(
          backgroundImage: NetworkImage("https://example.com/user_profile.jpg"),
          radius: 24.0,
        ),
      ],
    );
  }
}