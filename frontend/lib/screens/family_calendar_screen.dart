import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class FamilyCalendarScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const FamilyCalendarScreen({super.key, this.onBack});

  @override
  State<FamilyCalendarScreen> createState() => _FamilyCalendarScreenState();
}

class _FamilyCalendarScreenState extends State<FamilyCalendarScreen> {
  static const primary = Color(0xFF4E59A8);
  static const accent = Color(0xFF9FA8DA);
  static const textDark = Color(0xFF1E293B);
  static const textLight = Color(0xFF64748B);

  bool _isLoading = true;
  List<dynamic> _appointments = [];
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final res = await ApiService.get('/appointments');
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            _appointments = jsonDecode(res.body)['data'];
          });
        }
      }
    } catch (e) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F9),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: primary, strokeWidth: 2))
        : CustomScrollView(
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
                      _buildDateSelector(),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM dd').format(DateTime.now().add(Duration(days: _selectedDayIndex))),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textDark, fontFamily: "Lexend", letterSpacing: -0.5),
                          ),
                          const Icon(Icons.calendar_today_rounded, color: textLight, size: 20),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_appointments.isEmpty)
                        _buildEmptyState()
                      else
                        ..._appointments.map((app) {
                          DateTime d = DateTime.now();
                          if (app['date'] != null) d = DateTime.parse(app['date']);
                          final timeStr = DateFormat('hh:mm a').format(d);
                          return _buildEventItem(
                            time: timeStr,
                            title: app['title'] ?? 'Care Session',
                            type: app['type'] ?? 'General Care',
                            status: app['status'] ?? 'Scheduled',
                            color: _getEventColor(app['type'] ?? 'Medical'),
                          );
                        }).toList(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: const Color(0xFFF3F4F9),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 16),
        ),
        onPressed: widget.onBack,
      ),
      title: const Text(
        "Care Planner",
        style: TextStyle(color: textDark, fontWeight: FontWeight.w800, fontSize: 18, fontFamily: "Lexend"),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: List.generate(5, (index) {
        final date = DateTime.now().add(Duration(days: index));
        final dayStr = DateFormat('EEE').format(date);
        final dateStr = DateFormat('dd').format(date);
        final isActive = _selectedDayIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isActive ? primary : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: isActive 
                  ? [BoxShadow(color: primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]
                  : [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text(
                    dayStr,
                    style: TextStyle(
                      color: isActive ? Colors.white70 : textLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Lexend",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isActive ? Colors.white : textDark,
                      fontFamily: "Lexend",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEventItem({
    required String time,
    required String title,
    required String type,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                Text(time.split(" ")[0], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: textDark)),
                Text(time.split(" ")[1], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textLight)),
              ],
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: textDark, fontFamily: "Lexend")),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(type, style: const TextStyle(color: textLight, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), shape: BoxShape.circle),
            child: Icon(Icons.spa_rounded, size: 48, color: primary.withOpacity(0.2)),
          ),
          const SizedBox(height: 28),
          const Text("A Peaceful Day", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: textDark, fontFamily: "Lexend")),
          const SizedBox(height: 10),
          const Text(
            "No special appointments or visits scheduled for today. Your loved one is following their regular wellness routine.",
            textAlign: TextAlign.center,
            style: TextStyle(color: textLight, fontSize: 14, height: 1.6, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'medical': return Colors.blueAccent;
      case 'therapy': return Colors.purpleAccent;
      case 'visit': return Colors.orangeAccent;
      default: return Colors.teal;
    }
  }
}
