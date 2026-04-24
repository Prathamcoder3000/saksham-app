import 'package:flutter/material.dart';
import 'package:saksham/models/task_model.dart';
import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import '../extensions/localization_extension.dart';
import 'add_task_screen.dart';
import 'caretaker_dashboard.dart';
class DailyChecklistScreen extends StatefulWidget {
  final bool isTab;
  const DailyChecklistScreen({super.key, this.isTab = false});

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
        if (mounted) {
          setState(() {
            tasks = data.map((json) => TaskModel.fromJson(json)).toList();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load tasks')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error. Check your connection.')));
      }
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
        } else {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to toggle task')));
        }
    } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error. Check connection.')));
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
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.isTab ? null : IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF64748B), size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CaretakerDashboard()),
              );
            }
          },
        ),
        title: Text(
          context.l10n!.daily_checklist,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📅 DATE & PROGRESS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _liveDate.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Today's Routines",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.8,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "$done/$total Done",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),

                    const SizedBox(height: 18),

                    // 📊 STATS CARDS (Elegantly Balanced)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E293B).withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _statItem("$total", "TOTAL", const Color(0xFF2563EB)),
                              _divider(),
                              _statItem("$done", "DONE", const Color(0xFF10B981)),
                              _divider(),
                              _statItem("$left", "LEFT", const Color(0xFF64748B)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              Container(
                                height: 10,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                height: 10,
                                width: (total > 0) ? (MediaQuery.of(context).size.width - 88) * (done / total) : 0,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF2563EB), Color(0xFF10B981)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB).withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 🌅 TASKS SECTION
                    const Text(
                      "ACTIVE TASKS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _isLoading 
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(color: Color(0xFF2563EB), strokeWidth: 2),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchTasks,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tasks.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    child: Column(
                                      children: [
                                        Icon(Icons.assignment_turned_in_outlined, size: 48, color: Colors.grey.withOpacity(0.3)),
                                        const SizedBox(height: 12),
                                        Text(
                                          "All caught up for today!",
                                          style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                ...tasks.asMap().entries.map((entry) => _taskCard(entry.key)).toList(),
                              
                              const SizedBox(height: 12),
                              
                              // ➕ PREMIUM ACTION BUTTON
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddTaskScreen()),
                                  );
                                  _fetchTasks();
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF2563EB).withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      )
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 22),
                                      SizedBox(width: 10),
                                      Text(
                                        "Add New Task",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  // 📊 STAT CARD
  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 35, color: const Color(0xFFF1F5F9));
  }

  // 💎 PREMIUM TASK CARD
  Widget _taskCard(int index) {
    final task = tasks[index];
    bool isDone = task.status == "done";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(isDone ? 0.01 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(
          color: isDone ? const Color(0xFFF1F5F9) : (task.status == "progress" ? const Color(0xFF2563EB).withOpacity(0.1) : Colors.transparent),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // CUSTOM PREMIUM CHECKBOX
          GestureDetector(
            onTap: () => toggleTask(index),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDone 
                  ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                  : null,
                color: isDone ? null : Colors.white,
                border: Border.all(
                  color: isDone ? Colors.transparent : Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: isDone ? [
                  BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                ] : [],
              ),
              child: isDone ? const Icon(Icons.check_rounded, color: Colors.white, size: 18) : null,
            ),
          ),

          const SizedBox(width: 16),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDone 
                          ? const Color(0xFFDCFCE7).withOpacity(0.5) 
                          : (task.status == "progress" ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_outline_rounded, size: 12, color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            task.residentName,
                            style: TextStyle(
                              color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // STATUS BADGE
                    Text(
                      isDone ? "Done" : (task.status == "progress" ? "Working..." : "Upcoming"),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDone 
                          ? const Color(0xFF10B981) 
                          : (task.status == "progress" ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}