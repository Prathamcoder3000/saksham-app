import 'package:flutter/material.dart';
import 'package:saksham/providers/auth_provider.dart';
import 'package:saksham/services/api_service.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../extensions/localization_extension.dart';
import 'daily_checklist_screen.dart';
import 'medicine_tracker.dart';
import 'emergency_sos.dart';
import 'caretaker_resident_list.dart';
import 'caretaker_profile_screen.dart';
import 'change_password_screen.dart';

class CaretakerDashboard extends StatefulWidget {
  final int initialIndex;
  const CaretakerDashboard({super.key, this.initialIndex = 0});

  @override
  State<CaretakerDashboard> createState() => _CaretakerDashboardState();
}

class _CaretakerDashboardState extends State<CaretakerDashboard> {
  int _currentIndex = 0;
  bool _isLoading = true;
  int _pendingTasks = 0;
  List<dynamic> _careLogs = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _fetchSummary();
    _fetchCareLogs();
  }

  Future<void> _fetchSummary() async {
    try {
        final taskRes = await ApiService.get('/tasks');
        if (taskRes.statusCode == 200) {
            final List<dynamic> tasks = jsonDecode(taskRes.body)['data'];
            if (mounted) {
              setState(() {
                  _pendingTasks = tasks.where((t) => t['status'] == 'pending').length;
              });
            }
        }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load pending tasks')));
    }
  }

  Future<void> _fetchCareLogs() async {
    try {
      final response = await ApiService.get('/care-logs');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (mounted) {
          setState(() {
            _careLogs = data;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
         setState(() => _isLoading = false);
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error updating care logs')));
      }
    }
  }
  static const bg = Color(0xFFF6FAFE);
  static const primary = Color(0xFF004AC6);
  static const primaryContainer = Color(0xFF2563EB);
  static const secondary = Color(0xFF006B5F);
  static const secondaryContainer = Color(0xFF6DF5E1);
  static const surfaceLow = Color(0xFFF0F4F8);
  static const surfaceHigh = Color(0xFFE4E9ED);
  static const surfaceWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _currentIndex == 0 ? PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n!.caretaker_dashboard,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const Icon(Icons.notifications_none_rounded, color: primary),
            ],
          ),
        ),
      ) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const CaretakerResidentListScreen(isTab: true), 
          const DailyChecklistScreen(isTab: true),
          const CaretakerProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 25,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, "Home", 0),
            _navItem(Icons.people_alt_rounded, "Residents", 1),
            _navItem(Icons.checklist_rounded, "Care", 2),
            _navItem(Icons.person_rounded, "Profile", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final String name = auth.user?.name ?? 'Caregiver';
              final String firstName = name.isNotEmpty ? name.split(' ')[0] : 'Caregiver';
              final bool isDefault = auth.user?.isDefaultPassword ?? false;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDefault) 
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.security, color: Color(0xFFDC2626), size: 20),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Update your default password for better security.",
                              style: TextStyle(fontSize: 13, color: Color(0xFF991B1B)),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
                            child: const Text("Update", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        firstName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "👋",
                        style: TextStyle(fontSize: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ready to care for our residents?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.priority_high_rounded, color: primary, size: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  "$_pendingTasks priority tasks for today",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _tile(
            bgColor: surfaceWhite,
            iconBg: const Color(0xFFE0E7FF),
            iconColor: primary,
            icon: Icons.people_outline_rounded,
            title: "Residents",
            subtitle: "View and manage active resident profiles",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CaretakerResidentListScreen(),
                ),
              );
            },
          ),
          _tile(
            bgColor: surfaceWhite,
            iconBg: const Color(0xFFE0F2F1),
            iconColor: const Color(0xFF00796B),
            icon: Icons.medication_outlined,
            title: "Medication",
            subtitle: "Track and confirm medicine administration",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicineTrackerScreen(),
                ),
              );
            },
          ),
          _tile(
            bgColor: surfaceWhite,
            iconBg: const Color(0xFFFFF3E0),
            iconColor: const Color(0xFFE65100),
            icon: Icons.checklist_rtl_rounded,
            title: "Daily Tasks",
            subtitle: "Standard care routines and hygiene checks",
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmergencySOSScreen(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primary, primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(Icons.sos_rounded, color: Colors.white, size: 28),
                      ),
                    ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency SOS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Immediate support system",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.history_rounded, color: primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n!.recent_activity,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_careLogs.isEmpty)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(context.l10n!.no_items_found, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                  ))
                else
                  ..._careLogs.take(5).map((log) {
                    Color logColor = primary;
                    IconData logIcon = Icons.info_outline_rounded;
                    if (log['type'] == 'medication') {
                      logColor = secondary;
                      logIcon = Icons.medical_services_outlined;
                    }
                    if (log['type'] == 'vitals') {
                      logColor = Colors.orange;
                      logIcon = Icons.favorite_border_rounded;
                    }
                    
                    return _activityItem(
                      "${log['title'] ?? log['description'] ?? 'Activity recorded'}",
                      log['timestamp'] != null ? _formatTime(log['timestamp']) : "Just now",
                      logIcon,
                      logColor,
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required Color bgColor,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black.withOpacity(0.01)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String _formatTime(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "Recently";
    }
  }

  Widget _dotNote(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool active = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: active ? primary.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: active ? primary : Colors.grey.shade400, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? primary : Colors.grey.shade400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}