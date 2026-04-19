import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:saksham/services/api_service.dart';


class CaretakerAddResidentScreen extends StatefulWidget {
  const CaretakerAddResidentScreen({super.key});

  @override
  State<CaretakerAddResidentScreen> createState() =>
      _CaretakerAddResidentScreenState();
}

class _CaretakerAddResidentScreenState
    extends State<CaretakerAddResidentScreen> {

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final roomController = TextEditingController();
  final conditionController = TextEditingController();
  final contactController = TextEditingController();
  final phoneController = TextEditingController();
  bool _isSaving = false;

  Future<void> save() async {
    if (nameController.text.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final response = await ApiService.post('/caretaker/residents', {
        "name": nameController.text,
        "age": int.tryParse(ageController.text) ?? 0,
        "room": roomController.text.isEmpty ? "New Wing" : roomController.text,
        "conditions": conditionController.text.split(','),
        "emergencyContactName": contactController.text,
        "emergencyContactPhone": phoneController.text,
      });

      if (response.statusCode == 201) {
        final newResident = jsonDecode(response.body)['data'];
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Resident added!"), backgroundColor: Colors.green),
           );
           Navigator.pop(context, newResident);
        }
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Error adding resident")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection error")),
      );
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
                    "Add Resident",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📸 PHOTO
              Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.camera_alt, size: 30),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 16),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Upload Resident Photo",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 20),

              // 🧾 PERSONAL INFO
              _card(
                "Personal Info",
                Icons.person,
                Column(
                  children: [
                    _field("Full Name", nameController),
                    _field("Age", ageController),
                    _field("Room Number", roomController),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🏥 MEDICAL
              _card(
                "Medical Profile",
                Icons.medical_services,
                _field("Medical Conditions", conditionController,
                    maxLines: 3),
              ),

              const SizedBox(height: 16),

              // 📞 CONTACT
              _card(
                "Emergency Contact",
                Icons.phone,
                Column(
                  children: [
                    _field("Contact Name", contactController),
                    _field("Phone Number", phoneController),
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
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isSaving 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.person_add, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        _isSaving ? "Saving..." : "Save Resident",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "CONFIRM ALL DATA BEFORE SAVING",
                style: TextStyle(fontSize: 10, color: Colors.grey),
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

  // 🔹 FIELD
  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}