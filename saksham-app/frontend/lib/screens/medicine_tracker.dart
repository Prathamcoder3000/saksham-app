import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saksham/models/medicine_model.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import 'caretaker_dashboard.dart';
import 'emergency_sos.dart';

class MedicineTrackerScreen extends StatefulWidget {
  const MedicineTrackerScreen({super.key});

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
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> toggleStatus(int index) async {
    final med = medicines[index];
    final newStatus = (med.status == 'taken' || med.status == 'missed') ? 'pending' : 'taken';
    
    try {
      final response = await ApiService.put('/medicines/${med.id}', {
        'status': newStatus
      });
      
      if (response.statusCode == 200) {
        _fetchMedicines(); // Refresh list to get updated status and CareLog trigger
      }
    } catch (e) {
      // Handle error
    }
  }

  String get _liveDate {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
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
    builder: (context) {
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
              onChanged: (val) => setState(() => selectedResident = val),
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

                final response = await ApiService.post('/medicines', {
                    'resident': selectedResident!.id,
                    'name': nameController.text,
                    'dosage': doseController.text,
                    'instructions': 'Taken at ${timeController.text}',
                    'status': 'pending'
                });

                if (response.statusCode == 201) {
                    _fetchMedicines();
                    Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            )
          ],
        ),
      );
    },
  );
}

  int get taken =>
      medicines.where((m) => m.status == "taken").length;
 
  int get pending =>
      medicines.where((m) => m.status == "pending" || m.status == "upcoming").length;
 
  int get missed =>
      medicines.where((m) => m.status == "missed").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: Stack(
        children: [

          // 🔝 HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  color: Colors.white.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back, color: Colors.blue),
                          ),
                          const SizedBox(width: 10),
                          const Text("Medicine Tracker",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blue)),
                        ],
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 MAIN
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 110, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // DATE
                const Text("AADHAR-LINKED HEALTH RECORD", style: TextStyle(color: Colors.grey)),
                Text(_liveDate,
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                // 📊 STATS
                Row(
                  children: [
                    Expanded(child: _stat("$taken", "Taken", Colors.green)),
                    const SizedBox(width: 10),
                    Expanded(child: _stat("$pending", "Pending", Colors.orange)),
                    const SizedBox(width: 10),
                    Expanded(child: _stat("$missed", "Missed", Colors.red)),
                  ],
                ),

                const SizedBox(height: 25),

                const Text("SCHEDULE",
                    style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 10),

                // 📋 LIST
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _fetchMedicines,
                        child: ListView.builder(
                          itemCount: medicines.length,
                          itemBuilder: (context, index) {
                            final m = medicines[index];
                            if (m.status == "pending" || m.status == "upcoming") {
                                return _pendingCard(m, index);
                            } else if (m.status == "missed") {
                                return _missedCard(m, index);
                            } else {
                                return _normalCard(m, index);
                            }
                          },
                        ),
                      ),
                ),

                const SizedBox(height: 10),

                // ➕ ADD
                GestureDetector(
                  onTap: openAddMedicineSheet,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text("+ Add Prescription",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
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
            _navBtn(Icons.medical_services, "Care", true),
            _navBtn(Icons.person, "Profile", false),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencySOSScreen()));
        },
        child: const Icon(Icons.emergency),
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

  // 🔹 NORMAL CARD
  Widget _normalCard(MedicineModel m, int index) {
    return GestureDetector(
      onTap: () => toggleStatus(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(m.instructions),
            ]),
            Column(
              children: [
                Text(m.status.toUpperCase()),
                Text(m.dosage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 PENDING CARD
  Widget _pendingCard(MedicineModel m, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(m.dosage, style: const TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => toggleStatus(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.teal],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text("✔ Mark as Taken",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 🔹 MISSED CARD
  Widget _missedCard(MedicineModel m, int index) {
    return GestureDetector(
      onTap: () => toggleStatus(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(m.instructions),
            const SizedBox(height: 6),
            Text("Missed at ${m.dosage}",
                style: const TextStyle(color: Colors.red)),
            const Text("⚠ Alert: Dose missed",
                style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

// 🔹 STAT
class _stat extends StatelessWidget {
  final String count, label;
  final Color color;

  const _stat(this.count, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TextStyle(color: color)),
          Text(label),
        ],
      ),
    );
  }
}
