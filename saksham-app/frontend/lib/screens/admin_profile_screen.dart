import 'package:flutter/material.dart';
import 'role_selection.dart';
import '../l10n/app_localizations.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(height: 24),

          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF1D4ED8),
                  child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.admin,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "admin@saksham.in",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          Text(
            AppLocalizations.of(context)!.settings,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _settingsTile(context, Icons.store, "Facility Details", "Manage branches & locations"),
          _settingsTile(context, Icons.groups, "Staff Permissions", "Role-based access lists"),
          _settingsTile(context, Icons.backup, "Data & Integrations", "Export records and logs"),
          
          const SizedBox(height: 30),
          
          const Text(
            "Security",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _settingsTile(context, Icons.security, "Two-Factor Auth", "Currently Active"),
          _settingsTile(context, Icons.history, "Audit Logs", "Review administrative actions"),
          
          const SizedBox(height: 40),
          
          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                AppLocalizations.of(context)!.logout,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title coming soon!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1D4ED8)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
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
