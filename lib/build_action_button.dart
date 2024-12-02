import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BuildActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;

  const BuildActionButton({required this.text, required this.color, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

  }
}
