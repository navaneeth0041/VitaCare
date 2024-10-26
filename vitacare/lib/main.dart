import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitacare/homepage.dart';
import 'package:vitacare/providers/vitaprovider.dart';
import 'package:vitacare/utils/vitavoiceassistant.dart';

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
        sin((i / size.width * 2 * pi) + (waveValue * 2 * pi)) * 10 + 20,
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

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(speechServiceProvider); 
    final isVitaActive = ref.watch(vitaDetectionProvider);

    return MaterialApp(
      title: 'Vita Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
