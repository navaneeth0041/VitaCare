import 'package:flutter/material.dart';
import 'package:vitacare/models/QuestionAnswer.dart';
import 'package:vitacare/models/healthcheckmodels.dart';
import 'package:vitacare/views/HealthCHecks/heightandweightscreen.dart';

class GeneralHealthCheck extends StatefulWidget {
  const GeneralHealthCheck({super.key, required HealthCheck healthCheck});

  @override
  State<GeneralHealthCheck> createState() => _GeneralHealthCheckState();
}

class _GeneralHealthCheckState extends State<GeneralHealthCheck> {
  @override
  Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenWidth * 0.09),
              Text(
                'General Health Check',
                style: TextStyle(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: screenWidth * 0.06),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset('assets/icons/VitaCare.jpg'), // replace with your asset path
              ),
              const SizedBox(height: 20),
              const Text(
                'This quick general wellbeing check helps determine ...',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoCard('Duration', '10 minutes'),
                  _infoCard('Questions', '11'),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              GestureDetector(
onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionsScreen(),
      ),
    );
  },                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                'Please note:\nThis AI-powered health check is designed to give you insights into your general wellbeing. It does not provide a medical diagnosis or replace professional healthcare advice. For any health concerns, consult a healthcare professional.',
                textAlign: TextAlign.left,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
