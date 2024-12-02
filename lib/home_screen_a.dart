import 'package:flutter/material.dart';
import 'package:tic_tac_toe_project/game_screen_a.dart';
import 'package:tic_tac_toe_project/player_input.dart';
import 'package:tic_tac_toe_project/start_button.dart';

class HomeScreenA extends StatefulWidget {
  const HomeScreenA({super.key});

  @override
  State<HomeScreenA> createState() => _HomeScreenAState();
}

class _HomeScreenAState extends State<HomeScreenA> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController playerController = TextEditingController();

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
              "Enter Your Name",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFC857), // Vibrant yellow
              ),
            ),

            const SizedBox(height: 20),

            PlayerInput(
              controller: playerController,
              hint: "Player Name",
              validatorMessage: "Please enter your name",
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child:StartButton(
                  onTap:() {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return GameScreenA(
                                player: playerController.text
                            );
                          },
                        ),
                      );
                    }
                  },
                  text:"Start Game"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
