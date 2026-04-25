import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4E59A8);
    const textDark = Color(0xFF1E293B);
    const textLight = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Contact Facility", 
          style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Lexend")
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We're here to help",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textDark, fontFamily: "Lexend", letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            const Text(
              "Reach out to our facility management team for any queries regarding resident care or administrative help.",
              style: TextStyle(color: textLight, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            
            _buildContactCard(
              Icons.phone_in_talk_rounded,
              "Support Hotline",
              "+91 96195 93111",
              "Available 24/7 for emergencies",
              primary,
              () {}, // Real call action could be added here
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              Icons.alternate_email_rounded,
              "Email Support",
              "gokuloldagehome@gmail.com",
              "Response within 2-4 hours",
              const Color(0xFF14B8A6),
              () {},
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              Icons.location_on_rounded,
              "Facility Address",
              "Prabhakar Niwas, Plot No. 47, Opp New Angel Nursery, Pandurangwadi, Near Model English School, Dombivli 421202",
              "Visit during visiting hours",
              const Color(0xFFF59E0B),
              () {},
            ),
            
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.blue),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Visiting hours: 10:00 AM to 06:00 PM (All Days)",
                      style: TextStyle(color: Color(0xFF1E40AF), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String value, String subtitle, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

