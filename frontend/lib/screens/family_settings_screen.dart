import 'package:flutter/material.dart';
import 'role_selection.dart';

class FamilySettingsScreen extends StatelessWidget {
  const FamilySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings & Profile",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Lexend",
            ),
          ),
          const SizedBox(height: 24),

          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF2563EB),
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sharma Family",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Lexend"),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "sharma.family@saksham.in",
                      style: TextStyle(color: Colors.grey.shade600, fontFamily: "Lexend"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          const Text(
            "Preferences",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 12),
          _settingsTile(context, Icons.notifications, "Notifications", "Manage alert preferences"),
          _settingsTile(context, Icons.security, "Privacy & Security", "Password and biometric login"),
          _settingsTile(context, Icons.language, "Language", "English (US)"),
          
          const SizedBox(height: 30),
          
          const Text(
            "Assistance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 12),
          _settingsTile(context, Icons.help_outline, "Help Center", "FAQ and support"),
          _settingsTile(context, Icons.contact_support, "Contact Facility", "Reach out to administration"),
          
          const SizedBox(height: 40),
          
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Lexend"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title coming soon!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF004AC6)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Lexend"),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontFamily: "Lexend"),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
