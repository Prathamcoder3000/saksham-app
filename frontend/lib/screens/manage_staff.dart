import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import 'add_staff_screen.dart';
import 'edit_staff_screen.dart';
import 'resident_list.dart';
import 'reports_screen.dart';

class ManageStaffScreen extends StatefulWidget {
  final bool isTab;
  const ManageStaffScreen({super.key, this.isTab = false});

  @override
  State<ManageStaffScreen> createState() => _ManageStaffScreenState();
}

class _ManageStaffScreenState extends State<ManageStaffScreen> {
  bool _isLoading = true;
  List<dynamic> _staffList = [];
  Map<String, dynamic> _stats = {
    'total': 0,
    'active': 0,
    'onLeave': 0,
    'newApplications': 0
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _confirmDelete(BuildContext context, String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to permanently remove $name from the staff directory?'),
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
      _deleteStaff(id);
    }
  }

  Future<void> _fetchData() async {
    try {
      final staffRes = await ApiService.get('/staff');
      final usersRes = await ApiService.get('/users');
      final statsRes = await ApiService.get('/staff/stats');

      if (staffRes.statusCode == 200 && usersRes.statusCode == 200) {
        final List<dynamic> staffData = jsonDecode(staffRes.body)['data'];
        final List<dynamic> usersData = jsonDecode(usersRes.body)['data'];
        
        // Create a map of staff by user ID for quick lookup
        final Map<String, dynamic> staffMap = {
          for (var item in staffData) 
            if (item['user'] != null) (item['user']['_id'] ?? item['user']['id']): item
        };

        // Filter and map users (Admin, Caretaker)
        final List<dynamic> combinedList = [];
        for (var user in usersData) {
          if (user['role'] == 'Admin' || user['role'] == 'Caretaker') {
            final userId = user['_id'] ?? user['id'];
            final staffRecord = staffMap[userId];
            
            combinedList.add({
              '_id': staffRecord?['_id'] ?? userId,
              'userId': userId,
              'user': user,
              'designation': staffRecord?['designation'] ?? user['role'],
              'shift': staffRecord?['shift'] ?? 'Day',
              'status': staffRecord?['status'] ?? 'Active',
              'isMinimal': staffRecord == null, // Marker for users without full staff record
            });
          }
        }

        setState(() {
          _staffList = combinedList;
          if (statsRes.statusCode == 200) {
            _stats = jsonDecode(statsRes.body)['data'];
            // Overwrite total count with our combined list length if backend misses some
            _stats['total'] = combinedList.length;
            _stats['active'] = combinedList.where((s) => s['status'] == 'Active').length;
          }
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

  Future<void> _deleteStaff(String id) async {
    setState(() => _isLoading = true);
    try {
      // 🛡️ Use the robust user deletion endpoint which handles staff cleanup too
      final res = await ApiService.delete('/users/$id');
      
      if (res.statusCode == 200) {
        await _fetchData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Staff record and access removed successfully'), 
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            )
          );
        }
      } else {
        final data = jsonDecode(res.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to delete staff'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            )
          );
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection error during deletion'),
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    Widget mainBody = Stack(
        children: [

          // 🔝 GLASS APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  color: Colors.white.withOpacity(0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (!widget.isTab)
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
                          ),
                          if (!widget.isTab) const SizedBox(width: 10),
                          const Text(
                            "Staff Management",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 BODY
          Padding(
            padding: EdgeInsets.fromLTRB(20, 110, 20, widget.isTab ? 20 : 100),
            child: RefreshIndicator(
              onRefresh: _fetchData,
              color: const Color(0xFF004AC6),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                children: [

                  // 📊 STATS (WITH BACKGROUND ICONS)
                   Row(
                    children: [
                      Expanded(child: _stat("Active Staff", "${_stats['active']}", false, Icons.group)),
                      const SizedBox(width: 10),
                      Expanded(child: _stat("On Leave", "${_stats['onLeave']}", false, Icons.event_busy)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _stat("New Applications", "${_stats['newApplications']}", true, Icons.person_add),

                  const SizedBox(height: 25),

                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Staff Directory",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEFF3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.filter_list, size: 16),
                            SizedBox(width: 5),
                            Text("Filter"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  ..._staffList.map((s) {
                    final color = s['status'] == 'Active' ? Colors.green : Colors.grey;
                    return _staff(
                        s['userId'] ?? '',
                        s['user'] != null ? s['user']['name'] : 'Unknown',
                        s['designation'] ?? 'Staff',
                        s['shift'] ?? 'Day',
                        color,
                        s,
                    );
                  }).toList(),
                  
                  if (_staffList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text("No staff members found.")),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (widget.isTab) return mainBody;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: mainBody,

      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Builder(
          builder: (ctx) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navBtnMs(ctx, Icons.dashboard, "Dashboard", false),
              _navBtnMs(ctx, Icons.group, "Staff", true),
              _navBtnMs(ctx, Icons.people, "Residents", false),
              _navBtnMs(ctx, Icons.analytics, "Reports", false),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2563EB),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStaffScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _navBtnMs(BuildContext context, IconData icon, String label, bool active) {
  return GestureDetector(
    onTap: () {
      if (active) return;
      
      if (label == "Dashboard") {
        Navigator.popUntil(context, (route) => route.isFirst);
      } else if (label == "Staff") {
        // Already here
      } else if (label == "Residents") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResidentListScreen()));
      } else if (label == "Reports") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportsScreen()));
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


Widget _stat(String title, String value, bool primary, IconData icon) {
  return Container(
    height: 100,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: primary ? const Color(0xFF2563EB) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
      ],
    ),
    child: Stack(
      children: [

        // TEXT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: primary ? Colors.white70 : Colors.grey)),
            const SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primary ? Colors.white : Colors.black)),
          ],
        ),

        // ICON BG
        Positioned(
          right: -10,
          bottom: -10,
          child: Icon(icon,
              size: 80,
              color: primary
                  ? Colors.white.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.08)),
        ),
      ],
    ),
  );
}

//////////////////////////////////////////////////
// 🔹 STAFF CARD (EXACT STYLE)
//////////////////////////////////////////////////
Widget _staff(String id, String name, String role, String shift, Color color, Map<String, dynamic> rawData) {
  return Builder(
    builder: (context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
      ],
    ),
    child: Row(
      children: [

        // IMAGE + STATUS
        Stack(
          children: [
            const CircleAvatar(radius: 28, backgroundColor: Colors.grey),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 14),

        // TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(role, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  shift.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ACTION ICONS
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditStaffScreen(staffData: rawData),
                  ),
                ).then((value) {
                  if (value == true && context.mounted) {
                    final state = context.findAncestorStateOfType<_ManageStaffScreenState>();
                    state?._fetchData();
                  }
                });
              },
              child: const Icon(Icons.edit, size: 18, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                if (auth.user?.role != 'Admin') return const SizedBox.shrink();
                return GestureDetector(
                    onTap: () {
                        final state = context.findAncestorStateOfType<_ManageStaffScreenState>();
                        state?._confirmDelete(context, id, name);
                    },
                    child: const Icon(Icons.delete, size: 18, color: Colors.red)
                );
              },
            ),
          ],
        ),
      ],
    ),
  ),
  );
}
