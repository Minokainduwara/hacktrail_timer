import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  int openingCountdown = 10;
  bool showHackathon = false;
  bool showIntroQuote = false;

  int hackathonDuration = 6 * 60 * 60; // default 6 hours
  int remainingTime = 6 * 60 * 60;
  bool paused = false;

  Timer? openingTimer;
  Timer? hackathonTimer;
  final AudioPlayer audioPlayer = AudioPlayer();

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    loadTimerSettings();
  }

  Future<void> loadTimerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load admin-set hackathon duration and countdown
    hackathonDuration = prefs.getInt('hackathonDuration') ?? hackathonDuration;
    openingCountdown = prefs.getInt('openingCountdown') ?? openingCountdown;
    remainingTime = prefs.getInt('remainingTime') ?? hackathonDuration;

    // Start appropriate timer
    if (prefs.containsKey('remainingTime')) {
      setState(() => showHackathon = true);
      startHackathonTimer();
    } else {
      startOpeningCountdown();
    }
  }

  void startOpeningCountdown() {
    openingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (openingCountdown > 0) {
        await audioPlayer.play(AssetSource('beep.mp3'));
        setState(() => openingCountdown--);
        _scaleController.forward(from: 0.0);
      } else {
        timer.cancel();
        await audioPlayer.stop();
        setState(() => showIntroQuote = true);

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            showIntroQuote = false;
            showHackathon = true;
          });
          startHackathonTimer();
        });
      }
    });
  }

  void startHackathonTimer() {
    hackathonTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!paused) {
        if (remainingTime > 0) {
          setState(() => remainingTime--);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('remainingTime', remainingTime);
        } else {
          timer.cancel();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('remainingTime');
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
    audioPlayer.dispose();
    _scaleController.dispose();
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
            image: AssetImage("assets/backdrop.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: showIntroQuote
              ? const Text(
                  "From concept to code,\nlet the magic unfold!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.white,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                )
              : showHackathon
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
                  : ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
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
      ),
    );
  }
}
