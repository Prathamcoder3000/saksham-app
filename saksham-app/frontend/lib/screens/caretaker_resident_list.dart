import 'package:flutter/material.dart';
import 'resident_profile.dart';
import 'caretaker_resident_profile.dart';
import 'caretaker_add_resident.dart';
import 'caretaker_dashboard.dart';

class CaretakerResidentListScreen extends StatefulWidget {
  const CaretakerResidentListScreen({super.key});

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
        setState(() {
          residents = data;
          filteredResidents = residents;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = residents;
    } else {
      results = residents
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredResidents = results;
    });
  }

  void _applyStatusFilter(String status) {
    setState(() {
      selectedFilter = status;
      if (status == 'all') {
        filteredResidents = residents;
      } else {
        filteredResidents = residents.where((r) => r['status'].toString().toLowerCase() == status.toLowerCase()).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: SafeArea(
        child: Column(
          children: [

            // 🔝 HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  const Text("Residents",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blue)),
                ],
              ),
            ),

            // 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search residents...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔘 FILTER CHIPS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _chip("all", "All"),
                _chip("stable", "Stable"),
                _chip("critical", "Critical"),
                _chip("monitoring", "Monitoring"),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredResidents.length,
                itemBuilder: (context, index) {

                  final r = filteredResidents[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CaretakerResidentProfileScreen(data: {
                            "id": r["_id"] ?? "",
                            "name": r["name"] ?? "Unknown",
                            "room": r["room"] ?? "N/A",
                            "status": r["status"] ?? "stable",
                            "age": (r["age"] ?? "").toString(),
                            "conditions": (r["conditions"] as List?)?.join(", ") ?? "",
                            "allergies": (r["allergies"] as List?)?.join(", ") ?? "",
                            "emergencyContactName": r["emergencyContactName"] ?? "",
                            "emergencyContactPhone": r["emergencyContactPhone"] ?? "",
                          }),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
                        ]
                      ),
                      child: Row(
                        children: [

                          // 👤 AVATAR
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(Icons.person, color: Colors.blue),
                          ),

                          const SizedBox(width: 14),

                          // DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  r["name"] ?? "Unknown",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    Icon(Icons.circle,
                                        size: 10,
                                        color: _statusColor(r["status"].toString().toLowerCase())),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        r["room"] ?? "No Room",
                                        style: const TextStyle(color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // STATUS BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(r["status"].toString().toLowerCase())
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (r["status"] ?? "stable").toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                color: _statusColor(r["status"].toString().toLowerCase()),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final newResident = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CaretakerAddResidentScreen(),
            ),
          );

          if (newResident != null) {
            setState(() {
              residents.add(newResident);
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navBtn(Icons.home, "Home", false),
            _navBtn(Icons.monitor_heart, "Vitals", false),
            _navBtn(Icons.handshake, "Care", true),
            _navBtn(Icons.person, "Profile", false),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, String label, bool active) {
    return GestureDetector(
      onTap: () {
        if (active) return;
        
        if (label == "Home") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 0)), (r) => false);
        } else if (label == "Vitals") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 1)), (r) => false);
        } else if (label == "Care") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 2)), (r) => false);
        } else if (label == "Profile") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard(initialIndex: 3)), (r) => false);
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? const Color(0xFF004AC6) : Colors.grey),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? const Color(0xFF004AC6) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔘 CHIP
  Widget _chip(String value, String label) {
    bool selected = selectedFilter == value;

    return GestureDetector(
      onTap: () => _applyStatusFilter(value),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: selected ? Colors.white : Colors.black),
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