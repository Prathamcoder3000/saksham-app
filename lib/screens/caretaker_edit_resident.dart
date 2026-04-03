import 'package:flutter/material.dart';

class CaretakerEditResidentScreen extends StatefulWidget {
  final Map<String, String> data;

  const CaretakerEditResidentScreen({super.key, required this.data});

  @override
  State<CaretakerEditResidentScreen> createState() =>
      _CaretakerEditResidentScreenState();
}

class _CaretakerEditResidentScreenState
    extends State<CaretakerEditResidentScreen> {

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController conditionController;
  late TextEditingController contactController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.data["name"]);
    ageController = TextEditingController(text: "78");
    conditionController =
        TextEditingController(text: "Hypertension");
    contactController =
        TextEditingController(text: "Sarah Montgomery");
    phoneController =
        TextEditingController(text: "+1 (555) 123-4567");
  }

  void save() {
    Navigator.pop(context, {
      "name": nameController.text,
      "room": widget.data["room"],
      "status": widget.data["status"],
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Quick Edit",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
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

                    // 👤 AVATAR
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Text(
                            nameController.text.isNotEmpty
                                ? nameController.text[0]
                                : "A",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 16),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Tap to update photo",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // 🧾 INPUT CARDS
                    _field("Name", nameController),
                    _field("Age", ageController),
                    _field("Condition", conditionController),

                    const SizedBox(height: 10),

                    // 📞 CONTACT CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _field("Contact Name", contactController),
                          _field("Phone", phoneController),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 💾 SAVE BUTTON
                    GestureDetector(
                      onTap: save,
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
                            "Save Changes",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ❌ CANCEL
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text("Cancel"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 INPUT FIELD
  Widget _field(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}