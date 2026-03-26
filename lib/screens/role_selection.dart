import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Icon(Icons.arrow_back, color: Colors.blue),
        title: const Text(
          "Saksham",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Select Your Role",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Choose how you'll interact with the Saksham ecosystem today.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView(
                      children: [

                        // 🟢 ADMIN
                        _roleCard(
                          context: context,
                          role: "admin",
                          icon: Icons.admin_panel_settings,
                          title: "Admin",
                          subtitle:
                              "Manage organization, staff, and overall operations.",
                        ),

                        // 🔵 CARETAKER
                        _roleCard(
                          context: context,
                          role: "caretaker",
                          icon: Icons.medical_services,
                          title: "Caretaker",
                          subtitle:
                              "Monitor patients, update vitals, and log care activities.",
                        ),

                        // 🟣 FAMILY
                        _roleCard(
                          context: context,
                          role: "family",
                          icon: Icons.family_restroom,
                          title: "Family Member",
                          subtitle:
                              "Track your loved one's health and stay updated.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Terms of Service"),
                SizedBox(width: 10),
                Text("•"),
                SizedBox(width: 10),
                Text("Privacy Policy"),
                SizedBox(width: 10),
                Text("•"),
                SizedBox(width: 10),
                Text("Need Help?"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 UPDATED ROLE CARD
  Widget _roleCard({
    required BuildContext context,
    required String role,   // ✅ NEW
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(role: role), // ✅ PASS ROLE
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10)
          ],
        ),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.blue, size: 30),
            ),

            const SizedBox(height: 15),

            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}