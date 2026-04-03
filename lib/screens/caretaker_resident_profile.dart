import 'package:flutter/material.dart';

class CaretakerResidentProfileScreen extends StatelessWidget {

  final Map<String, String> data;

  const 
  CaretakerResidentProfileScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),

      appBar: AppBar(
        title: const Text("Resident Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              child: Text(data["name"]![0]),
            ),

            const SizedBox(height: 10),

            Text(
              data["name"]!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              data["room"]!,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Text("Health: Stable"),
                  SizedBox(height: 6),
                  Text("Last Check: 2 hrs ago"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text("View Medication"),
            )
          ],
        ),
      ),
    );
  }
}