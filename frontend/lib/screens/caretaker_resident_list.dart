import 'package:flutter/material.dart';
import 'resident_profile.dart';
import 'caretaker_resident_profile.dart';
import 'caretaker_add_resident.dart';
import 'caretaker_dashboard.dart';

class CaretakerResidentListScreen extends StatefulWidget {
  const CaretakerResidentListScreen({super.key});

  @override
  State<CaretakerResidentListScreen> createState() =>
      _CaretakerResidentListScreenState();
}

class _CaretakerResidentListScreenState
    extends State<CaretakerResidentListScreen> {

  String selectedFilter = "all";

  final residents = [
    {
      "name": "Ramesh Sharma",
      "room": "Room 302 • North Wing",
      "status": "stable"
    },
    {
      "name": "Sunita Patel",
      "room": "Room 105 • East Wing",
      "status": "monitoring"
    },
    {
      "name": "Anil Desai",
      "room": "Room 412 • South Wing",
      "status": "stable"
    },
    {
      "name": "Lata Mangeshkar",
      "room": "Room 209 • West Wing",
      "status": "stable"
    },
    {
      "name": "Rajesh Khanna",
      "room": "Room 101 • East Wing",
      "status": "critical"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: SafeArea(
        child: Column(
          children: [

            // 🔝 HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  const Text("Residents",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blue)),
                ],
              ),
            ),

            // 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search residents...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔘 FILTER CHIPS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chip("all", "All"),
                _chip("stable", "Stable"),
                _chip("critical", "Critical"),
              ],
            ),

            const SizedBox(height: 15),

            // 📋 LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: residents.length,
                itemBuilder: (context, index) {

                  final r = residents[index];

                  if (selectedFilter != "all" &&
                      r["status"] != selectedFilter) {
                    return const SizedBox();
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CaretakerResidentProfileScreen(data: r),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.blue.withOpacity(0.02)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [

                          // 👤 AVATAR
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(Icons.person, color: Colors.blue),
                          ),

                          const SizedBox(width: 14),

                          // DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  r["name"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    Icon(Icons.circle,
                                        size: 10,
                                        color: _statusColor(r["status"]!)),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        r["room"]!,
                                        style: const TextStyle(color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // STATUS BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(r["status"]!)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              r["status"]!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                color: _statusColor(r["status"]!),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final newResident = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CaretakerAddResidentScreen(),
            ),
          );

          if (newResident != null) {
            setState(() {
              residents.add(newResident);
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navBtn(Icons.home, "Home", false),
            _navBtn(Icons.monitor_heart, "Vitals", false),
            _navBtn(Icons.handshake, "Care", true),
            _navBtn(Icons.person, "Profile", false),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, String label, bool active) {
    return GestureDetector(
      onTap: () {
        if (active) return;
        
        if (label == "Home") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 0)), (r) => false);
        } else if (label == "Vitals") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 1)), (r) => false);
        } else if (label == "Care") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 2)), (r) => false);
        } else if (label == "Profile") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 3)), (r) => false);
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? const Color(0xFF004AC6) : Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? const Color(0xFF004AC6) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔘 CHIP
  Widget _chip(String value, String label) {
    bool selected = selectedFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "critical":
        return Colors.red;
      case "monitoring":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}