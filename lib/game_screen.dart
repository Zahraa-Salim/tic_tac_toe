import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_project/build_player_info.dart';
import 'package:tic_tac_toe_project/main_screen.dart';
import 'package:tic_tac_toe_project/winner_line_painter.dart';
import 'package:tic_tac_toe_project/build_action_button.dart';

// ignore: must_be_immutable
class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  const GameScreen({super.key, required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ""));
  late String _currentPlayer = "X";
  late String _winner = "";
  late bool _gameOver = false;
  late AnimationController _lineAnimationController;
  List<List<int>> _winningLine = [];
  int player1Wins = 0;
  int player2Wins = 0;

  @override
  void initState() {
    super.initState();
    _lineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _lineAnimationController.dispose();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
      _winningLine = [];
      _lineAnimationController.reset();
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col].isEmpty && !_gameOver) {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWinner(row, col)) {
          _gameOver = true;
          _winner = _currentPlayer;
          if (_currentPlayer == "X") {
            player1Wins++;
          } else {
            player2Wins++;
          }
          _lineAnimationController.forward();
          _showResultDialog("Winner: ${_currentPlayer == "X" ? widget.player1 : widget.player2}");
        } else if (_isDraw()) {
          _gameOver = true;
          _showResultDialog("It's a Draw!");
        } else {
          _currentPlayer = _currentPlayer == "X" ? "O" : "X";
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    List<List<int>> winningPositions = [];

    // Check row
    if (_board[row].every((cell) => cell == _currentPlayer)) {
      winningPositions = List.generate(3, (i) => [row, i]);
    }

    // Check column
    if (_board.every((r) => r[col] == _currentPlayer)) {
      winningPositions = List.generate(3, (i) => [i, col]);
    }

    // Check main diagonal
    if (row == col && _board.every((r) => r[_board.indexOf(r)] == _currentPlayer)) {
      winningPositions = List.generate(3, (i) => [i, i]);
    }

    // Check anti-diagonal
    if (row + col == 2 && _board.every((r) => r[2 - _board.indexOf(r)] == _currentPlayer)) {
      winningPositions = List.generate(3, (i) => [i, 2 - i]);
    }

    if (winningPositions.isNotEmpty) {
      _winningLine = winningPositions;
      return true;
    }
    return false;
  }

  bool _isDraw() {
    return _board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showResultDialog(String message) {
    Future.delayed(const Duration(seconds: 1), () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        btnOkText: "Play Again",
        title: _winner == "X"
            ? "${widget.player1} Won!"
            : _winner == "O"
            ? "${widget.player2} Won!"
            : "It's a Tie",
        btnOkOnPress: _resetGame,
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3A3271),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            // Display player names and scores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BuildPlayerInfo(
                    playerName:widget.player1,
                    wins:player1Wins,
                    color:const Color(0xFFFFC857)
                ),
                BuildPlayerInfo(
                    playerName:widget.player2,
                    wins:player2Wins,
                    color:Colors.tealAccent
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Turn: ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _currentPlayer == "X"
                            ? "${widget.player1} ($_currentPlayer)"
                            : "${widget.player2} ($_currentPlayer)",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _currentPlayer == "X"
                              ? const Color(0xFFFFC857)
                              : Colors.tealAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF41337A),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(5),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GridView.builder(
                    itemCount: 9,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 3;
                      int col = index % 3;

                      double fontSize = screenWidth / 5;

                      return GestureDetector(
                        onTap: () => _makeMove(row, col),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E1E3A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: _board[row][col].isEmpty ? 0 : 1,
                              duration: const Duration(milliseconds: 300),
                              child: AnimatedScale(
                                scale: _board[row][col].isEmpty ? 0 : 1, // Initially scale down, then bounce to 1
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.elasticOut, // Bouncing effect
                                child: Text(
                                  _board[row][col],
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: _board[row][col] == "X"
                                        ? const Color(0xFFFFC857)
                                        : Colors.tealAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (_winningLine.isNotEmpty)
                    AnimatedBuilder(
                      animation: _lineAnimationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(screenWidth, screenWidth),
                          painter: WinningLinePainter(
                            _winningLine,
                            progress: _lineAnimationController.value,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildActionButton(
                    text:"Reset Game",
                    onTap:_resetGame,
                    color:const Color(0xFF1CBD9E)
                ),
                const SizedBox(width: 10),
                BuildActionButton(
                  text:"Restart Game",
                     onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                 color: const Color(0xFFDD4A48),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

