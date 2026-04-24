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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blue, size: 18),
                      ),
                    ),
                    const Text(
                      "Resident Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
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
                          // Handle updated data
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.blue, size: 18),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 👤 PROFILE
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.withOpacity(0.1), width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Text(
                        data["name"]![0],
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                        ),
                        child: Text(
                          data["room"]!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.green),
                            SizedBox(width: 6),
                            Text(
                              "ACTIVE",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    data["name"]!,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), letterSpacing: -0.5),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _badge("${data["age"] ?? "N/A"} Years"),
                      const SizedBox(width: 10),
                      _badge("Regular Care", icon: Icons.verified_rounded),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt_rounded, color: Colors.white.withOpacity(0.8), size: 20),
                        const SizedBox(width: 8),
                        const Text("QUICK ACTIONS",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                fontSize: 12)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _actionBtn(Icons.call_rounded, "Call", () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Initiating call...")));
                        }),
                        _actionBtn(Icons.medication_rounded, "Meds", () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicineTrackerScreen()));
                        }),
                        _actionBtn(Icons.assignment_rounded, "Tasks", () {
                          // Already on resident profile, maybe show specific tasks
                        }),
                        _actionBtn(Icons.sos_rounded, "SOS", () {
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  static Widget _badge(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 12),
          ),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
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
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)
        ),
      ],
    ),
  );
}