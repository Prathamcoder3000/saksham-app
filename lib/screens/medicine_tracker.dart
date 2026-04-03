import 'dart:ui';
import 'package:flutter/material.dart';

class MedicineTrackerScreen extends StatefulWidget {
  const MedicineTrackerScreen({super.key});

  @override
  State<MedicineTrackerScreen> createState() =>
      _MedicineTrackerScreenState();
}

class _MedicineTrackerScreenState extends State<MedicineTrackerScreen> {

  List<Map<String, String>> medicines = [
    {"name": "Lisinopril", "status": "taken"},
    {"name": "Donepezil", "status": "pending"},
    {"name": "Vitamin D3", "status": "upcoming"},
    {"name": "Aspirin", "status": "missed"},
  ];

  void markAsTaken(int index) {
    setState(() {
      medicines[index]["status"] = "taken";
    });
  }

  int get taken =>
      medicines.where((m) => m["status"] == "taken").length;

  int get pending =>
      medicines.where((m) => m["status"] == "pending").length;

  int get missed =>
      medicines.where((m) => m["status"] == "missed").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: Stack(
        children: [

          // 🔝 HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  color: Colors.white.withOpacity(0.8),
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
                            "Medicine Tracker",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 MAIN CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 120),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // DATE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("TODAY", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text("Monday, 24 Oct",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.medical_services, color: Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 📊 STATS
                  Row(
                    children: [
                      Expanded(child: _stat("$taken", "Taken", Colors.green)),
                      const SizedBox(width: 10),
                      Expanded(child: _stat("$pending", "Pending", Colors.orange)),
                      const SizedBox(width: 10),
                      Expanded(child: _stat("$missed", "Missed", Colors.red)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text("SCHEDULE",
                      style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 15),

                  // GIVEN
                  _card("Lisinopril", "10mg — Before Breakfast", "08:00 AM", "GIVEN", Colors.green),

                  const SizedBox(height: 15),

                  // PENDING
                  _pendingCard(1),

                  const SizedBox(height: 15),

                  // UPCOMING
                  _card("Vitamin D3", "1000 IU — Once Daily", "06:00 PM", "UPCOMING", Colors.grey),

                  const SizedBox(height: 15),

                  // MISSED
                  _missedCard(),

                  const SizedBox(height: 30),

                  // ADD PRESCRIPTION
                  GestureDetector(
                    onTap: () {
                      print("Add Prescription Clicked");
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text("+ Add Prescription",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔻 NAV BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _nav(Icons.home, "Home", false),
                  _nav(Icons.favorite, "Vitals", false),
                  _nav(Icons.medical_services, "Care", true),
                  _nav(Icons.person, "Profile", false),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🚨 FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          print("Emergency Clicked");
        },
        child: const Icon(Icons.emergency),
      ),
    );
  }

  // 🔹 PENDING CARD
  Widget _pendingCard(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Donepezil", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("12:30 PM", style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => markAsTaken(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.teal],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text("✔ Mark as Taken",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 🔹 STAT
class _stat extends StatelessWidget {
  final String count, label;
  final Color color;

  const _stat(this.count, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TextStyle(color: color)),
          Text(label),
        ],
      ),
    );
  }
}

// 🔹 NORMAL CARD
Widget _card(String title, String subtitle, String time, String status, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle),
          ],
        ),
        Column(
          children: [
            Text(status, style: TextStyle(color: color)),
            Text(time),
          ],
        ),
      ],
    ),
  );
}

// 🔹 MISSED CARD
Widget _missedCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Aspirin", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("81mg — Blood Thinner"),
        SizedBox(height: 6),
        Text("Missed at 07:00 AM", style: TextStyle(color: Colors.red)),
        Text("⚠ Alert: Dose missed",
            style: TextStyle(color: Colors.red)),
      ],
    ),
  );
}

// 🔹 NAV
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