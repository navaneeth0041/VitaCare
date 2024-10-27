import 'package:flutter/material.dart';

class Resultscreen extends StatefulWidget {
  final Map<String, dynamic> result;
  const Resultscreen({super.key, required this.result});

  @override
  State<Resultscreen> createState() => _ResultscreenState();
}

class _ResultscreenState extends State<Resultscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Health Report',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 156, 245, 153),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text('24/44', style: TextStyle(fontSize: 36, color: Colors.orange, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Adequate', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Icon(Icons.sentiment_satisfied_alt, color: Colors.green, size: 24),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'You may be experiencing mild challenges in certain areas ...',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Detailed Breakdown',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Expanded(
                child: ListView(
                  children: _buildResultBreakdown(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResultBreakdown() {
    return [
      _resultCard('BMI', 'Optimal', 'According to WHO, a BMI below ...', Icons.thumb_up_alt, Colors.green),
      _resultCard('Mental Health', 'Moderate', 'Exploring ways to ...', Icons.sentiment_neutral, Colors.orange),
      _resultCard('Sleep Quality', 'Poor', 'Consider improving your sleep ...', Icons.nights_stay, Colors.red),
      _resultCard('Physical Activity', 'Good', 'Engaging in regular exercise ...', Icons.directions_run, Colors.green),
      _resultCard('Dietary Habits', 'Needs Improvement', 'You may benefit from a more balanced diet ...', Icons.restaurant, Colors.orange),
      _resultCard('Hydration', 'Excellent', 'Great job staying hydrated ...', Icons.water_drop, Colors.blue),
      _resultCard('Stress Levels', 'High', 'Consider relaxation techniques ...', Icons.wb_sunny, Colors.red),
      _resultCard('Cardiovascular Health', 'Optimal', 'Your heart health is within a healthy range ...', Icons.favorite, Colors.green),
      _resultCard('Cholesterol Levels', 'Borderline High', 'Slightly elevated levels of cholesterol ...', Icons.heart_broken, Colors.orange),
      _resultCard('Blood Pressure', 'Normal', 'Your blood pressure is within normal range ...', Icons.healing, Colors.green),
    ];
  }

  Widget _resultCard(String title, String status, String description, IconData icon, Color iconColor) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0, // Remove border/elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          '$title - $status',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              description,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
