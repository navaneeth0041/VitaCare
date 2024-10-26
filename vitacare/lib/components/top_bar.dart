import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://www.example.com/profile_picture.jpg'),
          radius: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Hailey!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.notifications_none, size: 28),
            SizedBox(width: 16),
            Icon(Icons.settings, size: 28),
          ],
        ),
      ],
    );
  }
}
