import 'package:flutter/material.dart';
import 'package:tic_tac_toe_project/home_screen.dart';
import 'package:tic_tac_toe_project/home_screen_a.dart';
import 'package:tic_tac_toe_project/start_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.7; // 70% of screen width

    return Scaffold(
      backgroundColor: const Color(0xFF3A3271),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button 1 - 2 Players
            SizedBox(
              width: buttonWidth,
              child: StartButton(
                text: "1 Player",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreenA();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            // Button 2 - 1 Player
            SizedBox(
              width: buttonWidth,
              child: StartButton(
                text: "2 Players",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomeScreen();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
