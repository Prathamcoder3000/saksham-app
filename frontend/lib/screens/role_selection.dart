import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // REMOVE BACK ARROW
        centerTitle: true,
        title: Text(
          l10n.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Color(0xFF2563EB),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return DropdownButton<String>(
                  value: languageProvider.currentLocale.languageCode,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.language_rounded, color: Color(0xFF2563EB)),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      languageProvider.setLocale(Locale(newValue));
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text("EN")),
                    DropdownMenuItem(value: 'mr', child: Text("MR")),
                    DropdownMenuItem(value: 'hi', child: Text("HI")),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      l10n.selectRole,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.chooseRoleSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // 🟢 ADMIN
                    _roleCard(
                      context: context,
                      role: "admin",
                      icon: Icons.admin_panel_settings_rounded,
                      title: l10n.admin,
                      subtitle: l10n.adminSubtitle,
                      color: const Color(0xFF2563EB),
                    ),

                    // 🔵 CARETAKER
                    _roleCard(
                      context: context,
                      role: "caretaker",
                      icon: Icons.medical_services_rounded,
                      title: l10n.caretaker,
                      subtitle: l10n.caretakerSubtitle,
                      color: const Color(0xFF14B8A6),
                    ),

                    // 🟣 FAMILY
                    _roleCard(
                      context: context,
                      role: "family",
                      icon: Icons.family_restroom_rounded,
                      title: l10n.family,
                      subtitle: l10n.familySubtitle,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _footerLink(l10n.termsOfService),
                  _footerDivider(),
                  _footerLink(l10n.privacyPolicy),
                  _footerDivider(),
                  _footerLink(l10n.needHelp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _footerDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 4,
      height: 4,
      decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
    );
  }

  Widget _roleCard({
    required BuildContext context,
    required String role,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 2,
        shadowColor: color.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(role: role),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.blueGrey.shade400,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.blueGrey.shade200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}