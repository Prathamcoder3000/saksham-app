import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:saksham/models/medicine_model.dart';
import 'package:saksham/models/resident_model.dart';
import 'package:saksham/services/api_service.dart';
import 'caretaker_dashboard.dart';
import 'emergency_sos.dart';

class MedicineTrackerScreen extends StatefulWidget {
  final bool isTab;
  const MedicineTrackerScreen({super.key, this.isTab = false});

  @override
  State<MedicineTrackerScreen> createState() =>
      _MedicineTrackerScreenState();
}

class _MedicineTrackerScreenState extends State<MedicineTrackerScreen> {
  bool _isLoading = true;
  List<MedicineModel> medicines = [];
  List<ResidentModel> residents = [];
  ResidentModel? selectedResident;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    try {
      final response = await ApiService.get('/medicines/today');
      final resResponse = await ApiService.get('/residents');

      if (response.statusCode == 200 && resResponse.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final List<dynamic> resData = jsonDecode(resResponse.body)['data'];
        
        setState(() {
          medicines = data.map((json) => MedicineModel.fromJson(json)).toList();
          residents = resData.map((json) => ResidentModel.fromJson(json)).toList();
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

  Map<String, List<MedicineModel>> get groupedMedicines {
    final Map<String, List<MedicineModel>> groups = {};
    for (var m in medicines) {
      final key = "${m.residentName} (${m.residentRoom})";
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(m);
    }
    return groups;
  }

  Future<void> toggleStatus(MedicineModel med) async {
    final newStatus = (med.status == 'taken' || med.status == 'missed') ? 'pending' : 'taken';
    
    try {
      final response = await ApiService.patch('/medicines/${med.id}/status', {
        'status': newStatus
      });
      
      if (response.statusCode == 200) {
        _fetchMedicines(); 
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update status')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error. Check connection.')));
    }
  }

  String get _liveDate {
    final now = DateTime.now();
    // Use manual formatting for now since app_localizations might not have full date patterns
    return "${now.day}/${now.month}/${now.year}";
  }

  void openAddMedicineSheet() {
    TextEditingController nameController = TextEditingController();
    TextEditingController doseController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add Medicine",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<ResidentModel>(
                    value: selectedResident,
                    items: residents.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text("${r.name} (${r.room})"),
                    )).toList(),
                    onChanged: (val) {
                      setSheetState(() => selectedResident = val);
                      setState(() => selectedResident = val);
                    },
                    decoration: const InputDecoration(labelText: "Select Resident"),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Medicine Name"),
                  ),
                  TextField(
                    controller: doseController,
                    decoration: const InputDecoration(labelText: "Dose (e.g. 1 pill)"),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(labelText: "Time (e.g. 08:30 AM)"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty || selectedResident == null) return;

                      final residentId = selectedResident!.id.trim();
                      print("Resident ID = $residentId");

                      final response = await ApiService.post('/medicines', {
                        'resident': residentId,
                        'name': nameController.text.trim(),
                        'dosage': doseController.text.trim(),
                        'instructions': 'Taken at ${timeController.text.trim()}',
                        'status': 'pending'
                      });

                      if (response.statusCode == 201) {
                          _fetchMedicines();
                          if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }

  int get taken => medicines.where((m) => m.status == "taken").length;
  int get pending => medicines.where((m) => m.status == "pending" || m.status == "upcoming").length;
  int get missed => medicines.where((m) => m.status == "missed").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 🔝 APP BAR
          _buildHeader(),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
                : RefreshIndicator(
                    color: const Color(0xFF2563EB),
                    onRefresh: _fetchMedicines,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          
                          // 📊 STATS
                          _buildStatsOverview(),

                          const SizedBox(height: 32),

                          // 🕒 SCHEDULE SECTION
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "DAILY WORKFLOW",
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Schedule for Today",
                                    style: TextStyle(
                                      color: const Color(0xFF1E293B),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _liveDate,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          if (medicines.isEmpty)
                            _buildEmptyState()
                          else
                            ...groupedMedicines.entries.map((entry) => _buildResidentGroup(entry.key, entry.value)).toList(),

                          const SizedBox(height: 24),

                          // ➕ ADD ACTION
                          _buildAddActionCard(),

                          const SizedBox(height: 32),

                          // 💡 QUICK INSIGHTS
                          _buildQuickInsights(),

                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 55, bottom: 20, left: 18, right: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 25,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          if (!widget.isTab) ...[
            GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CaretakerDashboard()));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 16),
              ),
            ),
            const SizedBox(width: 16),
          ],
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Medicine Tracker",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.8,
                ),
              ),
              Text(
                "Safe & Efficient Care Management",
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencySOSScreen())),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: const Icon(Icons.emergency_rounded, color: Color(0xFFEF4444), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 12),
          )
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("$taken", "Taken", const Color(0xFF10B981), Icons.check_circle_rounded),
          _divider(),
          _statItem("$pending", "Pending", const Color(0xFFF59E0B), Icons.watch_later_rounded),
          _divider(),
          _statItem("$missed", "Missed", const Color(0xFFEF4444), Icons.error_rounded),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 40, width: 1.5, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(1)));

  Widget _statItem(String count, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.06), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          count,
          style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -1),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildResidentGroup(String name, List<MedicineModel> meds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 16, left: 6),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF475569),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        ...meds.map((m) {
          if (m.status == "pending" || m.status == "upcoming") return _pendingCard(m);
          if (m.status == "missed") return _missedCard(m);
          return _normalCard(m);
        }).toList(),
      ],
    );
  }

  Widget _buildAddActionCard() {
    return InkWell(
      onTap: openAddMedicineSheet,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.blue.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            const Text(
              "Add New Prescription",
              style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2563EB), fontSize: 17, letterSpacing: -0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInsights() {
    final nextMed = medicines.where((m) => m.status == 'pending' || m.status == 'upcoming').firstOrNull;
    final recentMed = medicines.where((m) => m.status == 'taken').lastOrNull;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              const Text(
                "SHIFT INTELLIGENCE",
                style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _insightRow(
            Icons.next_plan_rounded, 
            "Next Dose", 
            nextMed != null ? "${nextMed.name} - ${nextMed.instructions.split('at').last.trim()}" : "All completed!",
            Colors.blue.shade300
          ),
          _insightDivider(),
          _insightRow(
            Icons.history_rounded, 
            "Recent Activity", 
            recentMed != null ? "Gave ${recentMed.name} to ${recentMed.residentName}" : "No actions recorded",
            Colors.green.shade300
          ),
          _insightDivider(),
          _insightRow(
            Icons.analytics_rounded, 
            "Completion Rate", 
            medicines.isEmpty ? "0%" : "${(taken / medicines.length * 100).toInt()}% of today's plan",
            Colors.purple.shade300
          ),
        ],
      ),
    );
  }

  Widget _insightDivider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 36),
  );

  Widget _insightRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), shape: BoxShape.circle),
            child: Icon(Icons.medication_rounded, size: 48, color: Colors.blue.withOpacity(0.2)),
          ),
          const SizedBox(height: 20),
          const Text(
            "Safe Workspace",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            "No medications scheduled currently",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 90,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navBtn(Icons.dashboard_rounded, "Home", false),
          _navBtn(Icons.people_alt_rounded, "Residents", false),
          _navBtn(Icons.assignment_ind_rounded, "Care", true),
          _navBtn(Icons.account_circle_rounded, "Profile", false),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, String label, bool active) {
    return GestureDetector(
      onTap: () {
        if (active) return;
        int idx = 0;
        if (label == "Residents") idx = 1;
        if (label == "Care") idx = 2;
        if (label == "Profile") idx = 3;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => CaretakerDashboard(initialIndex: idx)), (r) => false);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              color: active ? const Color(0xFF2563EB) : const Color(0xFF94A3B8), 
              size: 26
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w900 : FontWeight.w600,
                color: active ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _normalCard(MedicineModel m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.done_all_rounded, color: Color(0xFF10B981), size: 18),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1E293B), letterSpacing: -0.5)),
                Text(m.dosage, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                child: const Text("TAKEN", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF10B981), letterSpacing: 0.5)),
              ),
              const SizedBox(height: 4),
              Text(m.instructions.split('at').last.trim(), style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pendingCard(MedicineModel m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.blue.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.03),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.medication_rounded, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E293B), letterSpacing: -0.8)),
                    Text(m.dosage, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("DUE AT", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                  Text(
                    m.instructions.split('at').last.trim(),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B), letterSpacing: -0.5),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => toggleStatus(m),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    "Confirm Medication", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: -0.3)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _missedCard(MedicineModel m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.priority_high_rounded, color: Color(0xFFEF4444), size: 18),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF991B1B), letterSpacing: -0.5)),
                const Text("UNSCHEDULED / MISSED", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFEF4444), letterSpacing: 0.5)),
              ],
            ),
          ),
          Text(
            m.instructions.split('at').last.trim(), 
            style: const TextStyle(fontSize: 14, color: Color(0xFFB91C1C), fontWeight: FontWeight.w900)
          ),
        ],
      ),
    );
  }
}