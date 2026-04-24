import 'package:flutter/material.dart';
import 'package:saksham/models/resident_model.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import 'family_vitals_screen.dart';
import 'family_calendar_screen.dart';
import 'family_settings_screen.dart';
import 'chat_screen.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class FamilyDashboard extends StatefulWidget {
  const FamilyDashboard({super.key});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}


class _FamilyDashboardState extends State<FamilyDashboard> {
  // UNIQUE FAMILY IDENTITY COLORS
  static const primary = Color(0xFF4E59A8); // Softer Indigo
  static const accent = Color(0xFF9FA8DA);  // Lavender
  static const wellness = Color(0xFF66BB6A); // Soft Green
  static const bg = Color(0xFFF3F4F9);     // Warm Grey/Blue BG
  static const surface = Colors.white;
  static const textDark = Color(0xFF1E293B);
  static const textLight = Color(0xFF64748B);

  int _currentIndex = 0;
  bool _isLoading = true;
  ResidentModel? _resident;
  int _completedMeds = 0;
  int _totalMeds = 0;

  List<dynamic> _recentLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.get('/residents');
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body)['data'];
        if (data.isNotEmpty) {
          _resident = ResidentModel.fromJson(data[0]);

          // Fetch meds status safely
          try {
            final medRes = await ApiService.get('/medicines/today?residentId=${_resident!.id}');
            if (medRes.statusCode == 200) {
              final List<dynamic> meds = jsonDecode(medRes.body)['data'];
              _totalMeds = meds.length;
              _completedMeds = meds.where((m) => m['currentStatus'] == 'taken').length;
            }
          } catch (_) {}

          // Fetch real logs safely
          try {
            final logsRes = await ApiService.get('/care-logs?residentId=${_resident!.id}');
            if (logsRes.statusCode == 200) {
              _recentLogs = jsonDecode(logsRes.body)['data'];
            }
          } catch (_) {}
        }
      }
    } catch (e) {
      // Handle error quietly
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary, strokeWidth: 2))
          : IndexedStack(
              index: _currentIndex,
              children: [
                _resident == null ? _buildNoResidentState() : _buildHomeTab(),
                FamilyVitalsScreen(
                  resident: _resident,
                  onBack: () => setState(() => _currentIndex = 0),
                ),
                FamilyCalendarScreen(
                  onBack: () => setState(() => _currentIndex = 0),
                ),
                FamilySettingsScreen(residentName: _resident?.name),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 🏗️ NO RESIDENT EMPTY STATE
  Widget _buildNoResidentState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_rounded, size: 80, color: primary.withOpacity(0.2)),
          ),
          const SizedBox(height: 32),
          const Text(
            "Welcome to Saksham",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textDark, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 16),
          const Text(
            "We haven't connected your account to a loved one yet. Please contact the facility to start receiving updates.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: textLight, height: 1.6, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 48),
          _buildActionButton("Contact Support", Icons.support_agent_rounded, primary, () {}),
        ],
      ),
    );
  }

  // 🏠 HOME TAB
  Widget _buildHomeTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildGreetingHeader(),
                const SizedBox(height: 30),
                _buildWellbeingHero(),
                const SizedBox(height: 40),
                
                _buildSectionHeader("Today's Wellbeing", "Healthy & Stable"),
                const SizedBox(height: 18),
                _buildQuickVitalsGrid(),
                
                const SizedBox(height: 40),
                _buildSectionHeader("Care Adherence", "View Details"),
                const SizedBox(height: 18),
                _buildMedicationProgressCard(),
                
                const SizedBox(height: 40),
                _buildSectionHeader("Latest Moments", "View Timeline"),
                const SizedBox(height: 18),
                _buildTimeline(),
                
                const SizedBox(height: 40),
                _buildPeaceOfMindCard(),
                const SizedBox(height: 120), 
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: bg,
      elevation: 0,
      automaticallyImplyLeading: false, // FIX: Prevent back button to Role Selection
      centerTitle: false,
      title: Text(
        "Saksham Companion",
        style: TextStyle(
          color: primary.withOpacity(0.9),
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: -0.2,
          fontFamily: "Lexend",
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
            child: const Icon(Icons.notifications_none_rounded, color: textDark, size: 20),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildGreetingHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final name = auth.user?.name.split(" ")[0] ?? "Family";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $name",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textDark, fontFamily: "Lexend", letterSpacing: -0.5),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: wellness, size: 16),
                const SizedBox(width: 8),
                Text(
                  "Everything looks stable today",
                  style: TextStyle(color: textLight, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: "Lexend"),
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textDark, fontFamily: "Lexend")),
        Text(subtitle, style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w700, fontFamily: "Lexend")),
      ],
    );
  }

  Widget _buildWellbeingHero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: primary.withOpacity(0.03), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Hero(
                  tag: 'resident_avatar',
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary.withOpacity(0.08), width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(_resident?.photoUrl ?? "https://i.pravatar.cc/150?u=${_resident?.id}"),
                    ),
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _resident?.name ?? "Loved One",
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textDark, fontFamily: "Lexend", letterSpacing: -1),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: wellness.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: wellness, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                const Text("STABLE", style: TextStyle(color: wellness, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text("Room ${_resident?.room ?? '--'}", style: const TextStyle(color: textLight, fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.02),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Currently resting comfortably after lunch",
                    style: TextStyle(color: textDark.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: textLight.withOpacity(0.5), size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickVitalsGrid() {
    return Row(
      children: [
        Expanded(child: _buildMiniVitalCard(Icons.favorite_rounded, "72", "bpm", "Heart", Colors.redAccent)),
        const SizedBox(width: 14),
        Expanded(child: _buildMiniVitalCard(Icons.air_rounded, "98", "%", "Oxygen", Colors.teal)),
        const SizedBox(width: 14),
        Expanded(child: _buildMiniVitalCard(Icons.thermostat_rounded, "36.5", "°C", "Temp", Colors.orangeAccent)),
      ],
    );
  }

  Widget _buildMiniVitalCard(IconData icon, String value, String unit, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textDark, letterSpacing: -0.5)),
          Text(unit, style: const TextStyle(fontSize: 11, color: textLight, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: textLight, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMedicationProgressCard() {
    final progress = _totalMeds > 0 ? _completedMeds / _totalMeds : 0.0;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: primary.withOpacity(0.2), blurRadius: 25, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Care Progress", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Lexend")),
                  Text("Today's wellness adherence", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.medication_rounded, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Text("${(progress * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$_completedMeds of $_totalMeds requirements met", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    if (_recentLogs.isEmpty) {
      return Container(
        height: 130,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(32), border: Border.all(color: primary.withOpacity(0.02))),
        child: const Text("No care updates right now", style: TextStyle(color: textLight, fontWeight: FontWeight.w600)),
      );
    }
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: _recentLogs.take(2).map((log) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: primary.withOpacity(0.05), shape: BoxShape.circle),
                  child: const Icon(Icons.history_toggle_off_rounded, color: primary, size: 18),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(log['title'] ?? "Care Activity", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark)),
                      const SizedBox(height: 5),
                      Text(
                        log['description'] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: textLight, height: 1.6, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPeaceOfMindCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: textDark,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.security_rounded, color: accent, size: 28),
          ),
          const SizedBox(width: 22),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Peace of Mind", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, fontFamily: "Lexend", letterSpacing: 0.2)),
                SizedBox(height: 4),
                Text("Your loved one is in professional care", style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 110,
      padding: const EdgeInsets.only(bottom: 35, left: 24, right: 24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
        boxShadow: [
          BoxShadow(color: primary.withOpacity(0.08), blurRadius: 50, offset: const Offset(0, -15)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.home_rounded, "Home"),
          _buildNavItem(1, Icons.favorite_rounded, "Health"),
          _buildNavItem(2, Icons.event_note_rounded, "Planner"),
          _buildNavItem(3, Icons.person_rounded, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuint,
            padding: EdgeInsets.symmetric(horizontal: isActive ? 20 : 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? primary.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: isActive ? primary : textLight.withOpacity(0.35), size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: isActive ? primary : textLight.withOpacity(0.5), fontSize: 11, fontWeight: isActive ? FontWeight.w900 : FontWeight.w700, fontFamily: "Lexend")),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 22),
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, fontFamily: "Lexend")),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
      ),
    );
  }
}