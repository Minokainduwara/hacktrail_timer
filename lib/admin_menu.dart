import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  Future<void> _saveDuration() async {
    final prefs = await SharedPreferences.getInstance();
    int hours = int.tryParse(_hoursController.text) ?? 0;
    int minutes = int.tryParse(_minutesController.text) ?? 0;

    int totalSeconds = hours * 3600 + minutes * 60;
    await prefs.setInt('hackathon_duration', totalSeconds);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Duration saved!")),
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Menu")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Hours",
              ),
            ),
            TextField(
              controller: _minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Minutes",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDuration,
              child: const Text("Save Timer"),
            ),
          ],
        ),
      ),
    );
  }
}
