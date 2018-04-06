import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/shaker.dart';

class CalculateTheNumbers extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  CalculateTheNumbers(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _CalculateTheNumbersState();
}

class _CalculateTheNumbersState extends State<CalculateTheNumbers>
    with SingleTickerProviderStateMixin {
  final List<String> _allNumbers = [
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
    '✔'
  ];

  final int _size = 3;
  List<String> _numbers;
  String _preValue = ' ';
  int num1,
      num2,
      num1digit1,
      num1digit2,
      num1digit3,
      num2digit1,
      num2digit2,
      num2digit3;
  int result;
  String _output = ' ';
  String _operator = '';
  bool flag, carry;
  bool shake = true;
  Animation animationShake, animation;
  AnimationController animationController;
  Tuple4<int, String, int, int> data;
  bool _isLoading = true;
  String options;
  List<num> reminder = [];

  @override
  void initState() {
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animationShake =
        new Tween(begin: 0.0, end: 6.0).animate(animationController);
    animation = new Tween(begin: 0.0, end: 0.0).animate(animationController);
    _myAnim();
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _numbers = _allNumbers.sublist(0, _size * (_size + 1));
    data = await fetchMathData(widget.gameCategoryId);
    print(data);
    num1 = data.item1;
    num2 = data.item3;
    result = data.item4;
    _operator = data.item2;
    setState(() => _isLoading = false);
    if (num1 % 10 == num1 && num2 % 10 == num2) {
      options = 'one';
    } else if ( calCount(num1) == 2 || calCount(num2) == 2 ) {
      options = 'doubleDigitWithoutCarry';
       num1digit2 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit1 = num1 % 10;
      num2digit2 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit1 = num2 % 10; 
      if (calCount((num1digit1 + num2digit1)) > 1 ||
          calCount((num1digit2 + num2digit2)) > 1) carry = true;
    } else  {
      options = 'tripleDigitWithoutCarry';
      num1digit3 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit2 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit1 = num1 % 10;
      num2digit3 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit2 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit1 = num2 % 10;
       if (calCount((num1digit1 + num2digit1)) > 1 || calCount((num1digit3 + num2digit3)) > 1||
          calCount((num1digit2 + num2digit2)) > 1) carry = true;
    } 
  }

  void reminderS(sum) {
    while (sum != 0) {
      num rem = sum % 10;
      sum = sum ~/ 10;
      reminder.add(rem);
    }
  }

  int calCount(sum) {
    print(sum);
    int count = 0;
    if (sum > 1) {
      while (sum != 0) {
        sum = sum ~/ 10;
        ++count;
      }
      return count;
    } else {
      return count = 1;
    }
  }

  @override
  void didUpdateWidget(CalculateTheNumbers oldWidget) {
    // print(oldWidget.iteration);
    //  print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  void _myAnim() {
    animationShake.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
    print('Pushed the Button');
  }

  void wrongOrRight(String text, String output, sum) {
    if (text == '✔') {
      try {
        if (int.parse(output) == result) {
          setState(() {
            _output = output;
          });
          widget.onScore(1);
          widget.onProgress(1.0);
          if (int.parse(output) == sum) {
            new Future.delayed(const Duration(milliseconds: 1000), () {
              _output = ' ';
              flag = false;
              widget.onEnd();
            });
          }
        } else {
          shake = false;
          print("Entering wrong data");

          new Future.delayed(const Duration(milliseconds: 900), () {
            setState(() {
              _output = " ";
              flag = false;
              shake = true;
            });
            // animationController.stop();
          });
        }
      } on FormatException {}
    }
    if (text == '✖') {
      print("Erasing content: " + output);
      if (_output.length > 0) {
        try {
          setState(() {
            _output = _output.substring(0, _output.length - 1);
          //  flag = false;
          });
        } on FormatException {}
      }
    }
  }

  bool _zeoToNine(String text) {
    if (text == '1' ||
        text == '2' ||
        text == '3' ||
        text == '4' ||
        text == '5' ||
        text == '6' ||
        text == '7' ||
        text == '8' ||
        text == '9' ||
        text == '0') {
      return true;
    } else
      return false;
  }

  void operation(String text) {
    if (_zeoToNine(text) == true) {
      if (_output.length < 3) {
        _preValue = text;
        _output = _output + _preValue;
        print(_output);
        setState(() {
          if (int.parse(_output) == result) {
            _output;
            flag = true;
            print("OUTPUT: " + _output);
          }
        });
      } else {
        setState(() {
          flag = false;
        });
      }
    }
    wrongOrRight(text, _output, result);
  }

  Widget _buildItem(int index, String text, double _height) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
  height: _height,
        onPress: () {
          operation(text);
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    switch (options) {
      case 'one':
        return new LayoutBuilder(builder: (context, constraints) {
          double height = constraints.minHeight;
          var j = 0;
          return new Container(
             color: new Color(0XFFFFF7EBCB),
                      child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                      padding: constraints.maxHeight > constraints.maxWidth
                          ? new EdgeInsets.all(height * 0.05)
                          : new EdgeInsets.all(height * 0.1),
                      child: new Table(
                        defaultColumnWidth: new FractionColumnWidth(0.25),
                        children: <TableRow>[
                          new TableRow(children: <Widget>[
                            new Container(child: new Center(child: new Text(" "))),
                            new Container(
                                key: new Key('num1'),
                                 color: new Color(0XFFFF52C5CE),
                                child: new Center(
                  child: new Text("$num1",
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: constraints.minHeight * 0.09,
                        // fontWeight: FontWeight.bold,
                      )))),
                          ]),
                          new TableRow(children: <Widget>[
                            new Container(
                                key: new Key('_operator'),
                                  color: new Color(0XFFFF52C5CE),
                                child: new Center(
                  child: new Text(_operator,
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: constraints.minHeight * 0.09,
                        //  fontWeight: FontWeight.bold,
                      )))),
                            new Container(
                                key: new Key('num2'),
                                 color: new Color(0XFFFF52C5CE),
                                child: new Center(
                  child: new Text("$num2",
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: constraints.minHeight * 0.09,
                        // fontWeight: FontWeight.bold,
                      )))),
                          ]),
                          new TableRow(children: <Widget>[
                            new Container(child: new Center(child: new Text(" "))),
                            new Shake(
                                animation:
                  shake == false ? animationShake : animation,
                                child: new Container(
                                  key: new Key('_output'),
                                  color: flag == true ? Colors.green : Colors.red,
                                  child: new Center(
                    child: new Text(_output,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: constraints.minHeight * 0.09,
                          // fontWeight: FontWeight.bold,
                        ))),
                                )),
                          ]),
                        ],
                      ),
                    ),
                ),
                new Expanded(
                  child: new Container(
                    color: new Color(0XFFFFF7EBCB),
                    child: new ResponsiveGridView(
                      rows: _size + 1,
                      cols: _size,
                      mainAxisSpacing:
                          constraints.maxHeight > constraints.maxWidth
                              ? 4.0
                              : 1.0,
                      crossAxisSpacing:
                          constraints.maxHeight > constraints.maxWidth
                              ? 4.0
                              : 5.0,
                      childAspectRatio:
                          constraints.maxHeight > constraints.maxWidth
                              ? 0.6
                              : 0.24,
                      // childAspectRatio: 0.6,
                      children: _numbers
                          .map((e) => _buildItem(j++, e,constraints.minHeight))
                          .toList(growable: false),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
        break;

      case 'doubleDigitWithoutCarry':
        return new LayoutBuilder(builder: (context, constraints) {
          double height = constraints.minHeight;
          var j = 0;
          return new Column(
            children: <Widget>[
              new Expanded(
                child: new Table(
                  defaultColumnWidth: new FractionColumnWidth(0.2),
                  children: <TableRow>[
                    new TableRow(children: <Widget>[
                      new Container(
                          // key: new Key('num1'),
                        //  color:
                            //  carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                          color:
                              carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                          color:
                              carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                    ]),
                    new TableRow(children: <Widget>[
                      new Container(child: new Center(child: new Text(" "))),
                      new Container(
                          // key: new Key('num1'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num1digit1",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num1digit2",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                    ]),
                    new TableRow(children: <Widget>[
                      new Container(
                          // key: new Key('_operator'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text(_operator,
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    //  fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          //  key: new Key('num2'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num2digit1",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          //  key: new Key('num1'),
                         color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num2digit2",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight *  0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                    ]),
                    new TableRow(children: <Widget>[
                      //   new Container(child: new Center(child: new Text(" "))),
                      new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            //   key: new Key('_output'),
                            color:
                                flag == true ? Colors.green : Colors.tealAccent,
                            child: new Center(
                                child: new Text(' ',
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                      new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            // key: new Key('_output'),
                            color:
                                flag == true ? Colors.green : Colors.tealAccent,
                            child: new Center(
                                child: new Text(' ',
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: constraints.minHeight *  0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                      new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            // key: new Key('_output'),
                            color:
                                flag == true ? Colors.green : Colors.tealAccent,
                            child: new Center(
                                child: new Text(_output,
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: constraints.minHeight *  0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                    ]),
                  ],
                ),
              ),
              new Expanded(
                child: new Container(
                  // color: Color.fromARGB(247, 235, 203),
                  child: new ResponsiveGridView(
                    rows: _size + 1,
                    cols: _size,
                    mainAxisSpacing:
                        constraints.maxHeight > constraints.maxWidth
                            ? 4.0
                            : 1.0,
                    crossAxisSpacing:
                        constraints.maxHeight > constraints.maxWidth
                            ? 4.0
                            : 5.0,
                    childAspectRatio:
                        constraints.maxHeight > constraints.maxWidth
                            ? 0.6
                            : 0.24,
                    // childAspectRatio: 0.6,
                    children: _numbers
                        .map((e) => _buildItem(j++, e,constraints.minHeight))
                        .toList(growable: false),
                  ),
                ),
              ),
            ],
          );
        });
        break;
      default:
        return new LayoutBuilder(builder: (context, constraints) {
          double height = constraints.minHeight;
          var j = 0;
          return new Column(
            children: <Widget>[
              new Expanded(
                child: new Table(
                  defaultColumnWidth: new FractionColumnWidth(0.2),
                  children: <TableRow>[
                    new TableRow(children: <Widget>[
                     new Container(
                          // key: new Key('num1'),
                          color:
                            carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                          color:
                            carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                           color:
                            carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                     fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                          color:
                            carry == true ? Colors.limeAccent : Colors.white,
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                    ]),
                    new TableRow(children: <Widget>[
                      new Container(
                          // key: new Key('num1'),
                        color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text(" ",
                                  style: new TextStyle(
                                    color: Colors.black,
                                       fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                     new Container(
                          // key: new Key('num1'),
                        color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num1digit1",
                                  style: new TextStyle(
                                    color: Colors.black,
                                       fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                         color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num1digit2",
                                  style: new TextStyle(
                                    color: Colors.black,
                                       fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                        color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num1digit3",
                                  style: new TextStyle(
                                    color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                     
                    ]),
                    new TableRow(children: <Widget>[
                      new Container(
                          // key: new Key('_operator'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text(_operator,
                                  style: new TextStyle(
                                    color: Colors.black,
                                       fontSize: constraints.minHeight * 0.09,
                                    //  fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          //  key: new Key('num2'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num2digit1",
                                  style: new TextStyle(
                                    color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          //  key: new Key('num1'),
                          color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num2digit2",
                                  style: new TextStyle(
                                    color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                      new Container(
                          // key: new Key('num1'),
                         color: new Color(0XFFFF52C5CE),
                          child: new Center(
                              child: new Text("$num2digit3",
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: constraints.minHeight * 0.09,
                                    // fontWeight: FontWeight.bold,
                                  )))),
                    ]),
                    new TableRow(children: <Widget>[
                     new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            //   key: new Key('_output'),
                            color: flag == true
                                ? Colors.green
                                : Colors.tealAccent,
                            child: new Center(
                                child: new Text(_output,
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                      new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            //   key: new Key('_output'),
                            color: flag == true
                                ? Colors.green
                                : Colors.tealAccent,
                            child: new Center(
                                child: new Text(_output,
                                    style: new TextStyle(
                                      color: Colors.black,
                                    fontSize: constraints.minHeight * 0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                      new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            // key: new Key('_output'),
                            color: flag == true
                                ? Colors.green
                                : Colors.tealAccent,
                            child: new Center(
                                child: new Text(_output,
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: constraints.minHeight * 0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                      new Shake(
                          animation:
                              shake == false ? animationShake : animation,
                          child: new Container(
                            //   key: new Key('_output'),
                            color: flag == true
                                ? Colors.green
                                : Colors.tealAccent,
                            child: new Center(
                                child: new Text(_output,
                                    style: new TextStyle(
                                      color: Colors.black,
                                     fontSize: constraints.minHeight * 0.09,
                                      // fontWeight: FontWeight.bold,
                                    ))),
                          )),
                    ]),
                  ],
                ),
              ),
              new Expanded(
                child: new Container(
                  color: Colors.white,
                  child: new ResponsiveGridView(
                    rows: _size + 1,
                    cols: _size,
                    mainAxisSpacing:
                        constraints.maxHeight > constraints.maxWidth
                            ? 4.0
                            : 1.0,
                    crossAxisSpacing:
                        constraints.maxHeight > constraints.maxWidth
                            ? 4.0
                            : 5.0,
                    childAspectRatio:
                        constraints.maxHeight > constraints.maxWidth
                            ? 0.6
                            : 0.24,
                    // childAspectRatio: 0.6,
                    children: _numbers
                        .map((e) => _buildItem(j++, e,constraints.minHeight))
                        .toList(growable: false),
                  ),
                ),
              ),
            ],
          );
        });

        break;
    }
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text,this.height,this.onPress}) : super(key: key);
  final String text;
  bool flag;
  double height;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller;
  Animation<double> animation;
 // double _height;

  @override
  initState() {
    super.initState();
    _displayText = widget.text;
  //  _height=widget.height;
    //  print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        // print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          //  print('dismissed');
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text.isEmpty && widget.text.isNotEmpty) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }

  }

  @override
  Widget build(BuildContext context) {
    return new ScaleTransition(
        scale: animation,
        child: new RaisedButton(
            onPressed: () => widget.onPress(),
            color: Colors.orangeAccent,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    new BorderRadius.all(new Radius.circular(widget.height*0.09))),
            child: new Center(
              child: new Text(_displayText,
                  style: new TextStyle(color: Colors.black, fontSize:widget.height*0.05)),
            )));
  }
}
