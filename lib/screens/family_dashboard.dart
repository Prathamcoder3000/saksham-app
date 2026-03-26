import 'package:flutter/material.dart';

class FamilyDashboard extends StatelessWidget {
  const FamilyDashboard({super.key});

  static const primary = Color(0xFF004AC6);
  static const primaryContainer = Color(0xFF2563EB);
  static const secondary = Color(0xFF006B5F);
  static const bg = Color(0xFFF6FAFE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      body: Stack(
        children: [

          // 🔻 MAIN CONTENT
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 90, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _heroCard(),

                const SizedBox(height: 24),

                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Health Snapshot",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lexend")),
                    Text("Last updated 10m ago",
                        style: TextStyle(color: primary, fontFamily: "Lexend")),
                  ],
                ),

                const SizedBox(height: 16),

                // GRID
                Row(
                  children: [
                    Expanded(child: _heartCard()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _miniCard(Icons.bedtime, "Sleep", "7h 45m"),
                          const SizedBox(height: 12),
                          _miniCard(Icons.directions_walk, "Activity", "2,410 steps"),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _medicationCard(),

                const SizedBox(height: 20),

                // TIMELINE HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Recent Moments",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lexend")),
                    Text("View Timeline",
                        style: TextStyle(color: primary, fontFamily: "Lexend")),
                  ],
                ),

                const SizedBox(height: 12),

                _timeline(),

                const SizedBox(height: 20),

                _caretakerCard(),
              ],
            ),
          ),

          _topBar(),
          _bottomNav(),
        ],
      ),
    );
  }

  // 🔝 TOP BAR
  Widget _topBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.06),
            blurRadius: 20,
          )
        ],
      ),
      child: Row(
        children: const [
          CircleAvatar(radius: 20),
          SizedBox(width: 10),
          Text(
            "Saksham",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
                fontFamily: "Lexend"),
          ),
          Spacer(),
          Icon(Icons.notifications, color: primary)
        ],
      ),
    );
  }

  // 🔥 HERO
  Widget _heroCard() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage(
              "https://images.unsplash.com/photo-1501785888041-af3ef285b470"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.85),
              Colors.blue.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 4, backgroundColor: Colors.green),
                      SizedBox(width: 6),
                      Text("ACTIVE NOW",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontFamily: "Lexend")),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://i.pravatar.cc/150",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Arthur\nMontgomery",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Lexend"),
                      ),
                      Text(
                        "Room 402 • Maple Wing",
                        style: TextStyle(
                            color: Colors.white70,
                            fontFamily: "Lexend"),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ❤️ HEART
  Widget _heartCard() {
  return Container(
    height: 160,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F4F7), // ✅ FIXED (was white)
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Icon(Icons.favorite, color: Colors.red),

        const SizedBox(height: 10),

        const Text(
          "Heart Rate",
          style: TextStyle(fontSize: 13, fontFamily: "Lexend"),
        ),

        const Spacer(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              "72",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: "Lexend",
              ),
            ),
            SizedBox(width: 4),
            Text(
              "bpm",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: "Lexend",
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        const Row(
          children: [
            Icon(Icons.show_chart, size: 14, color: Color(0xFF006B5F)),
            SizedBox(width: 4),
            Text(
              "Stable",
              style: TextStyle(
                color: Color(0xFF006B5F),
                fontSize: 12,
                fontFamily: "Lexend",
              ),
            ),
          ],
        )
      ],
    ),
  );
}

  // MINI CARDS
Widget _miniCard(IconData icon, String title, String value) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F4F7), // ✅ FIXED
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF2563EB)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: "Lexend",
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "Lexend",
              ),
            ),
          ],
        )
      ],
    ),
  );
}

  // 💊 MEDICATION
 Widget _medicationCard() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFEAEFF2),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medication",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lexend",
                  ),
                ),
                Text(
                  "Daily adherence goal",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: "Lexend",
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "3 / 4",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lexend",
                  ),
                ),
                Text(
                  "doses completed",
                  style: TextStyle(fontFamily: "Lexend"),
                ),
              ],
            ),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF2563EB),
                  ),
                ),
                const Icon(Icons.medication, color: Color(0xFF2563EB)),
              ],
            )
          ],
        ),

        const SizedBox(height: 16),

        // ✅ ADDED PROGRESS BARS (MISSING BEFORE)
        Row(
          children: [
            _bar(true),
            const SizedBox(width: 6),
            _bar(true),
            const SizedBox(width: 6),
            _bar(true),
            const SizedBox(width: 6),
            _bar(false),
          ],
        )
      ],
    ),
  );
}

Widget _bar(bool active) {
  return Expanded(
    child: Container(
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2563EB) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

  // 🕒 TIMELINE
  Widget _timeline() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [

        // 🔵 FIRST ITEM
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // DOT + LINE
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 90,
                  color: Color(0xFFE5E7EB),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "10:45 AM",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: "Lexend",
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Activity Log",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      fontFamily: "Lexend",
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Arthur enjoyed a morning walk in the central garden with Sarah. He seemed very cheerful today.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontFamily: "Lexend",
                    ),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 🟢 SECOND ITEM
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFF006B5F),
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text(
                    "08:30 AM",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: "Lexend",
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Health Check",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      fontFamily: "Lexend",
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Vitals recorded by Nurse Elena. Blood pressure is within normal range (128/84).",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontFamily: "Lexend",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  // 👩‍⚕️ CARETAKER
Widget _caretakerCard() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF006B5F)],
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        )
      ],
    ),
    child: Row(
      children: [

        // 👩 AVATAR
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orange, width: 3),
          ),
          child: ClipOval(
            child: Image.network(
              "https://i.pravatar.cc/150?img=47",
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // TEXT
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Caretaker Elena",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  fontFamily: "Lexend",
                ),
              ),
              Text(
                "On Duty until 6 PM",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: "Lexend",
                ),
              ),
            ],
          ),
        ),

        // 📞 CALL
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.call, color: Color(0xFF2563EB)),
        ),

        const SizedBox(width: 10),

        // 💬 CHAT
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.chat, color: Colors.white),
        ),
      ],
    ),
  );
}

  // 🔻 NAV
  Widget _bottomNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: primary),
            Icon(Icons.favorite, color: Colors.grey),
            Icon(Icons.event_note, color: Colors.grey),
            Icon(Icons.settings, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}