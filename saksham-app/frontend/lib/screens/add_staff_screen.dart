import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/upload_service.dart';
import 'dart:convert';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = "Caretaker";
  File? _selectedImage;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final image = await UploadService.pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _saveStaff() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      try {
        final response = await ApiService.post('/auth/register', {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'role': _selectedRole,
          'password': 'Saksham@123', // System Default
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
            final data = jsonDecode(response.body);
            final staffId = data['user']['id'];

            if (_selectedImage != null) {
                await UploadService.uploadPhoto('/upload/staff-photo/$staffId', _selectedImage!);
            }

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Staff member added successfully!"), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
        } else {
            final data = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data['message'] ?? "Error adding staff")),
            );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Connection error")),
        );
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // 🔝 APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.only(top: 30, left: 16),
                  color: const Color(0xFFF6FAFE).withOpacity(0.8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Add Staff",
                        style: TextStyle(
                          color: Color(0xFF004AC6),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 MAIN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "REGISTRATION",
                      style: TextStyle(
                        color: Color(0xFF004AC6),
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Onboard New Caregiver",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter the details below to add a new member to the Saksham care team.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 25),

                    // 🔹 CARD 1
                    _card(
                      icon: Icons.person,
                      title: "Identity & Role",
                      child: Column(
                        children: [
                          _input("Full Name", "e.g. Rahul Sharma", _nameController),
                          const SizedBox(height: 15),
                          _dropdown("Staff Role"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 CARD 2
                    _card(
                      icon: Icons.contact_page,
                      title: "Contact Channels",
                      child: Column(
                        children: [
                          _phoneInput(),
                          const SizedBox(height: 15),
                          _input("Email Address", "rahul@saksham.care", _emailController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 UPLOAD
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3), width: 2),
                          borderRadius: BorderRadius.circular(16),
                          image: _selectedImage != null 
                            ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                            : null,
                        ),
                        child: _selectedImage == null ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Color(0xFFEAEFF3),
                              child: Icon(Icons.add_a_photo,
                                  size: 30, color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text("Upload Photo",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ) : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 PERMISSION CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF006B5F)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.security, color: Colors.white, size: 30),
                          SizedBox(height: 10),
                          Text(
                            "System Permissions",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Default access level: Standard Caregiver. You can adjust this in Settings after onboarding.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🔹 BUTTON
                    GestureDetector(
                      onTap: _isSaving ? null : _saveStaff,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Add Staff",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Confirmation email will be sent automatically to the staff member.",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Icon(icon, color: Colors.blue),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _input(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: (value) =>
              value == null || value.isEmpty ? "Required field" : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFEAEFF3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEFF3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: "Caretaker", child: Text("Caretaker")),
                DropdownMenuItem(value: "Admin", child: Text("Admin")),
                DropdownMenuItem(value: "Family", child: Text("Family")),
              ],
              onChanged: (val) {
                setState(() {
                  if (val != null) _selectedRole = val;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _phoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Contact Number", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _phoneController,
          validator: (value) =>
              value == null || value.isEmpty ? "Required field" : null,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixText: "+91 ",
            hintText: "98765 43210",
            filled: true,
            fillColor: const Color(0xFFEAEFF3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}