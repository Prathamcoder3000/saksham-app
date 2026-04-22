import 'package:flutter/material.dart';
import 'caretaker_edit_resident.dart';
import 'medicine_tracker.dart';
import 'emergency_sos.dart';

class CaretakerResidentProfileScreen extends StatelessWidget {
  final Map<String, String> data;

  const CaretakerResidentProfileScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔝 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CaretakerEditResidentScreen(data: data),
                          ),
                        );
                        if (result != null) {
                          // Handle updated data (e.g., refresh profile)
                        }
                      },
                      child: const Icon(Icons.edit, color: Colors.blue),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 👤 PROFILE
              Column(
                children: [

                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(
                      data["name"]![0],
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data["room"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "ACTIVE",
                    style: TextStyle(color: Colors.green, letterSpacing: 2),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data["name"]!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Chip(label: Text("${data["age"] ?? "N/A"} Years")),
                      const SizedBox(width: 10),
                      const Chip(
                        label: Text("Active Care"),
                        avatar: Icon(Icons.verified, size: 16),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🧾 PERSONAL INFO
              _card(
                title: "Personal Info",
                icon: Icons.person,
                child: Column(
                  children: [
                    _info("Emergency Contact", data["emergencyContactName"] ?? "None"),
                    _info("Phone", data["emergencyContactPhone"] ?? "N/A"),
                    _info("Status", data["status"]?.toUpperCase() ?? "STABLE"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🏥 HEALTH
              _card(
                title: "Health Overview",
                icon: Icons.favorite,
                iconColor: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    if (data["conditions"] != null && data["conditions"]!.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: data["conditions"]!.split(',').map((c) => _chip(c.trim())).toList(),
                      )
                    else
                      const Text("No conditions listed", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 15),
                    const Text("Allergies", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text(data["allergies"] != null && data["allergies"]!.isNotEmpty ? data["allergies"]! : "None",
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 15),
                    const Text("Recent Activity", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text("View full history in Activity Feed", style: TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🚨 QUICK ACTIONS (caretaker specific)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Quick Actions",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        _actionBtn(Icons.phone, "Call", () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Calling emergency contact...")));
                        }),
                        _actionBtn(Icons.medication, "Med", () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicineTrackerScreen()));
                        }),
                        _actionBtn(Icons.warning, "SOS", () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencySOSScreen()));
                        }),

                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 CARD
  static Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
    Color iconColor = Colors.blue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// 🔹 SMALL COMPONENTS

class _info extends StatelessWidget {
  final String title, value;
  const _info(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value),
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
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Text(time, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}

Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}