import 'package:flutter/material.dart';

class CaretakerDashboard extends StatelessWidget {
  const CaretakerDashboard({super.key});

  // 🎯 COLORS FROM YOUR HTML (EXACT TOKENS)
  static const bg = Color(0xFFF6FAFE);
  static const primary = Color(0xFF004AC6);
  static const primaryContainer = Color(0xFF2563EB);
  static const secondary = Color(0xFF006B5F);
  static const secondaryContainer = Color(0xFF6DF5E1);
  static const surfaceLow = Color(0xFFF0F4F8);
  static const surfaceHigh = Color(0xFFE4E9ED);
  static const surfaceWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      // 🔝 APPBAR (EXACT HEIGHT + STYLE)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: bg,
            border: Border(
              bottom: BorderSide(color: Color(0xFFEAEFF2), width: 1),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.menu, color: primary, size: 26),
              const SizedBox(width: 12),
              const Text(
                "Caretaker Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: primary,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: surfaceHigh,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 HERO TEXT (EXACT TYPOGRAPHY)
            const Text(
              "Hello, Sarah",
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w600,
                height: 1.15,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "4 priority tasks remaining for today.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF434655),
              ),
            ),

            const SizedBox(height: 30),

            // 🧩 CARDS
            _tile(
              bgColor: surfaceWhite,
              iconBg: const Color(0xFFDBE1FF),
              iconColor: primary,
              icon: Icons.group,
              title: "Residents",
              subtitle: "View and manage active resident profiles",
            ),

            _tile(
              bgColor: surfaceWhite,
              iconBg: secondaryContainer,
              iconColor: secondary,
              icon: Icons.medication,
              title: "Medication",
              subtitle: "Track and confirm medicine administration",
            ),

            _tile(
              bgColor: surfaceWhite,
              iconBg: const Color(0xFFD8E3FB),
              iconColor: const Color(0xFF3C475A),
              icon: Icons.check_circle,
              title: "Daily Tasks",
              subtitle: "Standard care routines and hygiene checks",
            ),

            // 🚨 SOS (EXACT SHADOW + GRADIENT)
            Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryContainer, Color(0xFF14B8A6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(37, 99, 235, 0.25),
                    blurRadius: 32,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        "SOS",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency SOS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Immediate alert system for urgent support",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 📝 SHIFT NOTES (NESTED CARD EXACT)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surfaceHigh,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Shift Notes",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.edit_note, color: primary),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _dotNote("Room 302 vitals updated 15m ago", secondary),
                    _dotNote("Medication round completed for West Wing", primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔻 NAV (GLASS EFFECT)
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 74, 198, 0.06),
              blurRadius: 32,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _navItem(Icons.home, "Home", true),
            _navItem(Icons.monitor_heart, "Vitals", false),
            _navItem(Icons.medical_services, "Care", false),
            _navItem(Icons.person, "Profile", false),
          ],
        ),
      ),
    );
  }

  // 🔹 TILE EXACT
  Widget _tile({
    required Color bgColor,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 74, 198, 0.04),
            blurRadius: 32,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF434655), fontSize: 14)),
                ]),
          )
        ],
      ),
    );
  }

  Widget _dotNote(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _navItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _navItem(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? Colors.blue : Colors.grey),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: active ? Colors.blue : Colors.grey))
      ],
    );
  }
}