import '../services/api_service.dart';
import 'dart:convert';

class ManageStaffScreen extends StatefulWidget {
  const ManageStaffScreen({super.key});

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

  Future<void> _fetchData() async {
    final demoStaff = [
      {
        '_id': 'demo_s1',
        'user': {'name': 'Rahul Sharma (Demo)', 'email': 'rahul@saksham.care'},
        'designation': 'Senior Caretaker',
        'shift': 'Morning',
        'status': 'Active'
      },
      {
        '_id': 'demo_s2',
        'user': {'name': 'Priya Patel (Demo)', 'email': 'priya@saksham.care'},
        'designation': 'Nurse',
        'shift': 'Night',
        'status': 'On Leave'
      }
    ];

    try {
      final staffRes = await ApiService.get('/staff');
      final statsRes = await ApiService.get('/staff/stats');

      if (staffRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(staffRes.body)['data'];
        setState(() {
          _staffList = data.isEmpty ? demoStaff : data;
          if (statsRes.statusCode == 200) {
            _stats = jsonDecode(statsRes.body)['data'];
          }
          _isLoading = false;
        });
      } else {
        setState(() {
            _staffList = demoStaff;
            _isLoading = false;
        });
      }
    } catch (e) {
      setState(() { 
        _staffList = demoStaff;
        _isLoading = false; 
      });
    }
  }

  Future<void> _deleteStaff(String id) async {
    try {
      final res = await ApiService.delete('/staff/$id');
      if (res.statusCode == 200) {
        _fetchData();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff deleted')));
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: Stack(
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
                          GestureDetector(
                            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                            child: const Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
                          ),
                          const SizedBox(width: 10),
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
                         
                          const SizedBox(width: 10),
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
            padding: const EdgeInsets.fromLTRB(20, 110, 20, 100),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 📊 STATS (WITH BACKGROUND ICONS)
                   Row(
                    children: [
                      Expanded(child: _stat("Active Staff", "${_stats['active']}", false, Icons.group)),
                      const SizedBox(width: 10),
                      Expanded(child: _stat("On Shift", "${_stats['active']}", false, Icons.medical_services)),
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
                        s['_id'] ?? '',
                        s['user'] != null ? s['user']['name'] : 'Unknown',
                        s['designation'] ?? 'Staff',
                        s['shift'] ?? 'Day',
                        color
                    );
                  }).toList(),
                  
                  if (_staffList.isEmpty)
                    const Center(child: Text("No staff members found.")),
                ],
              ),
            ),
          ),

        ],
      ),

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
Widget _staff(String id, String name, String role, String shift, Color color) {
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
            const Icon(Icons.edit, size: 18, color: Colors.blue),
            const SizedBox(height: 8),
            GestureDetector(
                onTap: () {
                    final state = context.findAncestorStateOfType<_ManageStaffScreenState>();
                    state?._deleteStaff(id);
                },
                child: const Icon(Icons.delete, size: 18, color: Colors.red)
            ),
          ],
        )
      ],
    ),
  );
}
