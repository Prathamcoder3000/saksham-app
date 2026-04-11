import 'dart:ui';
import 'package:flutter/material.dart';
import 'edit_resident.dart';
import 'resident_list.dart';
import 'reports_screen.dart';
import 'dashboard_screen.dart';
class ResidentProfileScreen extends StatelessWidget {
  const ResidentProfileScreen({super.key});

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
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back, color: Colors.blue),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Resident Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditResidentScreen(),
                            ),
                            );
                        },
                        child: const Icon(Icons.edit, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 MAIN CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 100),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 👤 PROFILE HEADER
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 20,
                                )
                              ],
                              image: const DecorationImage(
                                image: NetworkImage("https://i.pravatar.cc/300"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "ROOM 302",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "RESIDENT STATUS: ACTIVE",
                        style: TextStyle(
                          color: Colors.green,
                          letterSpacing: 2,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Ramesh Sharma",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAEFF3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text("82 Years Old"),
                          ),

                          const SizedBox(width: 10),

                          Row(
                            children: const [
                              Icon(Icons.verified, size: 16, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                "Premium Care Tier",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🧍 PERSONAL DETAILS
                  _card(
                    icon: Icons.person,
                    title: "Personal Details",
                    child: Column(
                      children: const [
                        _info("DATE OF BIRTH", "14 May 1941"),
                        _info("GENDER", "Male"),
                        _info("ADMISSION DATE", "12 October 2022"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🏥 MEDICAL
                  _card(
                    icon: Icons.medical_services,
                    title: "Medical Information",
                    iconColor: Colors.teal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text("CONDITIONS",
                            style: TextStyle(fontSize: 11, color: Colors.grey)),

                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8,
                          children: const [
                            _chip("Hypertension"),
                            _chip("Type 2 Diabetes"),
                          ],
                        ),

                        const SizedBox(height: 15),

                        const Text("ALLERGIES",
                            style: TextStyle(fontSize: 11, color: Colors.grey)),

                        const SizedBox(height: 5),

                        Row(
                          children: const [
                            Icon(Icons.warning, color: Colors.red, size: 16),
                            SizedBox(width: 5),
                            Text(
                              "Penicillin (High Severity)",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),

                        const SizedBox(height: 15),

                        const Text("CURRENT MEDICATIONS",
                            style: TextStyle(fontSize: 11, color: Colors.grey)),

                        const SizedBox(height: 10),

                        _med("Metformin", "500m • Daily 8:00 AM"),
                        _med("Amlodipine", "5mg • Daily 8:00 PM"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🚨 EMERGENCY
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        const Row(
                          children: [
                            Icon(Icons.emergency, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Emergency Contacts",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 15),

                        _contact("Priya Sharma", "Primary • Daughter",
                            "+91 98765 43210", true),

                        const SizedBox(height: 10),

                        _contact("Rajiv Sharma", "Secondary • Son",
                            "+91 87654 32109", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),

      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Builder(
          builder: (ctx) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navBtnRpr(ctx, Icons.group, "Residents", true),
              _navBtnRpr(ctx, Icons.favorite, "Health", false),
              _navBtnRpr(ctx, Icons.history, "Timeline", false),
              _navBtnRpr(ctx, Icons.settings, "Settings", false),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 CARD
  static Widget _card({
    required IconData icon,
    required String title,
    required Widget child,
    Color iconColor = Colors.blue,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

// 🔹 SMALL COMPONENTS

class _info extends StatelessWidget {
  final String label, value;
  const _info(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _chip extends StatelessWidget {
  final String text;
  const _chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text));
  }
}

Widget _med(String name, String time) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFEAEFF3),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(time, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

Widget _contact(String name, String role, String phone, bool primary) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(role, style: const TextStyle(color: Colors.white70)),
            Text(phone, style: const TextStyle(color: Colors.white)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primary ? Colors.white : Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.call,
              color: primary ? Colors.blue : Colors.white),
        )
      ],
    ),
  );
}

Widget _navBtnRpr(BuildContext context, IconData icon, String label, bool active) {
  return GestureDetector(
    onTap: () {
      if (active) return;
      if (label == "Residents") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResidentListScreen()));
      } else if (label == "Health" || label == "Timeline") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$label view coming soon!"), behavior: SnackBarBehavior.floating),
        );
      } else if (label == "Settings") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
      }
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Colors.blue : Colors.grey),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}