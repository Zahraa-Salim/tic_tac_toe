import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const StartButton({required this.text, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell( // Make ripple effect
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFC857), // Vibrant yellow
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E294E), // Dark purple
          ),
          textAlign: TextAlign.center, // Center text horizontally
        ),
      ),
    );
  }
}
