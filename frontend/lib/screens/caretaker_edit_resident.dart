import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';

class CaretakerEditResidentScreen extends StatefulWidget {
  final Map<String, String> data;

  const CaretakerEditResidentScreen({super.key, required this.data});

  @override
  State<CaretakerEditResidentScreen> createState() =>
      _CaretakerEditResidentScreenState();
}

class _CaretakerEditResidentScreenState
    extends State<CaretakerEditResidentScreen> {

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController conditionController;
  late TextEditingController allergyController;
  late TextEditingController contactController;
  late TextEditingController phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.data["name"]);
    ageController = TextEditingController(text: widget.data["age"] ?? "");
    conditionController = TextEditingController(text: widget.data["conditions"] ?? "");
    allergyController = TextEditingController(text: widget.data["allergies"] ?? "");
    contactController = TextEditingController(text: widget.data["emergencyContactName"] ?? "");
    phoneController = TextEditingController(text: widget.data["emergencyContactPhone"] ?? "");
  }

  Future<void> save() async {
    final residentId = widget.data["id"];
    if (residentId == null || residentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot update: Missing resident ID")),
      );
      return;
    }

    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name is required", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final response = await ApiService.put('/residents/caretaker/$residentId', {
        'name': nameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'conditions': conditionController.text.split(',').map((s) => s.trim()).toList(),
        'allergies': allergyController.text.split(',').map((s) => s.trim()).toList(),
        'emergencyContactName': contactController.text,
        'emergencyContactPhone': phoneController.text,
      });

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Resident updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Update failed';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error. Please try again.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔝 HEADER
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Edit Resident",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 👤 PROFILE HEADER (SAME STYLE)
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(
                      nameController.text[0],
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.data["room"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _chipInput(ageController),
                      const SizedBox(width: 10),
                      const Chip(
                        label: Text("Premium Care"),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🧾 PERSONAL INFO
              _card(
                "Personal Info",
                Icons.person,
                Column(
                  children: [
                    _field("DOB", "14 May 1941"),
                    _field("Gender", "Male"),
                    _field("Admission", "12 Oct 2022"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🏥 HEALTH
              _card(
                "Health Overview",
                Icons.favorite,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text("Conditions"),
                    const SizedBox(height: 6),

                    TextField(
                      controller: conditionController,
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 10),

                    const Text("Allergy"),
                    const SizedBox(height: 6),

                    TextField(
                      controller: allergyController,
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 10),

                    const Text("Medication"),

                    const SizedBox(height: 6),

                    _medEditable("Metformin", "8:00 AM"),
                    _medEditable("Amlodipine", "8:00 PM"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 📞 CONTACT
              _card(
                "Emergency Contact",
                Icons.phone,
                Column(
                  children: [
                    TextField(
                      controller: contactController,
                      decoration: _inputDecoration(label: "Name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: _inputDecoration(label: "Phone"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 💾 SAVE
              GestureDetector(
                onTap: _isSaving ? null : save,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isSaving 
                        ? [Colors.grey, Colors.grey]
                        : [Colors.blue, Colors.teal],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text(
                          "Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ❌ CANCEL
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(child: Text("Cancel")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 CARD
  Widget _card(String title, IconData icon, Widget child) {
    return Container(
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
              Icon(icon, color: Colors.blue),
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

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }

  Widget _chipInput(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 60,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? label}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _medEditable(String name, String time) {
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
          Text(time),
        ],
      ),
    );
  }
}