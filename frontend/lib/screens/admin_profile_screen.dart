import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'role_selection.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import 'change_password_screen.dart';
import 'dart:convert';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  
  // NGO Details from API
  String _branchName = "Loading...";
  String _officeAddress = "Loading...";
  String _workingHours = "Loading...";
  Map<String, dynamic> _summaryData = {};
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.user?.name ?? '');
    _emailController = TextEditingController(text: auth.user?.email ?? '');
    _phoneController = TextEditingController(text: auth.user?.phone ?? '');
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoadingData = true);
    try {
      final facilityRes = await ApiService.get('/facility');
      final summaryRes = await ApiService.get('/reports/summary');
      
      if (facilityRes.statusCode == 200) {
        final data = jsonDecode(facilityRes.body)['data'];
        if (data != null) {
          _branchName = data['branchName'] ?? data['name'] ?? "Saksham Main";
          _officeAddress = data['officeAddress'] ?? data['address'] ?? "Gurgaon, India";
          _workingHours = data['workingHours'] ?? "09:00 AM - 06:00 PM";
        }
      }
      
      if (summaryRes.statusCode == 200) {
        _summaryData = jsonDecode(summaryRes.body)['data'] ?? {};
      }
    } catch (e) {
      // Fail silently
    } finally {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isEditing = false);
    try {
      final res = await ApiService.put('/users/me', {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
      });
      
      if (res.statusCode == 200) {
        // Refresh local user data
        if (mounted) {
           await Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated successfully")));
        }
      }
    } catch (e) {
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error updating profile")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchData,
      color: const Color(0xFF1D4ED8),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 120),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final name = auth.user?.name ?? 'Admin';
          final email = auth.user?.email ?? 'admin@saksham.in';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    AppLocalizations.of(context)!.profile,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                  if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF1D4ED8)),
                    onPressed: () => setState(() => _isEditing = true),
                  )
                  else
                  Row(
                    children: [
                       TextButton(
                         onPressed: () => setState(() => _isEditing = false),
                         child: const Text("Cancel")
                       ),
                       TextButton(
                         onPressed: _handleSave,
                         child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold))
                       ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              // ── SECTION 1: IDENTITY ──
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!_isEditing) ...[
                      Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text("NGO Administrator", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                    ] else ...[
                       _editField("Full Name", _nameController),
                    ]
                  ],
                ),
              ),
              
              const SizedBox(height: 30),

              // ── INFO CARDS ──
              _infoCard(
                title: "Contact Information",
                icon: Icons.contact_mail,
                children: [
                  _infoTile("Email", email, Icons.email, _isEditing ? _emailController : null),
                  _infoTile("Phone", auth.user?.phone ?? "+91 98765 43210", Icons.phone, _isEditing ? _phoneController : null),
                ],
              ),
              
              const SizedBox(height: 16),

              _infoCard(
                title: "NGO Branch Details",
                icon: Icons.business,
                children: [
                  _infoTile("Branch Name", _branchName, Icons.store),
                  _infoTile("Office Address", _officeAddress, Icons.location_on),
                  _infoTile("Working Hours", _workingHours, Icons.access_time),
                ],
              ),

              const SizedBox(height: 16),

              _infoCard(
                title: "Administrative summary",
                icon: Icons.analytics,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                        _smallStat("${_summaryData['residentCount'] ?? _summaryData['dailyCheckins'] ?? '0'}", "Residents"),
                        _smallStat("${_summaryData['staffActive'] ?? '12'}", "Active Staff"),
                        _smallStat("${_summaryData['activeAlerts'] ?? '0'}", "Facility Alerts"),
                     ],
                   )
                ],
              ),

              const SizedBox(height: 30),

              // ── ACTIONS ──
              _settingsTile(
                  context, Icons.lock_reset, "Change Password", "Update your security credentials", onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                  }),
              
              const SizedBox(height: 24),

              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false).logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
    );
  }

  Widget _editField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: label,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon, [TextEditingController? controller]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: controller == null 
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _smallStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title coming soon!")));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF0F4F8), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF1D4ED8)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
