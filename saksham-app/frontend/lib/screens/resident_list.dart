import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:saksham/models/resident_model.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import 'add_resident.dart';
import 'resident_profile.dart';
import 'manage_staff.dart';
import 'reports_screen.dart';

class ResidentListScreen extends StatefulWidget {
  const ResidentListScreen({super.key});

  @override
  State<ResidentListScreen> createState() => _ResidentListScreenState();
}

class _ResidentListScreenState extends State<ResidentListScreen> {

  String selectedFilter = "All";
  String searchQuery = "";
  bool _isLoading = true;
  List<ResidentModel> _residents = [];

  @override
  void initState() {
    super.initState();
    _fetchResidents();
  }

  Future<void> _fetchResidents() async {
    try {
      final response = await ApiService.get('/residents');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          _residents = data.map((json) => ResidentModel.fromJson(json)).toList();
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

  List<ResidentModel> get filteredResidents {
    return _residents.where((r) {
      // For status, our model doesn't have a direct "status" field, 
      // but we can mock it or use health conditions. 
      // For simplicity, let's assume "Stable" for all for now, 
      // or filter by name.
      final matchesSearch = searchQuery.isEmpty ||
          r.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          r.room.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  Future<void> _confirmDelete(BuildContext context, String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to permanently remove $name and all their care records?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteResident(id);
    }
  }

  Future<void> _deleteResident(String id) async {
    try {
      final response = await ApiService.delete('/residents/$id');
      if (response.statusCode == 200) {
        _fetchResidents();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resident deleted successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete resident')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: Stack(
        children: [

          // 🔝 GLASS APP BAR
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 90,
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                color: Colors.white.withOpacity(0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Residents",
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.search, color: Color(0xFF2563EB)),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 MAIN CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
            child: Column(
              children: [

                // 🔍 SEARCH
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEFF3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => searchQuery = val),
                          decoration: const InputDecoration(
                            hintText: "Search by name or room number...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔘 SCROLLABLE CHIPS
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _chip("All"),
                      _chip("Stable"),
                      _chip("Critical"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📋 LIST
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _fetchResidents,
                        child: ListView.builder(
                          itemCount: filteredResidents.length,
                          itemBuilder: (context, index) {
                            final r = filteredResidents[index];
                            return ResidentCard(
                              id: r.id,
                              name: r.name,
                              room: r.room,
                              status: "Stable", // Default
                              statusColor: const Color(0xFF10B981),
                              onDelete: () => _confirmDelete(context, r.id, r.name),
                            );
                          },
                        ),
                      ),
                ),
              ],
            ),
          ),

          // ➕ FAB (GRADIENT + SHADOW)
          Positioned(
            bottom: 90,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 20,
                  )
                ],
              ),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddResidentScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),

          // 🔻 FLOATING NAV BAR
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItemBtn(context, Icons.dashboard, "Dashboard", false),
                  _navItemBtn(context, Icons.group, "Staff", false),
                  _navItemBtn(context, Icons.people, "Residents", true),
                  _navItemBtn(context, Icons.analytics, "Reports", false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    bool selected = selectedFilter == text;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class ResidentCard extends StatelessWidget {
  final String id;
  final String name;
  final String room;
  final String status;
  final Color statusColor;
  final VoidCallback onDelete;

  const ResidentCard({
    super.key,
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.statusColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResidentProfileScreen(residentId: id),
      ),
    );
  },
  child: Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.05),
          blurRadius: 15,
        )
      ],
    ),
    child: Row(
      children: [

        Stack(
          children: [
            const CircleAvatar(radius: 26),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            )
          ],
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.meeting_room, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    room,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),

         Consumer<AuthProvider>(
           builder: (context, auth, child) {
             if (auth.user?.role != 'Admin') return const SizedBox.shrink();
             return GestureDetector(
               onTap: onDelete,
               child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
             );
           },
         ),
         const SizedBox(height: 8),
         const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    ),
  ),
);
  }
}

Widget _navItemBtn(BuildContext context, IconData icon, String label, bool active) {
  return GestureDetector(
    onTap: () {
      if (active) return;
      
      if (label == "Dashboard") {
        Navigator.popUntil(context, (route) => route.isFirst);
      } else if (label == "Staff") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManageStaffScreen()));
      } else if (label == "Residents") {
        // Already here
      } else if (label == "Reports") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
      }
    },
    child: Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Icon(icon, color: active ? const Color(0xFF2563EB) : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? const Color(0xFF2563EB) : Colors.grey,
            ),
          )
        ],
      ),
    ),
  );
}