import 'package:flutter/material.dart';

class FamilyVitalsScreen extends StatelessWidget {
  const FamilyVitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Health & Vitals",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Lexend",
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Detailed health history for Arthur",
            style: TextStyle(color: Colors.grey, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 24),

          // Heart Rate Detail
          _vitalDetailCard(
            icon: Icons.favorite,
            color: Colors.red,
            title: "Heart Rate",
            currentValue: "72 bpm",
            trend: "Stable",
            chartPlaceholder: _buildChartPlaceholder(Colors.red),
          ),
          const SizedBox(height: 16),

          // Sleep Detail
          _vitalDetailCard(
            icon: Icons.bedtime,
            color: Colors.purple,
            title: "Sleep Quality",
            currentValue: "7h 45m",
            trend: "+30m from yesterday",
            chartPlaceholder: _buildChartPlaceholder(Colors.purple),
          ),
          const SizedBox(height: 16),

          // Blood Pressure
          _vitalDetailCard(
            icon: Icons.water_drop,
            color: Colors.blue,
            title: "Blood Pressure",
            currentValue: "128 / 84",
            trend: "Normal Range",
            chartPlaceholder: _buildChartPlaceholder(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _vitalDetailCard({
    required IconData icon,
    required Color color,
    required String title,
    required String currentValue,
    required String trend,
    required Widget chartPlaceholder,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lexend",
                ),
              ),
              const Spacer(),
              Text(
                currentValue,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lexend",
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          chartPlaceholder,
          const SizedBox(height: 12),
          Text(
            trend,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontFamily: "Lexend",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(Color color) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.show_chart, color: color.withOpacity(0.5), size: 40),
      ),
    );
  }
}
