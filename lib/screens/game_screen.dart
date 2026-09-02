import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../models/game_choice.dart';
import '../models/round_result.dart';
import '../widgets/choice_button.dart';
import '../widgets/choice_display.dart';
import '../widgets/scoreboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.controller});
  final GameController? controller;
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller = widget.controller ?? GameController();
  late final bool _ownsController = widget.controller == null;

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _requestReset() async {
    if (_controller.roundsPlayed == 0) return _controller.reset();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset game?'),
        content: const Text('This clears every score and the current round.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true) _controller.reset();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Rock Paper Scissors'), centerTitle: true),
    body: SafeArea(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Scoreboard(
                    playerWins: _controller.playerWins,
                    computerWins: _controller.computerWins,
                    ties: _controller.ties,
                    rounds: _controller.roundsPlayed,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Choose your move',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = (constraints.maxWidth - 24) / 3;
                      return Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: GameChoice.values
                            .map(
                              (choice) => SizedBox(
                                width: width.clamp(88, 190),
                                child: ChoiceButton(
                                  choice: choice,
                                  selected: _controller.playerChoice == choice,
                                  onPressed: () =>
                                      _controller.playRound(choice),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ChoiceDisplay(
                            title: 'You',
                            choice: _controller.playerChoice,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Center(child: Text('VS')),
                        ),
                        Expanded(
                          child: ChoiceDisplay(
                            title: 'Computer',
                            choice: _controller.computerChoice,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Semantics(
                    liveRegion: true,
                    label:
                        '${_controller.resultMessage}. ${_controller.explanation}',
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _ResultPanel(
                        key: ValueKey(_controller.roundsPlayed),
                        result: _controller.result,
                        message: _controller.resultMessage,
                        explanation: _controller.explanation,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    key: const ValueKey('reset-game'),
                    onPressed: _requestReset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset Game'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.result,
    required this.message,
    required this.explanation,
    super.key,
  });
  final RoundResult? result;
  final String message;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (color, icon) = switch (result) {
      RoundResult.playerWin => (Colors.green.shade700, Icons.celebration),
      RoundResult.computerWin => (colors.error, Icons.smart_toy_rounded),
      RoundResult.tie => (Colors.amber.shade800, Icons.handshake_rounded),
      null => (colors.primary, Icons.sports_esports_rounded),
    };
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(explanation, textAlign: TextAlign.center),
      ],
    );
  }
}
