import 'package:flutter/material.dart';

enum GameChoice {
  rock('Rock', Icons.hexagon_rounded),
  paper('Paper', Icons.description_rounded),
  scissors('Scissors', Icons.content_cut_rounded);

  const GameChoice(this.label, this.icon);
  final String label;
  final IconData icon;
}
