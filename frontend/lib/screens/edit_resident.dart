import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/resident_model.dart';
import 'dart:convert';

class EditResidentScreen extends StatefulWidget {
  final String residentId;
  const EditResidentScreen({super.key, required this.residentId});

  @override
  State<EditResidentScreen> createState() => _EditResidentScreenState();
}

class _EditResidentScreenState extends State<EditResidentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _roomController;
  late TextEditingController _medicalController;
  late TextEditingController _contactNameController;
  late TextEditingController _phoneController;

  bool _isLoading = true;
  bool _isSaving = false;
  ResidentModel? _resident;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _roomController = TextEditingController();
    _medicalController = TextEditingController();
    _contactNameController = TextEditingController();
    _phoneController = TextEditingController();
    _fetchResident();
  }

  Future<void> _fetchResident() async {
    try {
      final response = await ApiService.get('/residents/${widget.residentId}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _resident = ResidentModel.fromJson(data);
          _nameController.text = _resident!.name;
          _ageController.text = _resident!.age.toString();
          _roomController.text = _resident!.room;
          _medicalController.text = _resident!.conditions.join(', ');
          _contactNameController.text = _resident!.contactName ?? '';
          _phoneController.text = _resident!.contactPhone ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final response = await ApiService.put('/residents/${widget.residentId}', {
          'name': _nameController.text,
          'age': int.tryParse(_ageController.text) ?? _resident!.age,
          'room': _roomController.text,
          'conditions': _medicalController.text.split(',').map((s) => s.trim()).toList(),
          'emergencyContactName': _contactNameController.text,
          'emergencyContactPhone': _phoneController.text,
        });

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Resident updated successfully!"), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error updating resident")),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  _resident?.photoUrl ?? "https://i.pravatar.cc/300?u=${widget.residentId}",
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
                          _field("FULL NAME", _nameController),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(child: _field("AGE", _ageController, isNumber: true)),
                              const SizedBox(width: 15),
                              Expanded(child: _field("ROOM", _roomController)),
                            ],
                          ),
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
                        "MEDICAL CONDITIONS (Comma separated)",
                        _medicalController,
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
                          _field("CONTACT NAME", _contactNameController),
                          const SizedBox(height: 15),
                          _field("PHONE NUMBER", _phoneController,
                              icon: Icons.call, isNumber: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔘 UPDATE BUTTON
                    GestureDetector(
                      onTap: _isSaving ? null : _saveChanges,
                      child: Container(
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
                        child: Center(
                          child: _isSaving 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Update Resident",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ❌ CANCEL BUTTON
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
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

  Widget _field(String label, TextEditingController controller, {IconData? icon, bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 1),
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
              if (icon != null) Icon(icon, size: 18, color: Colors.grey),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                  decoration: const InputDecoration(border: InputBorder.none),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textArea(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEFF3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(border: InputBorder.none),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
          ),
        ),
      ],
    );
  }
}