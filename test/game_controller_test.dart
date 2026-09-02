import 'package:flutter_test/flutter_test.dart';
import 'package:rps_game/controllers/game_controller.dart';
import 'package:rps_game/models/game_choice.dart';
import 'package:rps_game/models/round_result.dart';

void main() {
  group('winner logic', () {
    final cases = <(GameChoice, GameChoice, RoundResult)>[
      (GameChoice.rock, GameChoice.rock, RoundResult.tie),
      (GameChoice.rock, GameChoice.paper, RoundResult.computerWin),
      (GameChoice.rock, GameChoice.scissors, RoundResult.playerWin),
      (GameChoice.paper, GameChoice.rock, RoundResult.playerWin),
      (GameChoice.paper, GameChoice.paper, RoundResult.tie),
      (GameChoice.paper, GameChoice.scissors, RoundResult.computerWin),
      (GameChoice.scissors, GameChoice.rock, RoundResult.computerWin),
      (GameChoice.scissors, GameChoice.paper, RoundResult.playerWin),
      (GameChoice.scissors, GameChoice.scissors, RoundResult.tie),
    ];
    for (final (player, computer, expected) in cases) {
      test(
        '${player.name} versus ${computer.name}',
        () =>
            expect(GameController.determineResult(player, computer), expected),
      );
    }
  });

  test('round increments once and only the player score', () {
    final c = GameController(choiceGenerator: () => GameChoice.scissors)
      ..playRound(GameChoice.rock);
    expect(
      (c.roundsPlayed, c.playerWins, c.computerWins, c.ties),
      (1, 1, 0, 0),
    );
  });
  test('computer victory increments only computer score', () {
    final c = GameController(choiceGenerator: () => GameChoice.paper)
      ..playRound(GameChoice.rock);
    expect((c.playerWins, c.computerWins, c.ties), (0, 1, 0));
  });
  test('tie increments only tie score', () {
    final c = GameController(choiceGenerator: () => GameChoice.rock)
      ..playRound(GameChoice.rock);
    expect((c.playerWins, c.computerWins, c.ties), (0, 0, 1));
  });
  test('reset clears all state', () {
    final c = GameController(choiceGenerator: () => GameChoice.paper)
      ..playRound(GameChoice.rock)
      ..reset();
    expect(
      (c.roundsPlayed, c.playerWins, c.computerWins, c.ties),
      (0, 0, 0, 0),
    );
    expect(c.playerChoice, isNull);
    expect(c.computerChoice, isNull);
    expect(c.result, isNull);
  });
  test('random choices are always valid', () {
    final c = GameController();
    for (var i = 0; i < 100; i++) {
      expect(GameChoice.values, contains(c.generateComputerChoice()));
    }
  });
}
