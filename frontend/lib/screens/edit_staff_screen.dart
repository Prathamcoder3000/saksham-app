import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/upload_service.dart';
import 'dart:convert';

class EditStaffScreen extends StatefulWidget {
  final Map<String, dynamic> staffData;

  const EditStaffScreen({super.key, required this.staffData});

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _selectedRole;
  File? _selectedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = widget.staffData['user'] ?? {};
    _nameController = TextEditingController(text: user['name'] ?? '');
    _emailController = TextEditingController(text: user['email'] ?? '');
    _phoneController = TextEditingController(text: user['phone'] ?? '');
    
    // Convert role to match dropdown values
    String roleStr = widget.staffData['designation'] ?? user['role'] ?? 'Caretaker';
    if (['Admin', 'Caretaker', 'Family'].contains(roleStr)) {
      _selectedRole = roleStr;
    } else {
      _selectedRole = 'Caretaker';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await UploadService.pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _updateStaff() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      try {
        final userId = widget.staffData['user']?['_id'] ?? widget.staffData['user']?['id'] ?? widget.staffData['_id'];
        
        // This simulates a PUT request to update staff details
        final response = await ApiService.put('/users/$userId', {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'role': _selectedRole,
        });

        if (!mounted) return;

        if (response.statusCode == 200 || response.statusCode == 201) {
            if (_selectedImage != null) {
                await UploadService.uploadPhoto('/upload/staff-photo/$userId', _selectedImage!);
            }

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Staff details updated successfully!"), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
        } else {
            final data = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data['message'] ?? "Error updating staff")),
            );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Connection error")),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
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
                        "Edit Staff",
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
                      "EDIT PROFILE",
                      style: TextStyle(
                        color: Color(0xFF004AC6),
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Update Caregiver Details",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Modify the details below to update this staff member's record in the Saksham care team.",
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
                              child: Icon(Icons.add_photo_alternate,
                                  size: 30, color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text("Change Photo",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ) : null,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🔹 BUTTON
                    GestureDetector(
                      onTap: _isSaving ? null : _updateStaff,
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
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Save Changes",
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
