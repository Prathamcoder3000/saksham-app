import 'package:flutter/material.dart';
import 'package:saksham/models/task_model.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import 'add_task_screen.dart';
class DailyChecklistScreen extends StatefulWidget {
  const DailyChecklistScreen({super.key});

  @override
  State<DailyChecklistScreen> createState() => _DailyChecklistScreenState();
}

class _DailyChecklistScreenState extends State<DailyChecklistScreen> {
  bool _isLoading = true;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await ApiService.get('/tasks');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          tasks = data.map((json) => TaskModel.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> toggleTask(int index) async {
    final task = tasks[index];
    final newStatus = task.status == 'done' ? 'upcoming' : 'done';
    
    try {
        final response = await ApiService.put('/tasks/${task.id}', {
            'status': newStatus
        });
        
        if (response.statusCode == 200) {
            _fetchTasks();
        }
    } catch (e) {
        // Handle error
    }
  }

  int get total => tasks.length;
  int get done => tasks.where((t) => t.status == "done").length;
  int get left => total - done;

  String get _liveDate {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
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
                    onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Text("Daily Checklist",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blue)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 📅 DATE
                    const Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue),
                        SizedBox(width: 6),
                        Text("TODAY'S SCHEDULE",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                    _liveDate,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    // 📊 STATS
                    Row(
                      children: [
                        _stat("$total", "TOTAL", Colors.white),
                        const SizedBox(width: 10),
                        _stat("$done", "DONE", Colors.teal.shade100, isGreen: true),
                        const SizedBox(width: 10),
                        _stat("$left", "LEFT", Colors.grey.shade300),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // 🌅 TASKS LIST
                    _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _fetchTasks,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                _sectionTitle("Today's Tasks", Icons.checklist),
                                ...tasks.asMap().entries.map((entry) => _taskCard(entry.key)).toList(),
                                if (tasks.isEmpty)
                                    const Center(child: Text("No tasks assigned for today.")),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
          _fetchTasks(); // Refresh list after adding
        },
        child: const Icon(Icons.add),
      ),

    );
  }

  // 📊 STAT CARD
  Widget _stat(String value, String label, Color color, {bool isGreen = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isGreen ? Colors.green : Colors.black)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // 🏷 SECTION TITLE
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const Expanded(
          child: Divider(indent: 10),
        )
      ],
    );
  }

  // 📋 TASK CARD
  Widget _taskCard(int index) {
    final task = tasks[index];

    bool isDone = task.status == "done";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: task.status == "progress"
            ? const Border(left: BorderSide(color: Colors.blue, width: 4))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // LEFT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration:
                      isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : Colors.black,
                ),
              ),
              Text(
                "${task.residentName} (${task.residentRoom}) • ${_statusText(task.status)}",
                style: TextStyle(
                  color: task.status == "progress"
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ],
          ),

          // RIGHT BUTTON
          GestureDetector(
            onTap: () => toggleTask(index),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : Colors.transparent,
                border: Border.all(color: Colors.grey),
              ),
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          )
        ],
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case "done":
        return "Completed";
      case "progress":
        return "In Progress";
      default:
        return "Upcoming";
    }
  }
}