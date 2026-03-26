import 'dart:ui';
import 'package:flutter/material.dart';

class MedicineTrackerScreen extends StatelessWidget {
  const MedicineTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: Stack(
        children: [

          // 🔝 APP BAR
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
                        children: const [
                          Icon(Icons.arrow_back, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
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

          // 🔹 MAIN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 120),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🗓 DATE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "TODAY",
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Monday, 24 Oct",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medical_services, color: Colors.blue),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 📊 STATS
                  Row(
                    children: const [
                      Expanded(child: _stat("4", "Taken", Colors.green)),
                      SizedBox(width: 10),
                      Expanded(child: _stat("2", "Pending", Colors.orange)),
                      SizedBox(width: 10),
                      Expanded(child: _stat("0", "Missed", Colors.red)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "SCHEDULE",
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 💊 GIVEN
                  _card(
                    title: "Lisinopril",
                    subtitle: "10mg — Before Breakfast",
                    time: "08:00 AM",
                    status: "GIVEN",
                    color: Colors.green,
                  ),

                  const SizedBox(height: 15),

                  // ⏳ PENDING WITH BUTTON
                  _pendingCard(),

                  const SizedBox(height: 15),

                  // ⏱ UPCOMING
                  _card(
                    title: "Vitamin D3",
                    subtitle: "1000 IU — Once Daily",
                    time: "06:00 PM",
                    status: "UPCOMING",
                    color: Colors.grey,
                  ),

                  const SizedBox(height: 15),

                  // ❌ MISSED
                  _missedCard(),

                  const SizedBox(height: 30),

                  // ➕ ADD PRESCRIPTION
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "+ Add Prescription",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔻 BOTTOM NAV
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
        onPressed: () {},
        child: const Icon(Icons.emergency),
      ),
    );
  }
}

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
          Text(count, style: TextStyle(color: color, fontSize: 18)),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

Widget _card({
  required String title,
  required String subtitle,
  required String time,
  required String status,
  required Color color,
}) {
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(status, style: TextStyle(color: color)),
            Text(time),
          ],
        ),
      ],
    ),
  );
}

Widget _pendingCard() {
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.teal],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(
            child: Text(
              "✔ Mark as Taken",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}

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
        Text("⚠ Alert: Dose missed over 2 hours ago.",
            style: TextStyle(color: Colors.red)),
      ],
    ),
  );
}

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