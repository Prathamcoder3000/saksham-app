import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'caretaker_dashboard.dart';
import 'family_dashboard.dart';

class LoadingScreen extends StatefulWidget {
  final String role;

  const LoadingScreen({super.key, required this.role});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {

  late AnimationController _rotationController;
  late AnimationController _pulseController;

  int step = 0;

  @override
  void initState() {
    super.initState();

    // 🔄 rotating arc
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 💡 pulse glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _simulateSteps();
  }

  void _simulateSteps() async {
    for (int i = 0; i < 4; i++) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        step = i;
      });
    }

    _navigate();
  }

  void _navigate() {
    Widget next;

    if (widget.role == "admin") {
      next = DashboardScreen();
    } else if (widget.role == "caretaker") {
      next = CaretakerDashboard();
    } else {
      next = FamilyDashboard();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => next),
    );
  }

  String _getText() {
    switch (step) {
      case 0:
        return "Initializing system...";
      case 1:
        return "Syncing health data...";
      case 2:
        return "Preparing dashboard...";
      default:
        return "Almost ready...";
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🔥 GRADIENT BG
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🌫️ ORBS
          Positioned(
            top: -120,
            right: -120,
            child: _blurCircle(300),
          ),
          Positioned(
            bottom: -120,
            left: -120,
            child: _blurCircle(250),
          ),

          // 🔹 CONTENT
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // 🔰 ICON WITH PULSE
                ScaleTransition(
                  scale: _pulseController,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Saksham",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Lexend",
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "EMPATHETIC CARE",
                  style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 12,
                    color: Colors.white70,
                    fontFamily: "Lexend",
                  ),
                ),

                const SizedBox(height: 60),

                // 🔄 ADVANCED LOADER
                SizedBox(
                  width: 90,
                  height: 90,
                  child: AnimatedBuilder(
                    animation: _rotationController,
                    builder: (_, __) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * pi,
                        child: CustomPaint(
                          painter: ArcPainter(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Loading Dashboard...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Lexend",
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _getText(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontFamily: "Lexend",
                    ),
                  ),
                ),
              ],
            ),
          ),

          // FOOTER
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "DIGITAL SANCTUARY V2.0",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 3,
                  color: Colors.white38,
                  fontFamily: "Lexend",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
    );
  }
}

// 🎨 CUSTOM ARC LOADER
class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, 0, pi / 1.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}