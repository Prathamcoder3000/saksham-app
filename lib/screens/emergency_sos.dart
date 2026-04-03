import 'dart:async';
import 'package:flutter/material.dart';

class EmergencySOSScreen extends StatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen> {

  bool isHolding = false;
  int seconds = 3;
  Timer? timer;

  void startSOS() {
    setState(() {
      isHolding = true;
      seconds = 3;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds--;
      });

      if (seconds == 0) {
        t.cancel();
        triggerSOS();
      }
    });
  }

  void cancelSOS() {
    timer?.cancel();
    setState(() {
      isHolding = false;
      seconds = 3;
    });
  }

  void triggerSOS() {
    setState(() {
      isHolding = false;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Admin Notified"),
        content: const Text("Help is on the way. Stay calm."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: SafeArea(
        child: Column(
          children: [

            // 🔝 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.blue),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Emergency Support",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔵 TITLE
            const Text(
              "Emergency Mode",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Press and hold the button for 3 seconds",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // 🔴 SOS BUTTON
            GestureDetector(
              onLongPressStart: (_) => startSOS(),
              onLongPressEnd: (_) => cancelSOS(),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  // BIG OUTER RIPPLE
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: isHolding ? 320 : 280,
                    height: isHolding ? 320 : 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.2),
                    ),
                  ),

                  // INNER RIPPLE
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: isHolding ? 260 : 220,
                    height: isHolding ? 260 : 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.1),
                    ),
                  ),

                  // MAIN BUTTON
                  AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isHolding ? 0.95 : 1,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEF4444),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emergency,
                              color: Colors.white,
                              size: 70),
                          SizedBox(height: 10),
                          Text(
                            "SOS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🔵 STATUS CARD (ALWAYS VISIBLE)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.red,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Connecting to Help...",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("GPS Location active and shared",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text(
                    "0${seconds}s",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ❌ CANCEL BUTTON
            OutlinedButton(
              onPressed: cancelSOS,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Cancel SOS",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),

            const Spacer(),

            // 🔻 BOTTOM NAV
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _nav(Icons.home, "Home", false),
                  _nav(Icons.favorite, "Health", false),
                  _nav(Icons.emergency, "SOS", true),
                  _nav(Icons.group, "Care", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔻 NAV ITEM
class _nav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _nav(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: active ? Colors.blue : Colors.grey),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: active ? Colors.blue : Colors.grey)),
      ],
    );
  }
}