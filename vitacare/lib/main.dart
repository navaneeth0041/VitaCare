import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart' as provider;
import 'package:vitacare/fall_listner.dart';
import 'package:vitacare/homepage.dart';
import 'package:vitacare/permissions.dart';
import 'package:vitacare/providers/medication_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitacare/providers/vitaprovider.dart';
import 'package:vitacare/sos_button.dart';
import 'package:vitacare/utils/vitavoiceassistant.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await requestPermissions();
  listenForFallEvents();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVitaActive = ref.watch(vitaDetectionProvider);
    ref.read(speechServiceProvider);

    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => MedicationProvider()),
      ],
      child: MaterialApp(
        title: 'Medication Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Stack(
            children: [
              const HomePage(),
              if (isVitaActive)
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: WaveAnimation(),
                ),
              // Add SOSButton here
              Positioned(
                bottom: 120, // Adjust this value as needed
                left: 20,   // Position it in the left corner
                child: SOSButton(
                  emergencyNumber: '+916238170626',
                  emergencyContacts: const ['+918089198810', '+916238170626'],
                ),
              ),
            ],
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}



class WaveAnimation extends StatefulWidget {
  const WaveAnimation({Key? key}) : super(key: key);

  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 60),
            painter: WavePainter(_controller.value),
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double waveValue;

  WavePainter(this.waveValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height); // Start at the bottom left
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        math.sin((i / size.width * 2 * math.pi) + (waveValue * 2 * math.pi)) * 10 + 20,
      );
    }
    path.lineTo(size.width, size.height); // Line to the bottom right
    path.lineTo(0, size.height); // Line back to the bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.waveValue != waveValue;
}
