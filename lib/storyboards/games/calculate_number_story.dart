import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/calculate_number.dart';
import 'package:storyboard/storyboard.dart';

class CalculateTheNumberStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: CalculateTheNumbers(
              onGameOver: (_) {},
              first: 11,
              second: 5,
              op: '+',
              answer: 16,
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: CalculateTheNumbers(
              onGameOver: (_) {},
              first: 3,
              second: 5,
              op: '+',
              answer: 8,
            ),
          ),
        )
      ];
}
