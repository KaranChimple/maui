import 'package:flutter/material.dart';
import 'package:maui/jamaica/games/wordgrid_game.dart';
import 'package:storyboard/storyboard.dart';

class WordGridGameStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: WordGridGame(
              answer: ['C', 'A', 'T'],
              choice: ['X'],
              onGameOver: (_) {},
            ),
          ),
        ),
        Scaffold(
          body: SafeArea(
            child: WordGridGame(
              answer: ['A', 'P', 'P', 'L', 'E'],
              choice: ['X', 'Y', 'Z', 'O'],
              onGameOver: (_) {},
            ),
          ),
        ),
      ];
}
