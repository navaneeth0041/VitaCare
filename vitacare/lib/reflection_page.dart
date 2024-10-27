import 'package:flutter/material.dart';
import 'package:vitacare/components/mod_emoji.dart';
import 'package:vitacare/healthcheck.dart';
import 'package:vitacare/models/healthcheckmodels.dart';
import 'package:vitacare/sos_button.dart';
import 'package:vitacare/views/HealthCHecks/GeneralHealthCheck.dart';
import 'package:vitacare/widgets/checkcontainer.dart';
import 'components/custom_styles.dart';

class ReflectionPage extends StatelessWidget {
  const ReflectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header icons with a pulsing animation on tap
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, size: 28),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Animated Hero Banner
                RichText(
                  text: TextSpan(
                    text: 'Hello, Max ',
                    style: CustomStyles.headingTextStyle(screenWidth),
                    children: const [
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.safety_check, color: Colors.yellow, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Health Check Section
                Text(
                  'Health Checks',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Checkcontainer(
                  title: "General Health Check",
                  subtitle: "How Healthy are you",
                  imageUrl: "https://www.ethika.co.in/wp-content/uploads/2022/06/annual-health-checkup-1200x900.jpg",
                  onTap: () {
                    HealthCheck healthCheck = HealthCheck(
                      title: "General Health Check",
                      subtitle: "How Healthy are you",
                      imageUrl: "https://www.ethika.co.in/wp-content/uploads/2022/06/annual-health-checkup-1200x900.jpg",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneralHealthCheck(healthCheck: healthCheck),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Animated Progress Indicator
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 89),
                                duration: const Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Text(
                                    '${value.toStringAsFixed(0)}%',
                                    style: CustomStyles.progressTextStyle(screenWidth),
                                  );
                                },
                              ),
                              Text(
                                'Of the weekly plan completed',
                                style: CustomStyles.subtextStyle(screenWidth),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: SOSButton(
                          emergencyNumber: '+916238170626',
                          emergencyContacts: const ['+918089198810','+916238170626'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavButton(IconData icon) {
    return GestureDetector(
      onTap: () {
        // Add navigation or action on tap
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blueAccent],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
