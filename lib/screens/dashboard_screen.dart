import 'package:flutter/material.dart';
import 'resident_list.dart';
import 'manage_staff.dart';
import 'reports_screen.dart';
class DashboardScreen extends StatelessWidget {
    const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // ── Top App Bar ──
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 1,
                shadowColor: Colors.blue.withOpacity(0.1),
                leading: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.grey),
                  onPressed: () {},
                ),
                title: const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFDBE1FF),
                      child: const Icon(Icons.person,
                          color: Color(0xFF00174B), size: 20),
                    ),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Welcome Banner ──
                    _WelcomeBanner(),
                    const SizedBox(height: 20),

                    // ── Stats Cards ──
                    _StatCard(
                      label: 'Total Residents',
                      value: '142',
                      trailing: _BadgeWidget(label: '+4%', color: const Color(0xFF006B5F)),
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: 'Care Utilization',
                      value: '88%',
                      trailing: _ProgressBarWidget(value: 0.88),
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: 'Staff Ratio',
                      value: '1:4',
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
                            builder: (context) => const ResidentListScreen(),
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
                          builder: (context) => const ReportsScreen(),
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
                    _ActionCard(
                      icon: Icons.notifications_active,
                      title: 'Emergency Alerts',
                      subtitle: 'Review active SOS triggers and incidents',
                      isError: true,
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
                          onPressed: () {},
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
                          _CareLogItem(
                            icon: Icons.medication,
                            iconBg: const Color(0xFF6DF5E1),
                            iconColor: const Color(0xFF006B5F),
                            title: 'Medication administered to Mr. Sharma',
                            subtitle: 'Caregiver: Anjali M. • 10 mins ago',
                            time: '10:45 AM',
                          ),
                          const SizedBox(height: 10),
                          _CareLogItem(
                            icon: Icons.check_circle,
                            iconBg: const Color(0xFFDBE1FF),
                            iconColor: const Color(0xFF004AC6),
                            title: 'Vital signs update for Mrs. Gupta',
                            subtitle: 'Caregiver: Rohan K. • 45 mins ago',
                            time: '10:10 AM',
                          ),
                          const SizedBox(height: 10),
                          _CareLogItem(
                            icon: Icons.restaurant,
                            iconBg: const Color(0xFFD8E3FB),
                            iconColor: const Color(0xFF111C2D),
                            title: 'Breakfast menu confirmed for Wing B',
                            subtitle: 'Dietician: Sarah J. • 2 hrs ago',
                            time: '08:30 AM',
                          ),
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

          // ── FAB ──
          Positioned(
            bottom: 88,
            right: 20,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF004AC6).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
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
                // Dashboard (active)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.dashboard,
                          color: Color(0xFF1D4ED8), size: 22),
                      SizedBox(height: 2),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF1D4ED8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.grey, size: 22),
                    SizedBox(height: 2),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WELCOME BANNER
// ─────────────────────────────────────────────
class _WelcomeBanner extends StatelessWidget {
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
              const Text(
                'Welcome,\nAdmin',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Everything at Saksham is running smoothly. You have 3 pending alerts and 12 staff members active on duty today.',
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
              onPressed: () {},
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