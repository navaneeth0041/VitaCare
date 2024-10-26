import 'package:flutter/material.dart';
import 'custom_styles.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const CategoryCard({super.key, 
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              title,
              style: CustomStyles.subheadingTextStyle(screenWidth),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1), // Circular highlight background
                ),
                child: Transform.rotate(
                  angle: -0.5, // Tilt the arrow upwards
                  child: Icon(icon, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}