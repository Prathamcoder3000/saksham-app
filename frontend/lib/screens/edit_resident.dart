import 'dart:ui';
import 'package:flutter/material.dart';

class EditResidentScreen extends StatelessWidget {
  const EditResidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      body: Stack(
        children: [

          // 🔝 GLASS APP BAR
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 90,
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                color: Colors.white.withOpacity(0.8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Edit Resident",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 MAIN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 20),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 📸 PHOTO
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                )
                              ],
                            ),
                            child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/300",
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Update Profile Picture",
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🧍 PERSONAL INFO
                  _card(
                    icon: Icons.person,
                    title: "Personal Info",
                    child: Column(
                      children: [
                        _field("FULL NAME", "Ramesh Sharma"),
                        const SizedBox(height: 15),
                        _field("AGE", "78"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🏥 MEDICAL
                  _card(
                    icon: Icons.medical_services,
                    title: "Medical Info",
                    iconColor: Colors.teal,
                    child: _textArea(
                      "MEDICAL CONDITIONS",
                      "Type 2 Diabetes, Mild Hypertension",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📞 CONTACT
                  _card(
                    icon: Icons.contact_emergency,
                    title: "Emergency Contact",
                    iconColor: Colors.red,
                    child: Column(
                      children: [
                        _field("CONTACT NAME", "Priya Sharma"),
                        const SizedBox(height: 15),
                        _field("PHONE NUMBER", "+91 98765 43210",
                            icon: Icons.call),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔘 UPDATE BUTTON
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ❌ CANCEL BUTTON
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 CARD
  Widget _card({
    required IconData icon,
    required String title,
    required Widget child,
    Color iconColor = const Color(0xFF2563EB),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // 🔹 FIELD
  Widget _field(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEFF3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              if (icon != null)
                Icon(icon, size: 18, color: Colors.grey),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 TEXTAREA
  Widget _textArea(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEFF3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            maxLines: 3,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}