import 'package:meta/meta.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'single_game.dart';
import 'package:maui/screens/score_screen.dart';
import 'package:maui/state/app_state_container.dart';

class HeadToHeadGame extends StatefulWidget {
  final String gameName;
  final GameMode gameMode;
  final GameConfig gameConfig;

  HeadToHeadGame(this.gameName,
      {this.gameMode = GameMode.iterations, @required this.gameConfig});

  @override
  HeadToHeadGameState createState() {
    return new HeadToHeadGameState();
  }
}

class HeadToHeadGameState extends State<HeadToHeadGame> {
  int _myScore = 0;
  int _otherScore = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  setMyScore(int score) {
    _myScore = score;
  }

  setOtherScore(int score) {
    _otherScore = score;
  }

  onGameEnd(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(context,
        new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new ScoreScreen(
        gameName: widget.gameName,
        gameDisplay: GameDisplay.myHeadToHead,
        myUser: AppStateContainer.of(context).state.loggedInUser,
        myScore: _myScore,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final myGame = new SingleGame(
      widget.gameName,
      key: new GlobalObjectKey('SingleGame.my'),
      gameMode: widget.gameMode,
      gameDisplay: GameDisplay.myHeadToHead,
      gameConfig: widget.gameConfig,
      onScore: setMyScore,
      onGameEnd: onGameEnd,
    );
    return media.size.height > media.size.width
        ? new Column(
            children: <Widget>[
              new Expanded(
                  child: new RotatedBox(
                      child: new SingleGame(widget.gameName,
                          key: new GlobalObjectKey('SingleGame.other'),
                          gameMode: widget.gameMode,
                          gameDisplay: GameDisplay.otherHeadToHead,
                          gameConfig: widget.gameConfig,
                          onScore: setOtherScore,
                          onGameEnd: onGameEnd,
                          isRotated: true),
                      quarterTurns: 2)),
              new Expanded(child: myGame)
            ],
          )
        : new Row(children: <Widget>[
            new Expanded(
                child: new SingleGame(widget.gameName,
                    key: new GlobalObjectKey('SingleGame.other'),
                    gameDisplay: GameDisplay.otherHeadToHead,
                    gameMode: widget.gameMode,
                    gameConfig: widget.gameConfig,
                    onScore: setOtherScore,
                    onGameEnd: onGameEnd)),
            new Expanded(child: myGame)
          ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }
}
