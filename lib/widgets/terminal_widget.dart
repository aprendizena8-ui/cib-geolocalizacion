import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TerminalWidget extends StatelessWidget {
  final String message;
  final bool missionCompleted;

  const TerminalWidget({
    super.key,
    required this.message,
    this.missionCompleted = false,
  });

  Future<void> _vibrateMorse(String code) async {
    Map<String, List<int>> morse = {
      ".": [100, 100],
      "-": [300, 100],
    };

    for (var char in code.split("")) {
      if (morse.containsKey(char)) {
        await Vibration.vibrate(pattern: morse[char]!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (missionCompleted) {
      _vibrateMorse("...---...");
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: 'RobotoMono',
          color: Colors.greenAccent,
          fontSize: 16,
        ),
      ),
    );
  }
}