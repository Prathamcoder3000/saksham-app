import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'role_selection.dart';
import 'change_password_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'about_app_screen.dart';
import 'shift_history_screen.dart';

class CaretakerProfileScreen extends StatefulWidget {
  const CaretakerProfileScreen({super.key});

  @override
  State<CaretakerProfileScreen> createState() => _CaretakerProfileScreenState();
}

class _CaretakerProfileScreenState extends State<CaretakerProfileScreen> {
  static const primary = Color(0xFF004AC6);
  static const bg = Color(0xFFF1F5F9);
  
  bool _isEditing = false;
  bool _isSaving = false;
  File? _imageFile;
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = auth.user?.name ?? '';
    _phoneController.text = auth.user?.phone ?? '';
    _emailController.text = auth.user?.email ?? '';
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await auth.updateProfile({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
    });

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile")),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile Settings",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: primary),
              onPressed: () => setState(() => _isEditing = true),
            )
          else if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: primary))),
            )
          else
            TextButton(
              onPressed: _handleSave,
              child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(user),
            const SizedBox(height: 30),
            _buildActionSection(),
            const SizedBox(height: 40),
            _buildLogoutButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: primary.withOpacity(0.1),
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Text(
                          (user?.name != null && user!.name.isNotEmpty) ? user!.name[0].toUpperCase() : 'C',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primary),
                        )
                      : null,
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 20),
          if (!_isEditing) ...[
            Text(
              user?.name ?? 'Caretaker',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Text(
              user?.role?.toUpperCase() ?? 'CARETAKER',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary, letterSpacing: 1),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),
            _infoRow(Icons.email_outlined, user?.email ?? '-'),
            const SizedBox(height: 12),
            _infoRow(Icons.phone_outlined, user?.phone ?? '-'),
          ] else ...[
            _editField(_nameController, "Full Name", Icons.person_outline),
            const SizedBox(height: 16),
            _editField(_emailController, "Email Address", Icons.email_outlined),
            const SizedBox(height: 16),
            _editField(_phoneController, "Phone Number", Icons.phone_outlined),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: const Text("Cancel editing", style: TextStyle(color: Colors.red)),
            )
          ]
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
      ],
    );
  }

  Widget _editField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildActionSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          _actionTile(
            icon: Icons.lock_outline_rounded,
            title: "Change Password",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
          ),
          const Divider(height: 1, indent: 70, endIndent: 20),
          _actionTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          const Divider(height: 1, indent: 70, endIndent: 20),
          _actionTile(
            icon: Icons.history_rounded,
            title: "Shift History",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShiftHistoryScreen())),
          ),
          const Divider(height: 1, indent: 70, endIndent: 20),
          _actionTile(
            icon: Icons.help_outline_rounded,
            title: "Help & Support",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
          ),
          const Divider(height: 1, indent: 70, endIndent: 20),
          _actionTile(
            icon: Icons.info_outline_rounded,
            title: "About App",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppScreen())),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Icon(icon, color: primary.withOpacity(0.8), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.w600, 
                  color: Color(0xFF334155),
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _handleLogout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
