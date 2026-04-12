import 'package:saksham/services/api_service.dart';
import 'dart:convert';
import 'detailed_report.dart';
import 'manage_staff.dart';
import 'resident_list.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _summary = {};
  List<dynamic> _trend = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final summaryRes = await ApiService.get('/reports/summary');
      final trendRes = await ApiService.get('/reports/adherence-trend');

      if (summaryRes.statusCode == 200 && trendRes.statusCode == 200) {
        setState(() {
          _summary = jsonDecode(summaryRes.body)['data'];
          _trend = jsonDecode(trendRes.body)['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      body: Stack(
        children: [

          // 🔝 HEADER
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
                  color: Colors.white.withOpacity(0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                            child: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Reports",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(radius: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 BODY
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 110, 20, 110),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Performance\nSummary",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Reviewing health metrics and operational efficiency for the current period.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  _statCard(Icons.verified, "Overall Adherence", "${_summary['adherenceRate'] ?? 0}%", "+2.4%", Colors.blue),
                  _statCard(Icons.notifications, "Active Alerts", "${_summary['activeAlerts'] ?? 0}".padLeft(2, '0'), "Pending action", Colors.red),
                  _statCard(Icons.calendar_today, "Daily Check-ins", "${_summary['dailyCheckins'] ?? 0}", "Completed today", Colors.teal),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Adherence Trends",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          _chip("7 Days", true),
                          _chip("30 Days", false),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _trend.map((t) {
                          final date = DateTime.parse(t['date']);
                          final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
                          return _bar(day, t['rate'] / 100.0, highlight: t['rate'] >= 90);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text("Overview",
                      style: TextStyle(fontWeight: FontWeight.w600)),

                  const SizedBox(height: 15),

                  _overview(context, Icons.medication, "Medication Logs", "42 Active patients"),
                  _overview(context, Icons.monitor_heart, "Vital Statistics", "Stable across 92% of residents"),
                  _overview(context, Icons.assignment, "Staff Reports", "12 Weekly audits completed"),

                  const SizedBox(height: 25),

                  // 🔵 SCORE CARD
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.blue.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [

                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CustomPaint(
                            painter: CirclePainter((_summary['adherenceRate'] ?? 0).toDouble()),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${_summary['adherenceRate'] ?? 0}",
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  const Text("TARGET 95",
                                      style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text("Facility Health Score",
                            style: TextStyle(fontWeight: FontWeight.bold)),

                        const SizedBox(height: 6),

                        const Text(
                          "Your facility is performing within the top 5% of regional standards for adherence.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 15),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.25),
                                blurRadius: 12,
                              )
                            ],
                          ),
                          child: const Text("Download Full PDF",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
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
          color: Colors.white,
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
              _navBtnRp(ctx, Icons.dashboard, "Dashboard", false),
              _navBtnRp(ctx, Icons.group, "Staff", false),
              _navBtnRp(ctx, Icons.people, "Residents", false),
              _navBtnRp(ctx, Icons.analytics, "Reports", true),
              _navBtnRp(ctx, Icons.settings, "Settings", false),
            ],
          ),
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 20,
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF2563EB),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Report export coming soon!"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Icon(Icons.share),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// 🔹 COMPONENTS
//////////////////////////////////////////////////////////

Widget _statCard(IconData icon, String title, String value, String sub, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -40,
          top: -40,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(sub,
                    style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _chip(String text, bool active) {
  return Container(
    margin: const EdgeInsets.only(left: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: active ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text,
        style: TextStyle(
            color: active ? Colors.blue : Colors.grey,
            fontSize: 12)),
  );
}

Widget _bar(String day, double height, {bool highlight = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [

      if (highlight)
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text("100%",
              style: TextStyle(color: Colors.white, fontSize: 10)),
        ),

      Container(
        height: 110 * height,
        width: 10,
        decoration: BoxDecoration(
          gradient: highlight
              ? const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF14B8A6)])
              : null,
          color: highlight ? null : Colors.blue.withOpacity(0.25),
          borderRadius: BorderRadius.circular(6),
        ),
      ),

      const SizedBox(height: 6),

      Text(day,
          style: TextStyle(
              fontSize: 10,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
              color: highlight ? Colors.blue : Colors.grey)),
    ],
  );
}

Widget _overview(BuildContext context, IconData icon, String title, String sub) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DetailedReportScreen(),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.1),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(sub, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}

Widget _navBtnRp(BuildContext context, IconData icon, String label, bool active) {
  return GestureDetector(
    onTap: () {
      if (active) return;
      
      if (label == "Dashboard") {
        Navigator.popUntil(context, (route) => route.isFirst);
      } else if (label == "Staff") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManageStaffScreen()));
      } else if (label == "Residents") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResidentListScreen()));
      } else if (label == "Settings") {
        // Not implemented Settings screen for admin yet, pop to dashboard
        Navigator.popUntil(context, (route) => route.isFirst);
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

class CirclePainter extends CustomPainter {
  final double value;
  CirclePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 100))
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, 0, 2 * pi, false, bgPaint);

    final sweep = 2 * pi * (value / 100);
    canvas.drawArc(rect, -pi / 2 + 0.2, sweep - 0.3, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}