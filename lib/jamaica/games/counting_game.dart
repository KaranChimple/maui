import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;
  bool solved;
  int index;

  _ChoiceDetail(
      {this.number,
      this.solved = false,
      this.reaction = Reaction.success,
      this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, solved: $solved, index: $index, reaction: $reaction)';
}

class CountingGame extends StatefulWidget {
  final int answer;
  final BuiltList<int> choices;
  final OnGameOver onGameOver;

  const CountingGame({Key key, this.answer, this.choices, this.onGameOver})
      : super(key: key);

  @override
  _CountingGameState createState() => _CountingGameState();
}

class _CountingGameState extends State<CountingGame> {
  List<_ChoiceDetail> answers = [];

  @override
  void initState() {
    super.initState();
    int value = widget.answer;
    int i = 0;
    while (value > 0) {
      answers.insert(
          0,
          _ChoiceDetail(
            number: value % 10,
            index: i++,
          ));
      value ~/= 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(answers);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Row(
            children: List<Widget>.generate(
                widget.answer,
                (i) => Expanded(
                    child: Image.asset('assets/accessories/apple.png',
                        fit: BoxFit.scaleDown))),
          ),
        ),
        Flexible(
          flex: 1,
          child: BentoBox(
            dragConfig: DragConfig.draggableMultiPack,
            rows: widget.choices.length > 5 ? 2 : 1,
            cols: min(widget.choices.length, 5),
            children: widget.choices
                .map((c) => CuteButton(
                      key: Key(c.toString()),
                      child: DotNumber(
                        number: c,
                        showNumber: true,
                      ),
                    ))
                .toList(growable: false),
            qRows: 1,
            qCols: answers.length,
            qChildren: answers
                .map((a) => a.solved
                    ? CuteButton(
                        key: Key('answer_${a.index}'),
                        child: Center(child: Text(a.number.toString())),
                      )
                    : DragTarget<String>(
                        key: Key('answer_${a.index}'),
                        builder: (context, candidateData, rejectedData) =>
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                            ),
                        onWillAccept: (data) => data == a.number.toString(),
                        onAccept: (data) {
                          setState(() => a.solved = true);
                          widget.onGameOver(1);
                        },
                      ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
