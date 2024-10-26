import 'package:flutter/material.dart';
import 'package:vitacare/components/meal_card.dart';
import 'package:vitacare/components/progress_card.dart';
import 'package:vitacare/components/stat_card.dart';
import 'package:vitacare/components/top_bar.dart';

class FitnessPage extends StatelessWidget {
  const FitnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(),
            SizedBox(height: 24.0),
            ProgressCard(),
            SizedBox(height: 16.0),
            Row(
              children: [
                StatCard(
                  title: "Current Weight",
                  value: "78.5 Kg",
                  change: "3 Kg (-3.8%)",
                  icon: Icons.monitor_weight,
                ),
                SizedBox(width: 16),
                StatCard(
                  title: "Today's Calories",
                  value: "1278 Kcal",
                  change: "5.6%",
                  icon: Icons.local_fire_department,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            MealCard(),
          ],
        ),
      ),
    );
  }
}
