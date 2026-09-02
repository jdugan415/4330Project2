import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rps_game/controllers/game_controller.dart';
import 'package:rps_game/main.dart';
import 'package:rps_game/models/game_choice.dart';
import 'package:rps_game/screens/game_screen.dart';

void main() {
  testWidgets('opening credits transition into the playable game', (
    tester,
  ) async {
    await tester.pumpWidget(const RockPaperScissorsApp());
    expect(find.text('THE GAME'), findsOneWidget);
    expect(find.text('by Jack Dugan and Andrew Kilpatric'), findsOneWidget);
    expect(find.byType(GameScreen), findsNothing);
    await tester.pump(const Duration(milliseconds: 3200));
    await tester.pumpAndSettle();
    expect(find.text('Rock Paper Scissors'), findsOneWidget);
    for (final label in ['Rock', 'Paper', 'Scissors']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('0'), findsNWidgets(4));
  });
  testWidgets('tapping a choice completes one round', (tester) async {
    final c = GameController(choiceGenerator: () => GameChoice.scissors);
    await tester.pumpWidget(MaterialApp(home: GameScreen(controller: c)));
    await tester.tap(find.byKey(const ValueKey('choice-rock')));
    await tester.pumpAndSettle();
    expect(c.roundsPlayed, 1);
    expect(find.text('You win!'), findsOneWidget);
  });
  testWidgets('reset confirmation clears game', (tester) async {
    final c = GameController(choiceGenerator: () => GameChoice.rock);
    await tester.pumpWidget(MaterialApp(home: GameScreen(controller: c)));
    await tester.tap(find.byKey(const ValueKey('choice-paper')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('reset-game')));
    await tester.tap(find.byKey(const ValueKey('reset-game')));
    await tester.pumpAndSettle();
    expect(find.text('Reset game?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
    await tester.pumpAndSettle();
    expect(c.roundsPlayed, 0);
    expect(find.text('Make your first move'), findsOneWidget);
  });
}
