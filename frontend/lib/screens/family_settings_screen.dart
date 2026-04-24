import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'role_selection.dart';
import 'notifications_screen.dart';
import 'change_password_screen.dart';
import 'help_support_screen.dart';

class FamilySettingsScreen extends StatelessWidget {
  final String? residentName;
  const FamilySettingsScreen({super.key, this.residentName});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4E59A8);
    const textDark = Color(0xFF1E293B);
    const textLight = Color(0xFF64748B);
    const bg = Color(0xFFF8F9FE);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        fontFamily: "Lexend",
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Account Settings & Support",
                      style: TextStyle(
                        color: textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    _buildProfileCard(context, primary, textDark, textLight),
                    const SizedBox(height: 40),
                    
                    _buildSettingsTile(
                      context, 
                      Icons.notifications_active_rounded, 
                      "Notifications", 
                      "Real-time health updates", 
                      primary, 
                      textDark, 
                      textLight,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                    ),
                    
                    _buildSettingsTile(
                      context, 
                      Icons.lock_reset_rounded, 
                      "Change Password", 
                      "Update your login credentials", 
                      primary, 
                      textDark, 
                      textLight,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
                    ),
                    
                    _buildSettingsTile(
                      context, 
                      Icons.support_agent_rounded, 
                      "Contact Facility", 
                      "Direct line to management", 
                      primary, 
                      textDark, 
                      textLight,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
                    ),
                    
                    const SizedBox(height: 48),
                    _buildLogoutButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Color primary, Color textDark, Color textLight) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;
        final name = user?.name ?? "Family Member";
        final email = user?.email ?? "family@example.com";
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary.withOpacity(0.1), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: primary.withOpacity(0.1),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: TextStyle(
                          color: primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Lexend",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: textDark,
                            fontFamily: "Lexend",
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: TextStyle(
                            color: textLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (residentName != null) ...[
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildBadge(primary, "Guardian"),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Connected to $residentName",
                        style: TextStyle(
                          color: textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(Color primary, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_rounded, color: primary, size: 12),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: primary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, 
    IconData icon, 
    String title, 
    String subtitle, 
    Color color, 
    Color textDark, 
    Color textLight,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textDark,
            fontFamily: "Lexend",
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: textLight,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: textLight.withOpacity(0.3),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () async {
          await Provider.of<AuthProvider>(context, listen: false).logout();
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            (r) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 20),
        label: const Text(
          "Sign Out",
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontWeight: FontWeight.w900,
            fontSize: 16,
            fontFamily: "Lexend",
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFEE2E2),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
    );
  }
}

