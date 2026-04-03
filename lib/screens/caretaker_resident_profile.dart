import 'package:flutter/material.dart';

class CaretakerResidentProfileScreen extends StatelessWidget {
  final Map<String, String> data;

  const CaretakerResidentProfileScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // 🔝 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        const Text(
                          "Resident Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CaretakerEditResidentScreen(data: data),
                          ),
                        );
                        if (result != null) {
                          // Handle updated data (e.g., refresh profile)
                        }
                      },
                      child: const Icon(Icons.edit, color: Colors.blue),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 👤 PROFILE
              Column(
                children: [

                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(
                      data["name"]![0],
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data["room"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "ACTIVE",
                    style: TextStyle(color: Colors.green, letterSpacing: 2),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data["name"]!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Chip(label: Text("82 Years")),
                      SizedBox(width: 10),
                      Chip(
                        label: Text("Premium Care"),
                        avatar: Icon(Icons.verified, size: 16),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🧾 PERSONAL INFO
              _card(
                title: "Personal Info",
                icon: Icons.person,
                child: Column(
                  children: const [
                    _info("DOB", "May 14, 1941"),
                    _info("Gender", "Male"),
                    _info("Admission", "Oct 12, 2022"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🏥 HEALTH
              _card(
                title: "Health Overview",
                icon: Icons.favorite,
                iconColor: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text("Conditions"),
                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      children: const [
                        _chip("Hypertension"),
                        _chip("Dementia"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text("Allergy",
                        style: TextStyle(color: Colors.red)),
                    const Text("Penicillin (High Risk)",
                        style: TextStyle(color: Colors.red)),

                    const SizedBox(height: 10),

                    const Text("Medication"),
                    const SizedBox(height: 6),

                    _med("Lisinopril", "8:00 AM"),
                    _med("Donepezil", "8:00 PM"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🚨 QUICK ACTIONS (caretaker specific)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Quick Actions",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        _actionBtn(Icons.phone, "Call"),
                        _actionBtn(Icons.medication, "Med"),
                        _actionBtn(Icons.warning, "SOS"),

                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 CARD
  static Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
    Color iconColor = Colors.blue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// 🔹 SMALL COMPONENTS

class _info extends StatelessWidget {
  final String title, value;
  const _info(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}

class _chip extends StatelessWidget {
  final String text;
  const _chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text));
  }
}

Widget _med(String name, String time) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        Text(time, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}

Widget _actionBtn(IconData icon, String label) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.blue),
      ),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(color: Colors.white)),
    ],
  );
}