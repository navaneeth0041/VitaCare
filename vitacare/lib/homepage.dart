import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vitacare/ProfilePage.dart';
import 'package:vitacare/aichat.dart';
import 'package:vitacare/components/stat_card.dart';
import 'package:vitacare/fitness_page.dart';
import 'package:vitacare/meeting_page.dart';
import 'package:vitacare/models/healthcheckmodels.dart';
import 'package:vitacare/views/HealthCHecks/GeneralHealthCheck.dart';
import 'package:vitacare/views/Medication/medication_tracker_screen.dart';
import 'package:vitacare/reflection_page.dart';
import 'package:vitacare/widgets/barchart.dart';
import 'package:vitacare/widgets/checkcontainer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(
      events: [
        {
          'title': 'Doctor\'s Appointment',
          'time': '10:00 AM',
          'details': 'Doctor: Dr. Smith',
        },
        {
          'title': 'Google Meet Conference',
          'time': '2:00 PM',
          'details': 'Topic: Community Health',
        },
        {
          'title': 'Yoga Session',
          'time': '5:00 PM',
          'details': 'Instructor: Jane Doe',
        },
      ],
      remainingSeconds: 120,
    ),
    MeetingPage(),
    MedicationTrackerScreen(),
    const DoctorAppointmentPage(),
    const PatientProfilePage(),
  ];

  // Timer variables
  late Timer _timer;
  int _remainingSeconds = 120; // Set to 2 minutes (120 seconds)

  // Notification variables
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _startTimer();
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Ensure you have this icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        _sendNotification();
      }
    });
  }

  Future<void> _sendNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_channel', // Channel ID
      'Medication Reminder', // Channel Name
      channelDescription: 'Channel for medication reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Medication Reminder',
      'You have a medicine now, please take it!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            _pages[_currentIndex],
            Positioned(
              bottom: 60,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIChatPage(),
                    ),
                  );
                },
                backgroundColor: const Color.fromARGB(255, 212, 221, 228),
                child: const Icon(Icons.chat_bubble),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10,top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavButton(Icons.home, 0),
            _buildBottomNavButton(Icons.dashboard, 1),
            _buildBottomNavButton(Icons.medical_information_outlined, 2),
            _buildBottomNavButton(Icons.health_and_safety, 3),
            _buildBottomNavButton(Icons.person, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavButton(IconData icon, int index) {
    bool selected = index == _currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.black,
          size: 28,
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final List<Map<String, String>> events;
  final int remainingSeconds;

  const HomePageContent({
    super.key,
    required this.events,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello, Arun!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0057A4),
                      ),
                    ),
                    Text(
                      'Good Morning',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.notifications,
                size: 28,
                color: Color(0xFF0057A4),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medical Record Graphs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0057A4),
                  ),
                ),
                const SizedBox(height: 12),
 Container(
      height: screenWidth / 1.5,  // Adjust height to fit chart below tiles
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDBF3FD), Color(0xFFCCE5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Blood Pressure',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0057A4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '120/80 mmHg',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sugar Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0057A4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '90 mg/dL',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Spacing between tiles and chart
          Expanded(
            child: BarChartWidget(),  // BarChartWidget is added below the tiles
          ),
        ],
      ),
    ),

                const SizedBox(height: 24),
                const Text(
                  'Today\'s Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0057A4),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: events.map((event) {
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: 180,
                            height: 170,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0057A4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Time: ${event['time']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  event['details']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Medicine Reminder',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0057A4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: screenWidth / 3.5,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDBF3FD), Color(0xFFCCE5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medication,
                        color: Color(0xFF0057A4),
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Paracetamol',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0057A4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Time: ${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'After lunch',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Health Checks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0057A4),
                  ),
                ),
                const SizedBox(height: 24),
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
                Checkcontainer(
  title: "Mental Wellness Check",
  subtitle: "Evaluate Your Emotional Health",
  imageUrl: "https://img.freepik.com/premium-photo/vibrant-mental-health-awareness-concept-with-brain-floral-depicting-challenges-solutions_1319687-15502.jpg",
  onTap: () {
    HealthCheck healthCheck = HealthCheck(
      title: "Mental Wellness Check",
      subtitle: "Evaluate Your Emotional Health",
      imageUrl: "https://img.freepik.com/premium-photo/vibrant-mental-health-awareness-concept-with-brain-floral-depicting-challenges-solutions_1319687-15502.jpg",
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneralHealthCheck(healthCheck: healthCheck),
      ),
    );
  },
),

                const SizedBox(height: 24),

                const Text(
                  'Patient Health Stats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0057A4),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StatCard(
                      title: 'Blood Pressure',
                      value: '120/80',
                      change: '0',
                      icon: Icons.favorite,
                    ),
                    StatCard(
                      title: 'Cholesterol',
                      value: '180 mg/dL',
                      change: 'No Change',
                      icon: Icons.local_hospital,
                    ),
                    StatCard(
                      title: 'Sugar Level',
                      value: '90 mg/dL',
                      change: '3 mg',
                      icon: Icons.health_and_safety,
                    ),
                    StatCard(
                      title: 'Heart Rate',
                      value: '75 bpm',
                      change: 'No Change',
                      icon: Icons.favorite_border,
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}