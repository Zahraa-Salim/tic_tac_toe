import 'package:flutter/material.dart';

class BuildPlayerInfo extends StatelessWidget {
  final String playerName;
  final int wins;
  final Color color;
  const BuildPlayerInfo({required this.playerName, required this.wins, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          playerName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          "Wins: $wins",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
