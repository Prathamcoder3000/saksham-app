import 'package:flutter/material.dart';
import 'add_task_screen.dart';
class DailyChecklistScreen extends StatefulWidget {
  const DailyChecklistScreen({super.key});

  @override
  State<DailyChecklistScreen> createState() => _DailyChecklistScreenState();
}

class _DailyChecklistScreenState extends State<DailyChecklistScreen> {

  List<Map<String, dynamic>> tasks = [
    {
      "title": "Assisted Sponge Bath",
      "time": "08:30 AM",
      "status": "done",
      "section": "morning"
    },
    {
      "title": "Morning Walk (Garden)",
      "time": "07:00 AM",
      "status": "progress",
      "section": "morning"
    },
    {
      "title": "Blood Pressure & Blood Sugar Check",
      "time": "01:00 PM",
      "status": "upcoming",
      "section": "afternoon"
    },
    {
      "title": "Physiotherapy Exercises",
      "time": "05:30 PM",
      "status": "upcoming",
      "section": "night"
    },
  ];

  void toggleTask(int index) {
    setState(() {
      if (tasks[index]["status"] == "done") {
        tasks[index]["status"] = "progress";
      } else {
        tasks[index]["status"] = "done";
      }
    });
  }

  int get total => tasks.length;
  int get done => tasks.where((t) => t["status"] == "done").length;
  int get left => total - done;

  String get _liveDate {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
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
                  const Text("Daily Checklist",
                          style: TextStyle(
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

                    // 🌅 MORNING
                    _sectionTitle("Morning Tasks", Icons.wb_sunny),

                    _taskCard(0),
                    _taskCard(1),

                    const SizedBox(height: 20),

                    // ☀ AFTERNOON
                    _sectionTitle("Afternoon Tasks", Icons.wb_sunny_outlined),

                    _taskCard(2),

                    const SizedBox(height: 20),

                    // 🌙 NIGHT
                    _sectionTitle("Evening & Night", Icons.nightlight_round),

                    _taskCard(3),
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              tasks.add(result);
            });
          }
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

    bool isDone = task["status"] == "done";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: task["status"] == "progress"
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
                task["title"],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration:
                      isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : Colors.black,
                ),
              ),
              Text(
                "${task["time"]} • ${_statusText(task["status"])}",
                style: TextStyle(
                  color: task["status"] == "progress"
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