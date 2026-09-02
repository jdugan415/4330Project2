import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/game_choice.dart';
import '../models/round_result.dart';

typedef ChoiceGenerator = GameChoice Function();

class GameController extends ChangeNotifier {
  GameController({ChoiceGenerator? choiceGenerator})
    : _choiceGenerator = choiceGenerator ?? _secureChoice;

  static final Random _random = Random.secure();
  final ChoiceGenerator _choiceGenerator;
  bool _processing = false;
  GameChoice? playerChoice;
  GameChoice? computerChoice;
  RoundResult? result;
  int playerWins = 0;
  int computerWins = 0;
  int ties = 0;
  int roundsPlayed = 0;

  static GameChoice _secureChoice() =>
      GameChoice.values[_random.nextInt(GameChoice.values.length)];
  GameChoice generateComputerChoice() => _choiceGenerator();

  static RoundResult determineResult(GameChoice player, GameChoice computer) {
    if (player == computer) return RoundResult.tie;
    final won =
        (player == GameChoice.rock && computer == GameChoice.scissors) ||
        (player == GameChoice.paper && computer == GameChoice.rock) ||
        (player == GameChoice.scissors && computer == GameChoice.paper);
    return won ? RoundResult.playerWin : RoundResult.computerWin;
  }

  void playRound(GameChoice choice) {
    if (_processing) return;
    _processing = true;
    try {
      final computer = generateComputerChoice();
      final outcome = determineResult(choice, computer);
      playerChoice = choice;
      computerChoice = computer;
      result = outcome;
      roundsPlayed++;
      switch (outcome) {
        case RoundResult.playerWin:
          playerWins++;
        case RoundResult.computerWin:
          computerWins++;
        case RoundResult.tie:
          ties++;
      }
      notifyListeners();
    } finally {
      _processing = false;
    }
  }

  void reset() {
    playerChoice = null;
    computerChoice = null;
    result = null;
    playerWins = computerWins = ties = roundsPlayed = 0;
    notifyListeners();
  }

  String get resultMessage => switch (result) {
    RoundResult.playerWin => 'You win!',
    RoundResult.computerWin => 'Computer wins!',
    RoundResult.tie => "It's a tie!",
    null => 'Make your first move',
  };

  String get explanation {
    final player = playerChoice;
    final computer = computerChoice;
    if (player == null || computer == null) {
      return 'Your opponent is ready when you are.';
    }
    if (player == computer) return 'Both players chose ${player.label}.';
    final winner = result == RoundResult.playerWin ? player : computer;
    if (winner == GameChoice.rock) return 'Rock crushes Scissors.';
    if (winner == GameChoice.scissors) return 'Scissors cut Paper.';
    return 'Paper covers Rock.';
  }
}
