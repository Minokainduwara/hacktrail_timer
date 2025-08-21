import 'dart:async';
import 'package:flutter/material.dart';

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
      home: const TimerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int openingCountdown = 10;
  bool showHackathon = false;

  static const int hackathonDuration = 6 * 60 * 60; // 6 hours
  int remainingTime = hackathonDuration;
  bool paused = false;

  Timer? openingTimer;
  Timer? hackathonTimer;

  @override
  void initState() {
    super.initState();
    startOpeningCountdown();
  }

  void startOpeningCountdown() {
    openingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (openingCountdown > 1) {
        setState(() => openingCountdown--);
      } else {
        timer.cancel();
        setState(() => showHackathon = true);
        startHackathonTimer();
      }
    });
  }

  void startHackathonTimer() {
    hackathonTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!paused) {
        if (remainingTime > 0) {
          setState(() => remainingTime--);
        } else {
          timer.cancel();
        }
      }
    });
  }

  String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  void dispose() {
    openingTimer?.cancel();
    hackathonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backdrop.jpeg"), // your image here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: showHackathon
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      remainingTime > 0
                          ? formatTime(remainingTime)
                          : "Hackathon Over 🎉",
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(3, 3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => paused = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text("⏸ Pause",
                              style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => setState(() => paused = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text("▶ Resume",
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  "$openingCountdown",
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    shadows: [
                      Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(4, 4)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
