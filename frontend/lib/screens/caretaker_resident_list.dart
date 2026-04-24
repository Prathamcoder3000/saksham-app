import 'package:flutter/material.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import 'resident_profile.dart';
import 'caretaker_resident_profile.dart';
import 'caretaker_add_resident.dart';
import 'caretaker_dashboard.dart';

class CaretakerResidentListScreen extends StatefulWidget {
  final bool isTab;
  const CaretakerResidentListScreen({super.key, this.isTab = false});

  @override
  State<CaretakerResidentListScreen> createState() =>
      _CaretakerResidentListScreenState();
}

class _CaretakerResidentListScreenState
    extends State<CaretakerResidentListScreen> {

  String selectedFilter = "all";
  List<dynamic> residents = [];
  List<dynamic> filteredResidents = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchResidents();
  }

  Future<void> _fetchResidents() async {
    try {
      final response = await ApiService.get('/residents');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (mounted) {
          setState(() {
            residents = data;
            filteredResidents = data;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearch(String query) {
    setState(() {
      filteredResidents = residents
          .where((r) => r['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _applyStatusFilter(String status) {
    setState(() {
      selectedFilter = status;
      if (status == "all") {
        filteredResidents = residents;
      } else {
        filteredResidents = residents.where((r) => r['status'].toString().toLowerCase() == status.toLowerCase()).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = SafeArea(
      child: Column(
        children: [
          // 🔝 HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (!widget.isTab) ...[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blue, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Residents",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        "Keep track of everyone in your care",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final newResident = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CaretakerAddResidentScreen(),
                      ),
                    );

                    if (newResident != null) {
                      _fetchResidents();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                  ),
                )
              ],
            ),
          ),

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search_rounded, color: Colors.blue, size: 22),
                  hintText: "Search residents...",
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🏷️ FILTERS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _chip("all", "All"),
                const SizedBox(width: 10),
                _chip("stable", "Stable"),
                const SizedBox(width: 10),
                _chip("monitoring", "Monitoring"),
                const SizedBox(width: 10),
                _chip("critical", "Critical"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 📋 LIST
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: filteredResidents.length,
                    itemBuilder: (context, index) {
                      final r = filteredResidents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaretakerResidentProfileScreen(data: {
                                "id": r["_id"].toString(),
                                "name": r["name"].toString(),
                                "room": r["room"].toString(),
                                "age": r["age"].toString(),
                                "condition": r["condition"].toString(),
                                "status": r["status"].toString(),
                                "emergencyContactName": r["emergencyContactName"] ?? "",
                                "emergencyContactPhone": r["emergencyContactPhone"] ?? "",
                              }),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ],
                            border: Border.all(color: Colors.black.withOpacity(0.01)),
                          ),
                          child: Row(
                            children: [
                              // 👤 AVATAR
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: Icon(Icons.person_rounded, color: Colors.blue, size: 30),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // DETAILS
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r["name"].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.meeting_room_rounded, size: 14, color: Color(0xFF94A3B8)),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Room ${r["room"]}",
                                          style: const TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // STATUS BADGE
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _statusColor(r["status"].toString().toLowerCase()).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      r["status"].toString().toUpperCase(),
                                      style: TextStyle(
                                        color: _statusColor(r["status"].toString().toLowerCase()),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFCBD5E1), size: 14),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );

    if (widget.isTab) return body;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: body,
    );
  }

  // 🔘 CHIP
  Widget _chip(String value, String label) {
    bool selected = selectedFilter == value;

    return GestureDetector(
      onTap: () => _applyStatusFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.blue.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? Colors.blue : Colors.blue.withOpacity(0.1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.blue,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "critical":
        return Colors.red;
      case "monitoring":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}