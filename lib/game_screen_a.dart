import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_project/build_action_button.dart';
import 'package:tic_tac_toe_project/build_player_info.dart';
import 'dart:math';
import 'package:tic_tac_toe_project/main_screen.dart';
import 'package:tic_tac_toe_project/winner_line_painter.dart';

class GameScreenA extends StatefulWidget {
  final String player;
  final String computer = 'Tactica';

  const GameScreenA({super.key, required this.player});

  @override
  State<GameScreenA> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreenA> with TickerProviderStateMixin{
  List<List<String>> _board = List.generate(3, (_) => List.filled(3, ""));
  late String _currentPlayer = "X"; // Player starts as "X"
  late String _winner = "";
  late bool _gameOver = false;
  List<List<int>> _winningLine = []; // Stores winning cell positions
  int playerWins = 0;
  int computerWins = 0;

  late AnimationController _lineAnimationController;

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
            playerWins++;
          } else {
            computerWins++;
          }
          _lineAnimationController.forward();
          _showResultDialog(
              "Winner: ${_currentPlayer == "X" ? widget.player : widget.computer}");
        } else if (_isDraw()) {
          _gameOver = true;
          _showResultDialog("It's a Draw!");
        } else {
          _currentPlayer = _currentPlayer == "X" ? "O" : "X";

          // If it's O's turn (AI), make its move
          if (_currentPlayer == "O" && !_gameOver) {
            _aiMove();
          }
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
    if (row == col) {
      bool mainDiagonalWin = true;
      for (int i = 0; i < 3; i++) {
        if (_board[i][i] != _currentPlayer) {
          mainDiagonalWin = false;
          break;
        }
      }
      if (mainDiagonalWin) {
        winningPositions = List.generate(3, (i) => [i, i]);
      }
    }

    // Check anti-diagonal
    if (row + col == 2) {
      bool antiDiagonalWin = true;
      for (int i = 0; i < 3; i++) {
        if (_board[i][2 - i] != _currentPlayer) {
          antiDiagonalWin = false;
          break;
        }
      }
      if (antiDiagonalWin) {
        winningPositions = List.generate(3, (i) => [i, 2 - i]);
      }
    }

    if (winningPositions.isNotEmpty) {
      _winningLine = winningPositions; // Store winning positions for the line
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
            ? "${widget.player} Won!"
            : _winner == "O"
            ? "${widget.computer} Won!"
            : "It's a Tie",
        btnOkOnPress: _resetGame,
      ).show();
    });
  }

  bool _simulateMove(int row, int col, String player) {
    // Temporarily place the player's mark on the board
    _board[row][col]  = player;

    // Check for a win condition
    bool isWinningMove = _checkWin(player);

    // Undo the move
    _board[row][col] = "";

    return isWinningMove;
  }

  bool _checkWin(String player) {
    // Check rows, columns, and diagonals for a win
    for (int i = 0; i < 3; i++) {
      // Check rows
      if (_board[i][0] == player && _board[i][1] == player && _board[i][2] == player) {
        return true;
      }
      // Check columns
      if (_board[0][i] == player && _board[1][i] == player && _board[2][i] == player) {
        return true;
      }
    }
    // Check diagonals
    if (_board[0][0] == player && _board[1][1] == player && _board[2][2] == player) {
    return true;
    }
    if (_board[0][2] == player && _board[1][1] == player && _board[2][0] == player) {
      return true;
    }

    return false;
  }


  void _aiMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      // First, try to make a winning move for "O"
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (_board[row][col] == "") {
            if (_simulateMove(row, col, "O")) {
              _makeMove(row, col);
              return; // Made a winning move
            }
          }
        }
      }

      // Then, try to block the player ("X") from winning
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (_board[row][col] == "") {
            if (_simulateMove(row, col, "X")) {
              _makeMove(row, col);
              return; // Blocked "X"
            }
          }
        }
      }

      // 1. Take center if it's empty
      if (_board[1][1] == "") {
        _makeMove(1, 1);
        return;
      }

      // 2. Check for corners, take one if available
      List<List<int>> corners = [
        [0, 0],
        [0, 2],
        [2, 0],
        [2, 2]
      ];
      for (var corner in corners) {
        int row = corner[0];
        int col = corner[1];
        if (_board[row][col] == "") {
          _makeMove(row, col);
          return;
        }
      }

      // 3. Check for edges, take one if available
      List<List<int>> edges = [
        [0, 1],
        [1, 0],
        [1, 2],
        [2, 1]
      ];
      for (var edge in edges) {
        int row = edge[0];
        int col = edge[1];
        if (_board[row][col] == "") {
          _makeMove(row, col);
          return;
        }
      }

      // 4. If no strategic move, make a random move
      _makeRandomMove();
    });
  }


  void _makeRandomMove() {
    List<List<int>> availableMoves = [];
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (_board[row][col] == "") {
          availableMoves.add([row, col]);
        }
      }
    }
    if (availableMoves.isNotEmpty) {
      final random = Random();
      final randomMove = availableMoves[random.nextInt(availableMoves.length)];
      _makeMove(randomMove[0], randomMove[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3A3271), // Dark purple background
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            // Display player names and scores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BuildPlayerInfo(
                    playerName:widget.player,
                    wins:playerWins,
                    color:const Color(0xFFFFC857)
                ),
                BuildPlayerInfo(
                    playerName:widget.computer,
                    wins:computerWins,
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
                            ? "${widget.player} ($_currentPlayer)"
                            : "${widget.computer} ($_currentPlayer)",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _currentPlayer == "X"
                              ? const Color(0xFFFFC857)// Vibrant yellow for X
                              : Colors.tealAccent, // Red for O
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
                color: const Color(0xFF41337A), // Slightly lighter purple for board
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

                      double fontSize = screenWidth / 5; // Font size based on screen width

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
