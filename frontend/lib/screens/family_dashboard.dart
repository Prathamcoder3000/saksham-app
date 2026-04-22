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
  static const primary = Color(0xFF004AC6);
  static const primaryContainer = Color(0xFF2563EB);
  static const secondary = Color(0xFF006B5F);
  static const bg = Color(0xFFF6FAFE);

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
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load resident data.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error. Check connection.')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // 🔻 DYNAMIC CONTENT BASED ON NAV
          _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: _currentIndex,
                children: [
                   _resident == null 
                     ? const Center(child: Text("No linked resident found."))
                     : _buildHomeTab(),
                  FamilyVitalsScreen(resident: _resident),
                  const FamilyCalendarScreen(),
                  const FamilySettingsScreen(),
                ],
              ),
          _topBar(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 74, 198, 0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, "Home", 0),
            _navItem(Icons.favorite, "Vitals", 1),
            _navItem(Icons.event_note, "Calendar", 2),
            _navItem(Icons.settings, "Settings", 3),
          ],
        ),
      ),
    );
  }

  // 🏠 HOME TAB (Original Main Content)
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 90, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroCard(),
          const SizedBox(height: 24),

          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Health Snapshot",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lexend")),
              Text("Last updated 10m ago",
                  style: TextStyle(color: primary, fontFamily: "Lexend")),
            ],
          ),
          const SizedBox(height: 16),

          // GRID
          Row(
            children: [
              Expanded(child: _heartCard()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _miniCard(Icons.bedtime, "Sleep", "7h 45m"),
                    const SizedBox(height: 12),
                    _miniCard(Icons.directions_walk, "Activity", "2,410 steps"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _medicationCard(),
          const SizedBox(height: 20),

          // TIMELINE HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Recent Moments",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lexend")),
              Text("View Timeline",
                  style: TextStyle(color: primary, fontFamily: "Lexend")),
            ],
          ),
          const SizedBox(height: 12),

          _timeline(),
          const SizedBox(height: 20),

          _caretakerCard(),
        ],
      ),
    );
  }

  // 🔝 TOP BAR
  Widget _topBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.06),
            blurRadius: 20,
          )
        ],
      ),
      child: Row(
        children: const [
          Text(
            "Saksham",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
                fontFamily: "Lexend"),
          ),
        ],
      ),
    );
  }

  // 🔥 HERO
  Widget _heroCard() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage(
              "https://images.unsplash.com/photo-1501785888041-af3ef285b470"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.85),
              Colors.blue.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 4, backgroundColor: Colors.green),
                      SizedBox(width: 6),
                      Text("ACTIVE NOW",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontFamily: "Lexend")),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://i.pravatar.cc/150",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _resident!.name.replaceAll(' ', '\n'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lexend"),
                      ),
                      Text(
                        "Room ${_resident!.room}",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: "Lexend"),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ❤️ HEART
  Widget _heartCard() {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.favorite, color: Colors.red),
          const SizedBox(height: 10),
          const Text(
            "Heart Rate",
            style: TextStyle(fontSize: 13, fontFamily: "Lexend"),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "72",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lexend",
                ),
              ),
              SizedBox(width: 4),
              Text(
                "bpm",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: "Lexend",
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.show_chart, size: 14, color: Color(0xFF006B5F)),
              SizedBox(width: 4),
              Text(
                "Stable",
                style: TextStyle(
                  color: Color(0xFF006B5F),
                  fontSize: 12,
                  fontFamily: "Lexend",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // MINI CARDS
  Widget _miniCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Lexend",
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "Lexend",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 💊 MEDICATION
  Widget _medicationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medication",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Lexend",
                    ),
                  ),
                  Text(
                    "Daily adherence goal",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: "Lexend",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "$_completedMeds / $_totalMeds",
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lexend",
                    ),
                  ),
                  Text(
                    "doses completed",
                    style: TextStyle(fontFamily: "Lexend"),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: _totalMeds > 0 ? _completedMeds / _totalMeds : 0,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const Icon(Icons.medication, color: Color(0xFF2563EB)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _bar(true),
              const SizedBox(width: 6),
              _bar(true),
              const SizedBox(width: 6),
              _bar(true),
              const SizedBox(width: 6),
              _bar(false),
            ],
          )
        ],
      ),
    );
  }

  Widget _bar(bool active) {
    return Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2563EB) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // 🕒 TIMELINE
  Widget _timeline() {
    if (_recentLogs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
        child: const Center(child: Text("No recent moments logged yet.")),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: _recentLogs.map((log) {
          final timeStr = log['timestamp'] != null 
              ? log['timestamp'].toString().substring(11, 16) 
              : '--:--';
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: log['type'] == 'medication' ? Colors.green : const Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 40,
                      color: const Color(0xFFE5E7EB),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeStr,
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: "Lexend"),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log['title'] ?? "Care Activity",
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, fontFamily: "Lexend"),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log['description'] ?? "",
                        style: const TextStyle(fontSize: 13, color: Colors.black87, fontFamily: "Lexend"),
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

  // 👩‍⚕️ CARETAKER
  Widget _caretakerCard() {
    final ctId = _resident?.assignedCaretaker;
    final ctName = "Facility Staff"; // Since we only have the ID, use default name
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF006B5F)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                "https://i.pravatar.cc/150?u=${ctId ?? 'default'}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: "Lexend",
                  ),
                ),
                const Text(
                  "Assigned Caretaker",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: "Lexend",
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (ctId == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    recipientId: ctId,
                    recipientName: ctName,
                    conversationId: "conv_${_resident!.id}_family", 
                  ),
                ),
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? primary : Colors.grey,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? primary : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontFamily: "Lexend",
              ),
            ),
          ],
        ),
      ),
    );
  }
}