import 'package:flutter/material.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({
    required this.playerWins,
    required this.computerWins,
    required this.ties,
    required this.rounds,
    super.key,
  });
  final int playerWins;
  final int computerWins;
  final int ties;
  final int rounds;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Row(
        children: [
          _ScoreItem(label: 'You', value: playerWins),
          _ScoreItem(label: 'Computer', value: computerWins),
          _ScoreItem(label: 'Ties', value: ties),
          _ScoreItem(label: 'Rounds', value: rounds),
        ],
      ),
    ),
  );
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      label: '$label: $value',
      child: Column(
        children: [
          Text(
            '$value',
            key: ValueKey('score-${label.toLowerCase()}'),
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          FittedBox(child: Text(label)),
        ],
      ),
    ),
  );
}
