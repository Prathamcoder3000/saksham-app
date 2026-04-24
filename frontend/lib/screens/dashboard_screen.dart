import 'package:flutter/material.dart';
import 'resident_list.dart';
import 'manage_staff.dart';
import 'reports_screen.dart';
import 'add_resident.dart';
import 'admin_profile_screen.dart';
import 'analytics_screen.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'notifications_screen.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic> _summaryData = {};

  List<dynamic> _recentLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    try {
      final summaryRes = await ApiService.get('/reports/summary');
      final logsRes = await ApiService.get('/care-logs?limit=3');
      
      if (summaryRes.statusCode == 200) {
        _summaryData = jsonDecode(summaryRes.body)['data'];
      }
      
      if (logsRes.statusCode == 200) {
        _recentLogs = jsonDecode(logsRes.body)['data'];
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logsToShow = _recentLogs;
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Tab 0: Home Dashboard
          RefreshIndicator(
            onRefresh: _fetchSummary,
            color: const Color(0xFF004AC6),
            child: Stack(
              children: [
                // Scrollable content
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 1,
                shadowColor: Colors.blue.withOpacity(0.1),
                title: const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Color(0xFF1A1A2E)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                        },
                      ),
                    ],
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Welcome Banner ──
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) => _WelcomeBanner(
                        name: auth.user?.name ?? 'Admin',
                        activeAlerts: _summaryData['activeAlerts'] ?? 0,
                        staffActive: _summaryData['staffRatio'] != null
                            ? int.tryParse(_summaryData['staffRatio'].split(':')[0]) ?? 12
                            : 12,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Stats Cards ──
                    _StatCard(
                      label: 'Today\'s Check-ins',
                      value: '${_summaryData['dailyCheckins'] ?? 0}',
                      trailing: _BadgeWidget(label: 'Live', color: const Color(0xFF006B5F)),
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: 'Care Utilization',
                      value: '${_summaryData['adherenceRate'] ?? 0}%',
                      trailing: _ProgressBarWidget(value: (_summaryData['adherenceRate'] ?? 0) / 100.0),
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: 'Staff Ratio',
                      value: '${_summaryData['staffRatio'] ?? '1:1'}',
                      trailing: const Icon(Icons.diversity_3,
                          color: Color(0xFF004AC6), size: 36),
                    ),
                    const SizedBox(height: 24),

                    // ── Core Actions ──
                    _SectionHeader(title: 'Core Actions'),
                    const SizedBox(height: 12),
                   GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddResidentScreen(),
                          ),
                        );
                      },
                      child: _ActionCard(
                        icon: Icons.person_add,
                        title: 'Add Resident',
                        subtitle: 'Onboard new seniors to the care program',
                        isError: false,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageStaffScreen(),
                          ),
                        );
                      },
                      child: _ActionCard(
                        icon: Icons.group,
                        title: 'Manage Staff',
                        subtitle: 'Assign duties and view caregivers',
                        isError: false, // ✅ FIX ADDED
                      ),
                    ),
                    const SizedBox(height: 10),
                   GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnalyticsScreen(),
                        ),
                      );
                    },
                    child: _ActionCard(
                      icon: Icons.analytics,
                      title: 'Reports',
                      subtitle: 'View performance and analytics',
                      isError: false,
                    ),
                  ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Emergency Alerts triggered!'))
                        );
                      },
                      child: _ActionCard(
                        icon: Icons.notifications_active,
                        title: 'Emergency Alerts',
                        subtitle: '${_summaryData['activeAlerts'] ?? 0} active SOS triggers',
                        isError: (_summaryData['activeAlerts'] ?? 0) > 0,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Recent Care Logs ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Care Logs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReportsScreen()),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: Color(0xFF004AC6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...logsToShow.map((log) {
                            IconData icon = Icons.info;
                            Color bg = const Color(0xFFDBE1FF);
                            Color color = const Color(0xFF004AC6);

                            if (log['type'] == 'medication') {
                              icon = Icons.medication;
                              bg = const Color(0xFF6DF5E1);
                              color = const Color(0xFF006B5F);
                            } else if (log['type'] == 'vitals') {
                              icon = Icons.favorite;
                              bg = const Color(0xFFFFD8E4);
                              color = const Color(0xFFB3261E);
                            } else if (log['type'] == 'activity') {
                              icon = Icons.restaurant;
                              bg = const Color(0xFFD8E3FB);
                              color = const Color(0xFF111C2D);
                            }

                            final caretakerName = log['caretaker'] != null 
                                ? log['caretaker']['name'] 
                                : 'Staff';
                            final timeStr = log['createdAt'] != null 
                                ? log['createdAt'].toString().substring(11, 16) 
                                : '--:--';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _CareLogItem(
                                icon: icon,
                                iconBg: bg,
                                iconColor: color,
                                title: log['content'] ?? 'Action performed',
                                subtitle: 'Caregiver: $caretakerName',
                                time: timeStr,
                              ),
                            );
                          }).toList(),
                          if (logsToShow.isEmpty)
                            const Center(child: Text("No recent activity logs.")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Facility Wellness ──
                    _FacilityWellnessCard(),
                  ]),
                ),
              ),
              ],
            ),
              ],
            ),
          ),
          // Tab 1: Residents
          const ResidentListScreen(isTab: true),
          // Tab 2: Staff
          const ManageStaffScreen(isTab: true),
          // Tab 3: Profile
          const AdminProfileScreen(),
        ],
      ),

      // ── Bottom Nav Bar ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.dashboard, 'Dashboard', 0),
                _navItem(Icons.people, 'Residents', 1),
                _navItem(Icons.badge, 'Staff', 2),
                _navItem(Icons.person, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool active = _currentIndex == index;
    if (active) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFDBEAFE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1D4ED8), size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────
// WELCOME BANNER
// ─────────────────────────────────────────────
class _WelcomeBanner extends StatelessWidget {
  final String name;
  final int activeAlerts;
  final int staffActive;

  const _WelcomeBanner({
    super.key,
    required this.name,
    this.activeAlerts = 0,
    this.staffActive = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004AC6).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative orb
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SYSTEM OVERVIEW',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome,\n$name',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Everything at Saksham is running smoothly. You have $activeAlerts pending alerts and $staffActive staff members active on duty today.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STAT CARD
// ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget trailing;

  const _StatCard({
    required this.label,
    required this.value,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF171C1F),
                  height: 1.0,
                ),
              ),
              trailing,
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BADGE WIDGET
// ─────────────────────────────────────────────
class _BadgeWidget extends StatelessWidget {
  final String label;
  final Color color;

  const _BadgeWidget({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROGRESS BAR WIDGET
// ─────────────────────────────────────────────
class _ProgressBarWidget extends StatelessWidget {
  final double value;

  const _ProgressBarWidget({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 6,
          backgroundColor: const Color(0xFFEAEEF2),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF004AC6)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ACTION CARD
// ─────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isError;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: isError
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: isError ? const Color(0xFFBA1A1A) : null,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (isError
                          ? const Color(0xFFBA1A1A)
                          : const Color(0xFF2563EB))
                      .withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF171C1F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade300,
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CARE LOG ITEM
// ─────────────────────────────────────────────
class _CareLogItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _CareLogItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconBg,
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF171C1F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FACILITY WELLNESS CARD
// ─────────────────────────────────────────────
class _FacilityWellnessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 10,
                    backgroundColor: const Color(0xFFEAEEF2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2563EB)),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF171C1F),
                      ),
                    ),
                    Text(
                      'GOAL',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Facility Wellness',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF171C1F),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The overall health index of all residents is currently optimal.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          // Health Audit Button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Health Audit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}