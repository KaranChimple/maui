import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/count_animation.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';

import 'package:maui/state/button_state_container.dart';

class Counting extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Counting(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  CountingState createState() => CountingState();
}

class CountingState extends State<Counting> {
  int rndVal = Random().nextInt(9 - 0);
  List<String> _letters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  int value;
  int countVal = 0;
  var selectedIndex = [];
  Animation<double> animationtweenans;
  AnimationController controllert1;

  int code;
  bool _isLoading = true;
  String img, dragdata;
  int dindex, dcode;
  List<bool> _isDropped = new List();
  List randomData = new List();
  List datavalues = new List();
  List anschecking = new List();
  var checkdata;
  List droptargetValues = new List();
  initState() {
    super.initState();
    initfn();
  }

  initfn() {
    setState(() => _isLoading = true);
    String ansData = (rndVal + 1).toString();
    datavalues = ansData.split('');
    datavalues.forEach((e) {
      anschecking.add(e);
    });
    checkdata = datavalues;
    int temp = 0;
    while (temp < datavalues.length) {
      if (temp < datavalues.length) _isDropped.add(false);
      droptargetValues.add(null);
      temp++;
    }

    var rng = new Random();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, datavalu) {
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      code: code,
      onDrag: () {
        setState(() {});
      },
      isRotated: widget.isRotated,
      text: text,
      onAccepted: (data) {
        dragdata = data;
        String valueText =
            dragdata.substring(dragdata.length - 1, dragdata.length);

        dindex = int.parse(dragdata.substring(0, 3));
        dcode = int.parse(dragdata.substring(4, 7));

        if (code == dcode && valueText == datavalu) {
          int findex = dindex - 100;
          if (valueText == datavalu) {
            //right

            setState(() {
              _isDropped[index] = true;
              droptargetValues[index] = _letters[findex];
            });
          } else if (_isDropped[index] == false) {
            // wrong
          } else if (_isDropped[index] == true) {
            // do nothing;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    randomData = [rndVal.toString()];
    for (int i = 0; i < rndVal + 1; i++) {
      selectedIndex.add(0);
    }
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = 0.0, maxHeight = 0.0;
      maxWidth = (constraints.maxWidth - hPadding * 2) / 5;
      maxHeight = (constraints.maxHeight - vPadding * 2) / 5;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      int inc = 0;
      int k = 100;
      return Column(children: <Widget>[
        Text("Count the fruit and drag the Numbers in the blocks",
            style: TextStyle(color: Colors.black, fontSize: 20.0)),
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
                child: GridView.builder(
                    itemCount: rndVal + 1,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: CountAnimation(
                            key: new ValueKey<int>(index),
                            index: index,
                            rndVal: rndVal,
                            selectedIndex: selectedIndex,
                            countVal: countVal),
                      );
                    })),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.black38,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: Column(children: [
              new Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: ResponsiveGridView(
                        rows: 1,
                        cols: 4,
                        children: droptargetValues
                            .map((e) => Padding(
                                padding: EdgeInsets.all(4.0),
                                child: _buildItem(inc, e, anschecking[inc++])))
                            .toList(growable: false)),
                  )),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: new ResponsiveGridView(
                      rows: 2,
                      cols: 5,
                      children: _letters
                          .map((e) => Padding(
                              padding: EdgeInsets.all(4.0),
                              child: _buildItem(k++, e, '')))
                          .toList(growable: false)),
                ),
              ),
            ]),
          ),
        ),
      ]);
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.code,
      this.isRotated,
      this.img,
      this.onDrag,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  final DragTargetAccept onAccepted;
  final keys;
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String newtext = '';
  String disptext;
  initState() {
    super.initState();
    // disptext = widget.text == null ? '' : widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -3.0, end: 3.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    if (widget.index < 100) {
      return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.flag == 1 ? animation1 : animation,
            child: new ScaleTransition(
                scale: animation,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: new DragTarget(
                    onAccept: (String data) => widget.onAccepted(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return widget.text == null
                          ? UnitButton(
                              text: '',
                            )
                          : UnitButton(
                              text: widget.text,
                            );
                    },
                  ),
                ))),
      );
    } else if (widget.index >= 100) {
      return new Draggable(
        onDragStarted: widget.onDrag,
        data:
            '${widget.index}' + '_' + '${widget.code}' + '_' + '${widget.text}',
        child: new ScaleTransition(
            scale: animation,
            child: new UnitButton(
              key: new Key('A${widget.keys}'),
              text: widget.text,
              showHelp: false,
            )),
        feedback: UnitButton(
          text: widget.text,
          maxHeight: buttonConfig.height,
          maxWidth: buttonConfig.width,
          fontSize: buttonConfig.fontSize,
        ),
      );
    }
  }
}