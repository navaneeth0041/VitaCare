import 'package:flutter/material.dart';
import 'package:vitacare/components/mod_emoji.dart';
import 'package:vitacare/sos_button.dart';
import 'components/custom_styles.dart';

class ReflectionPage extends StatelessWidget {
  const ReflectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, size: 28),
                  Icon(Icons.settings, size: 28),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'Daily reflection',
                style: CustomStyles.subheadingTextStyle(screenWidth),
              ),
              const SizedBox(height: 8),

              RichText(
                text: TextSpan(
                  text: 'Hello, Max ',
                  style: CustomStyles.headingTextStyle(screenWidth),
                  children: const [
                    WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text('🌼'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'How do you feel about your current emotions?',
                style: CustomStyles.questionTextStyle(screenWidth),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your reflection..',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 24),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Text(
                'Daily Mood Log',
                style: CustomStyles.subheadingTextStyle(screenWidth),
              ),
              const SizedBox(height: 16),

              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MoodEmoji(icon: '😊'),
                    MoodEmoji(icon: '😟'),
                    MoodEmoji(icon: '😡'),
                    MoodEmoji(icon: '😐'),
                    MoodEmoji(icon: '😞'),
                    MoodEmoji(icon: '😄'),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Text(
                'Your progress',
                style: CustomStyles.subheadingTextStyle(screenWidth),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '89%',
                              style: CustomStyles.progressTextStyle(screenWidth),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildBottomNavButton(Icons.home),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
    );
  }
}
