import 'package:flutter/material.dart';

import '../models/game_choice.dart';

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    required this.choice,
    required this.selected,
    required this.onPressed,
    super.key,
  });
  final GameChoice choice;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Choose ${choice.label}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 3 : 1,
          ),
          color: selected
              ? colors.primaryContainer
              : colors.surfaceContainerLow,
        ),
        child: InkWell(
          key: ValueKey('choice-${choice.name}'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 88, minHeight: 96),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(choice.icon, size: 34, color: colors.primary),
                  const SizedBox(height: 8),
                  Text(
                    choice.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
