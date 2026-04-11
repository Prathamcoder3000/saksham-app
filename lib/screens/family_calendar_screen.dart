import 'package:flutter/material.dart';

class FamilyCalendarScreen extends StatelessWidget {
  const FamilyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Schedule & Events",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Lexend",
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Upcoming care routines and appointments",
            style: TextStyle(color: Colors.grey, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 24),

          // Date Selector Mock
          Row(
            children: [
              _dateCard("Mon", "12", false),
              _dateCard("Tue", "13", true),
              _dateCard("Wed", "14", false),
              _dateCard("Thu", "15", false),
            ],
          ),
          const SizedBox(height: 30),

          // Events
          const Text(
            "Tuesday, Oct 13",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 16),

          _eventItem(
            time: "09:00 AM",
            title: "Morning Medication",
            subtitle: "Administered by Nurse Elena",
            color: Colors.blue,
            icon: Icons.medication,
          ),
          const SizedBox(height: 16),
          _eventItem(
            time: "11:30 AM",
            title: "Doctor Appointment",
            subtitle: "Dr. Smith - Checkup",
            color: Colors.teal,
            icon: Icons.medical_services,
          ),
          const SizedBox(height: 16),
          _eventItem(
            time: "02:00 PM",
            title: "Physiotherapy",
            subtitle: "30 mins walking exercise",
            color: Colors.orange,
            icon: Icons.directions_walk,
          ),
        ],
      ),
    );
  }

  Widget _dateCard(String day, String date, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                color: isActive ? Colors.white70 : Colors.grey,
                fontFamily: "Lexend",
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.black87,
                fontFamily: "Lexend",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventItem({
    required String time,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                time.split(" ")[0],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Lexend"),
              ),
              Text(
                time.split(" ")[1],
                style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: "Lexend"),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Lexend"),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: "Lexend"),
                ),
              ],
            ),
          ),
          Icon(icon, color: color),
        ],
      ),
    );
  }
}
