import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Icon(Icons.arrow_back, color: Colors.blue),
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return DropdownButton<String>(
                  value: languageProvider.currentLocale.languageCode,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.language, color: Colors.blue),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      languageProvider.setLocale(Locale(newValue));
                    }
                  },
                  items: [
                    const DropdownMenuItem(
                      value: 'en',
                      child: Text("English"),
                    ),
                    const DropdownMenuItem(
                      value: 'mr',
                      child: Text("मराठी"),
                    ),
                    const DropdownMenuItem(
                      value: 'hi',
                      child: Text("हिन्दी"),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectRole,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    AppLocalizations.of(context)!.chooseRoleSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView(
                      children: [

                        // 🟢 ADMIN
                        _roleCard(
                          context: context,
                          role: "admin",
                          icon: Icons.admin_panel_settings,
                          title: AppLocalizations.of(context)!.admin,
                          subtitle: AppLocalizations.of(context)!.adminSubtitle,
                        ),

                        // 🔵 CARETAKER
                        _roleCard(
                          context: context,
                          role: "caretaker",
                          icon: Icons.medical_services,
                          title: AppLocalizations.of(context)!.caretaker,
                          subtitle: AppLocalizations.of(context)!.caretakerSubtitle,
                        ),

                        // 🟣 FAMILY
                        _roleCard(
                          context: context,
                          role: "family",
                          icon: Icons.family_restroom,
                          title: AppLocalizations.of(context)!.family,
                          subtitle: AppLocalizations.of(context)!.familySubtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.termsOfService),
                const SizedBox(width: 10),
                const Text("•"),
                const SizedBox(width: 10),
                Text(AppLocalizations.of(context)!.privacyPolicy),
                const SizedBox(width: 10),
                const Text("•"),
                const SizedBox(width: 10),
                Text(AppLocalizations.of(context)!.needHelp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 UPDATED ROLE CARD
  Widget _roleCard({
    required BuildContext context,
    required String role,   // ✅ NEW
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(role: role), // ✅ PASS ROLE
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10)
          ],
        ),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.blue, size: 30),
            ),

            const SizedBox(height: 15),

            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}