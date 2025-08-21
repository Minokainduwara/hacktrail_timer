import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const HackathonTimerApp());
}

class HackathonTimerApp extends StatelessWidget {
  const HackathonTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackathon Timer',
      theme: ThemeData.dark(),
      home: const LoginScreen(), // Start with login screen
      debugShowCheckedModeBanner: false,
    );
  }
}
