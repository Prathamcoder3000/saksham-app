import 'dart:ui';
import 'package:flutter/material.dart';

class AddResidentScreen extends StatefulWidget {
  const AddResidentScreen({super.key});

  @override
  State<AddResidentScreen> createState() => _AddResidentScreenState();
}

class _AddResidentScreenState extends State<AddResidentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _medicalController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _saveResident() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Resident successfully saved!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
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
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF004AC6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Add Resident",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF004AC6),
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
              child: Form(
                key: _formKey,
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
                                color: const Color(0xFFEAEFF3),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2563EB),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Upload Resident Photo",
                          style: TextStyle(
                            color: Colors.grey,
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
                          _field("Full Name", "e.g. Samuel Johnson", _nameController),
                          const SizedBox(height: 15),
                          _field("Age", "Resident's age", _ageController, isNumber: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🏥 MEDICAL
                    _card(
                      icon: Icons.medical_services,
                      title: "Medical Profile",
                      child: _textArea(
                        "Medical Conditions",
                        "List allergies, chronic illnesses, or recent surgeries...",
                        _medicalController,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 📞 CONTACT
                    _card(
                      icon: Icons.contact_emergency,
                      title: "Emergency Contacts",
                      child: Column(
                        children: [
                          _field("Contact Name", "Name of primary contact",
                              _contactNameController,
                              icon: Icons.person),
                          const SizedBox(height: 15),
                          _field("Phone Number", "+1 (555) 000-0000",
                              _phoneController,
                              icon: Icons.call, isNumber: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🔘 BUTTON
                    GestureDetector(
                      onTap: _saveResident,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 30,
                            )
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Save Resident",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "CONFIRM ALL DATA BEFORE SAVING",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController controller,
      {IconData? icon, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (value) =>
              value == null || value.isEmpty ? "Required component" : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.grey) : null,
            filled: true,
            fillColor: const Color(0xFFEAEFF3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _textArea(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 4,
          validator: (value) =>
              value == null || value.isEmpty ? "Required component" : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEAEFF3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}