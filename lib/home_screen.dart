import 'package:flutter/material.dart';
import 'package:tic_tac_toe_project/game_screen.dart';
import 'package:tic_tac_toe_project/player_input.dart';
import 'package:tic_tac_toe_project/start_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3271), // Dark purple
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Players Name",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFC857), // Vibrant yellow
              ),
            ),

            const SizedBox(height: 20),

            PlayerInput(
              controller: player1Controller,
              hint: "Player 1 Name",
              validatorMessage: "Please enter player 1 name",
            ),

            PlayerInput(
              controller: player2Controller,
              hint: "Player 2 Name",
              validatorMessage: "Please enter player 2 name",
            ),

            const SizedBox(height: 20),

            StartButton(
              onTap:() {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return GameScreen(
                          player1: player1Controller.text,
                          player2: player2Controller.text,
                        );
                      },
                    ),
                  );
                }
              },
              text:"Start Game"
            ),
          ],
        ),
      ),
    );
  }
}
