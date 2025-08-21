import 'package:flutter/material.dart';
import 'timer_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimerScreen()),
            );
          },
          child: const Text(
            "Start Hackathon Timer",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
