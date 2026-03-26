import 'package:flutter/material.dart';

class DetailedReportScreen extends StatelessWidget {
  const DetailedReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Overview",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            const SizedBox(height: 10),

            _item(
              icon: Icons.medication,
              title: "Medication Logs",
              subtitle: "42 Active patients",
            ),

            _item(
              icon: Icons.monitor_heart,
              title: "Vital Statistics",
              subtitle: "Stable across 92% of residents",
            ),

            _item(
              icon: Icons.assignment,
              title: "Staff Reports",
              subtitle: "12 Weekly audits completed",
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// 🔹 ITEM CARD (EXACT MATCH)
//////////////////////////////////////////////////////////

Widget _item({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
        )
      ],
    ),
    child: Row(
      children: [

        // ICON BOX
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.blue),
        ),

        const SizedBox(width: 14),

        // TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // ARROW
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    ),
  );
}