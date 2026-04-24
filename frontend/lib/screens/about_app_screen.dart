import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("About App", style: TextStyle(color: Color(0xFF1E293B), fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
                ],
              ),
              child: const Icon(Icons.medical_services_rounded, color: Colors.blue, size: 60),
            ),
            const SizedBox(height: 24),
            const Text("Saksham Care", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            const Text("Version 1.0.0", style: TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 40),
            const Text("Smart Care Management System", style: TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            const Text("© 2026 Saksham", style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
