import 'package:flutter/material.dart';

class PlayerInput extends StatefulWidget {

  final TextEditingController controller;
  final String hint;
  final String validatorMessage;

  const PlayerInput({
  required this.controller,
  required this.hint,
  required this.validatorMessage, super.key
});

  @override
  State<PlayerInput> createState() => _PlayerInputState();
}

class _PlayerInputState extends State<PlayerInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white),
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}



