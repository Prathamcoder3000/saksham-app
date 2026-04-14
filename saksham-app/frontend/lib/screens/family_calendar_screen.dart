import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class FamilyCalendarScreen extends StatefulWidget {
  const FamilyCalendarScreen({super.key});

  @override
  State<FamilyCalendarScreen> createState() => _FamilyCalendarScreenState();
}

class _FamilyCalendarScreenState extends State<FamilyCalendarScreen> {
  bool _isLoading = true;
  List<dynamic> _appointments = [];

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
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Schedule & Events",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: "Lexend",
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Upcoming care routines and appointments",
            style: TextStyle(color: Colors.grey, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 24),

          // Date Selector
          Row(
            children: List.generate(4, (index) {
              final date = DateTime.now().add(Duration(days: index));
              final dayStr = DateFormat('EEE').format(date);
              final dateStr = DateFormat('dd').format(date);
              return _dateCard(dayStr, dateStr, index == 0);
            }),
          ),
          const SizedBox(height: 30),

          // Events
          Text(
            DateFormat('EEEE, MMM dd').format(DateTime.now()),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Lexend"),
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_appointments.isEmpty)
             Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text("No upcoming appointments scheduled yet.")),
            ),
          
          if (!_isLoading && _appointments.isNotEmpty)
            ..._appointments.map((app) {
              DateTime d = DateTime.now();
              if (app['date'] != null) {
                  d = DateTime.parse(app['date']);
              }
              final timeStr = DateFormat('hh:mm a').format(d);
              return Column(
                children: [
                  _eventItem(
                    time: timeStr,
                    title: app['title'] ?? 'Appointment',
                    subtitle: app['status'] ?? 'Scheduled',
                    color: Colors.teal,
                    icon: Icons.medical_services,
                  ),
                  const SizedBox(height: 16),
                ]
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _dateCard(String day, String date, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                color: isActive ? Colors.white70 : Colors.grey,
                fontFamily: "Lexend",
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.black87,
                fontFamily: "Lexend",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventItem({
    required String time,
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time.split(" ")[0],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Lexend"),
                ),
                Text(
                  time.split(" ").length > 1 ? time.split(" ")[1] : "",
                  style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: "Lexend"),
                ),
              ],
            ),
          ),
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Lexend"),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: "Lexend"),
                ),
              ],
            ),
          ),
          Icon(icon, color: color),
        ],
      ),
    );
  }
}

