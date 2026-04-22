import 'package:flutter/material.dart';
import 'package:saksham/models/resident_model.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  TimeOfDay? selectedTime;
  String selectedSection = "morning";
  
  List<ResidentModel> residents = [];
  ResidentModel? selectedResident;
  bool _isLoading = true;

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
          residents = data.map((json) => ResidentModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> saveTask() async {
    if (titleController.text.isEmpty || selectedResident == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter task name and select resident")),
      );
      return;
    }
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a time")),
      );
      return;
    }

    final formattedTime =
        "${selectedTime!.hourOfPeriod.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')} "
        "${selectedTime!.period == DayPeriod.am ? "AM" : "PM"}";

    try {
      final response = await ApiService.post('/tasks', {
        "resident": selectedResident!.id,
        "title": titleController.text,
        "time": formattedTime,
        "status": "pending",
        "section": selectedSection,
      });

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        final error = jsonDecode(response.body)['message'] ?? 'Failed to save task';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error connecting to server")));
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Add Task",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : _inputCard(
                        icon: Icons.person,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ResidentModel>(
                            isExpanded: true,
                            hint: const Text("Select Resident"),
                            value: selectedResident,
                            items: residents.map((r) => DropdownMenuItem(
                              value: r,
                              child: Text("${r.name} (${r.room})"),
                            )).toList(),
                            onChanged: (val) => setState(() => selectedResident = val),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // 🧾 TITLE INPUT
                    _inputCard(
                      icon: Icons.task,
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: "Enter task name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ⏰ TIME PICKER
                    GestureDetector(
                      onTap: pickTime,
                      child: _inputCard(
                        icon: Icons.access_time,
                        child: Text(
                          selectedTime == null
                              ? "Select Time"
                              : "${selectedTime!.format(context)}",
                          style: TextStyle(
                            color: selectedTime == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 📌 SECTION SELECT
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Section",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _chip("morning", Icons.wb_sunny),
                              _chip("afternoon", Icons.wb_sunny_outlined),
                              _chip("night", Icons.nightlight_round),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 💾 SAVE BUTTON
                    GestureDetector(
                      onTap: saveTask,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.teal],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Save Task",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 INPUT CARD
  Widget _inputCard({required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }

  // 🔹 SECTION CHIP
  Widget _chip(String value, IconData icon) {
    bool isSelected = selectedSection == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSection = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 4),
            Text(
              value.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.blue : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}