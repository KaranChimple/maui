import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  int choice;
  Reaction reaction;
  int index;
  bool appear;

  _ChoiceDetail(
      {this.choice,
      this.appear = true,
      this.reaction = Reaction.success,
      this.index});

  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear, reaction: $reaction)';
}

class TablesGame extends StatefulWidget {
  final String question;
  final String answers;
  final OnGameOver onGameOver;

  const TablesGame({Key key, this.question, this.answers, this.onGameOver})
      : super(key: key);

  @override
  TablesGameState createState() => TablesGameState();
}

class TablesGameState extends State<TablesGame> {
  final List<String> _allLetters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '✖',
    '0',
    '✔',
  ];
  String _result = "";
  int score = 0;

  @override
  void initState() {
    super.initState();
    _result = '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Flexible(
            flex: 1,
            child: Container(
              color: Colors.green,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 10,
                    child: Text(
                      '${widget.question}',
                      style: TextStyle(fontSize: size.width*0.16),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 10,
                    child: Container(
                      height: size.width*0.37 * 0.6,
                      width: size.width*0.37,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.purple,
                            width: 7.0
                          ),
                          borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
                          ),
                      child: Center(
                        child: Text(
                          '$_result',
                          style: TextStyle(fontSize: size.width*0.16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Flexible(
          flex: 2,
          child: BentoBox(
            dragConfig: DragConfig.fixed,
            cols: 3,
            rows: 4,
            children: _allLetters
                .map((e) => CuteButton(
                      key: Key('$e'),
                      child: Center(
                        child: Text('$e'),
                      ),
                      onPressed: () {
                        if (e == '✖') {
                          setState(() {
                            _result = _result.substring(0, _result.length - 1);
                          });
                        } else if (e == '✔') {
                          if (_result == widget.answers) {
                            print('its!!! correct');
                          }
                        } else {
                          setState(() {
                            if (_result.length < 3) {
                              _result = _result + e;
                            }
                          });
                        }
                      },
                    ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
