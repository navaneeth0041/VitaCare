import 'package:flutter/material.dart';
import 'package:vitacare/models/healthcheckmodels.dart';

class GeneralHealthCheckScreen extends StatelessWidget {
  final HealthCheck healthCheck;

  const GeneralHealthCheckScreen({super.key, required this.healthCheck});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text('General Health Check',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(healthCheck.imageUrl), // Use the URL from healthCheck
                ),
                const SizedBox(height: 16),
                const Text(
                  'This quick general wellbeing check helps determine where you\'re currently at in your health journey so we can provide insights that are relevant to you and your health status.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoCard(
                      title: 'Duration',
                      value: '10 minutes', // Update this if duration varies
                    ),
                    SizedBox(width: 16),
                    InfoCard(
                      title: 'Questions',
                      value: '11', // Update this if question count varies
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please note:VitaCare does not diagnose, prevent, monitor, predict, or treat any medical issues. You might want to consult a doctor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(
              
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                },
                child: const Text('Start Check', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
