import 'package:flutter/material.dart';

import '../models/game_choice.dart';

class ChoiceDisplay extends StatelessWidget {
  const ChoiceDisplay({required this.title, required this.choice, super.key});
  final String title;
  final GameChoice? choice;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: choice == null
                  ? Column(
                      key: const ValueKey('waiting'),
                      children: [
                        Icon(
                          Icons.hourglass_empty_rounded,
                          color: colors.outline,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Waiting for choice',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      key: ValueKey(choice),
                      children: [
                        Icon(choice!.icon, size: 38, color: colors.primary),
                        const SizedBox(height: 8),
                        Text(choice!.label),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
