import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  final TextEditingController durationController = TextEditingController();
  final TextEditingController countdownController = TextEditingController();

  Future<void> saveTimerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? duration = int.tryParse(durationController.text);
    int? countdown = int.tryParse(countdownController.text);

    if (duration != null && countdown != null) {
      await prefs.setInt('hackathonDuration', duration * 3600); // hours to seconds
      await prefs.setInt('openingCountdown', countdown);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Settings saved successfully!")),
      );
    }
  }

  Future<void> clearTimerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('remainingTime');
    await prefs.remove('hackathonDuration');
    await prefs.remove('openingCountdown');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Menu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Hackathon Duration (hours)"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: countdownController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Opening Countdown (seconds)"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveTimerSettings,
              child: const Text("Save Timer Settings"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: clearTimerSettings,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Clear Timer Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
