import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_staff_screen.dart';
class ManageStaffScreen extends StatelessWidget {
  const ManageStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: Stack(
        children: [

          // 🔝 GLASS APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  color: Colors.white.withOpacity(0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
                          SizedBox(width: 10),
                          Text(
                            "Staff Management",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                         
                          const SizedBox(width: 10),
                          const Icon(Icons.search, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 BODY
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 110, 20, 100),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 📊 STATS (WITH BACKGROUND ICONS)
                  Row(
                    children: [
                      Expanded(child: _stat("Active Staff", "42", false, Icons.group)),
                      const SizedBox(width: 10),
                      Expanded(child: _stat("On Shift", "18", false, Icons.medical_services)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _stat("New Applications", "07", true, Icons.person_add),

                  const SizedBox(height: 25),

                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Staff Directory",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEFF3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.filter_list, size: 16),
                            SizedBox(width: 5),
                            Text("Filter"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  _staff("Dr. Sarah Jenkins", "Senior Caregiver", "Morning Shift", Colors.green),
                  _staff("Marcus Thompson", "Registered Nurse", "On Leave", Colors.grey),
                  _staff("Elena Rodriguez", "Physical Therapist", "Morning Shift", Colors.green),
                  _staff("Dr. James Wilson", "Geriatric Specialist", "Night Shift", Colors.blue),
                  _staff("Lila Chen", "Care Assistant", "Morning Shift", Colors.teal),
                  _staff("David Miller", "Social Worker", "Afternoon Shift", Colors.blue),
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
              padding: const EdgeInsets.only(top: 10, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _nav(Icons.dashboard, "Dashboard", false),
                  _nav(Icons.group, "Staff", true),
                  _nav(Icons.people, "Residents", false),
                  _nav(Icons.settings, "Settings", false),
                ],
              ),
            ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2563EB),
        onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const AddStaffScreen(),
                ),
            );
            },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//////////////////////////////////////////////////
// 🔹 STAT CARD (WITH ICON BACKGROUND)
//////////////////////////////////////////////////
Widget _stat(String title, String value, bool primary, IconData icon) {
  return Container(
    height: 100,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: primary ? const Color(0xFF2563EB) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
      ],
    ),
    child: Stack(
      children: [

        // TEXT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: primary ? Colors.white70 : Colors.grey)),
            const SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primary ? Colors.white : Colors.black)),
          ],
        ),

        // ICON BG
        Positioned(
          right: -10,
          bottom: -10,
          child: Icon(icon,
              size: 80,
              color: primary
                  ? Colors.white.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.08)),
        ),
      ],
    ),
  );
}

//////////////////////////////////////////////////
// 🔹 STAFF CARD (EXACT STYLE)
//////////////////////////////////////////////////
Widget _staff(String name, String role, String shift, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
      ],
    ),
    child: Row(
      children: [

        // IMAGE + STATUS
        Stack(
          children: [
            const CircleAvatar(radius: 28, backgroundColor: Colors.grey),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 14),

        // TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(role, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  shift.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ACTION ICONS
        Column(
          children: const [
            Icon(Icons.edit, size: 18, color: Colors.blue),
            SizedBox(height: 8),
            Icon(Icons.delete, size: 18, color: Colors.red),
          ],
        )
      ],
    ),
  );
}

//////////////////////////////////////////////////
// 🔹 NAV
//////////////////////////////////////////////////
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