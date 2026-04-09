import 'dart:ui';
import 'package:flutter/material.dart';

class MedicineTrackerScreen extends StatefulWidget {
  const MedicineTrackerScreen({super.key});

  @override
  State<MedicineTrackerScreen> createState() =>
      _MedicineTrackerScreenState();
}

class _MedicineTrackerScreenState extends State<MedicineTrackerScreen> {

  List<Map<String, dynamic>> medicines = [
    {
      "name": "Lisinopril",
      "desc": "10mg — Before Breakfast",
      "time": "08:00 AM",
      "status": "taken"
    },
    {
      "name": "Donepezil",
      "desc": "5mg — After Lunch",
      "time": "12:30 PM",
      "status": "pending"
    },
    {
      "name": "Vitamin D3",
      "desc": "1000 IU — Once Daily",
      "time": "06:00 PM",
      "status": "upcoming"
    },
    {
      "name": "Aspirin",
      "desc": "81mg — Blood Thinner",
      "time": "07:00 AM",
      "status": "missed"
    },
  ];

  void markAsTaken(int index) {
    setState(() {
      medicines[index]["status"] = "taken";
    });
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

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Medicine Name"),
            ),

            TextField(
              controller: doseController,
              decoration: const InputDecoration(labelText: "Dose"),
            ),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: "Time"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) return;

                setState(() {
                  medicines.add({
                    "name": nameController.text,
                    "desc": doseController.text,
                    "time": timeController.text,
                    "status": "pending"
                  });
                });

                Navigator.pop(context);
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
      medicines.where((m) => m["status"] == "taken").length;

  int get pending =>
      medicines.where((m) => m["status"] == "pending").length;

  int get missed =>
      medicines.where((m) => m["status"] == "missed").length;

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
                const Text("TODAY", style: TextStyle(color: Colors.grey)),
                const Text("Monday, 24 Oct",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

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
                  child: ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {

                      final m = medicines[index];

                      if (m["status"] == "pending") {
                        return _pendingCard(m, index);
                      } else if (m["status"] == "missed") {
                        return _missedCard(m);
                      } else {
                        return _normalCard(m);
                      }
                    },
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

          // 🔻 NAV
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nav(Icons.home, "Home", false),
                  _nav(Icons.favorite, "Vitals", false),
                  _nav(Icons.medical_services, "Care", true),
                  _nav(Icons.person, "Profile", false),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Emergency Triggered")));
        },
        child: const Icon(Icons.emergency),
      ),
    );
  }

  // 🔹 NORMAL CARD
  Widget _normalCard(Map m) {
    return Container(
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
            Text(m["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(m["desc"]),
          ]),
          Column(
            children: [
              Text(m["status"].toUpperCase()),
              Text(m["time"]),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 PENDING CARD
  Widget _pendingCard(Map m, int index) {
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
              Text(m["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(m["time"], style: const TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => markAsTaken(index),
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
  Widget _missedCard(Map m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(m["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(m["desc"]),
          const SizedBox(height: 6),
          Text("Missed at ${m["time"]}",
              style: const TextStyle(color: Colors.red)),
          const Text("⚠ Alert: Dose missed",
              style: TextStyle(color: Colors.red)),
        ],
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

// 🔹 NAV
class _nav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _nav(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: active ? Colors.blue : Colors.grey),
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: active ? Colors.blue : Colors.grey)),
      ],
    );
  }
}