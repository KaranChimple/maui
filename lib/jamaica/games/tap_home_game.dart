import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';

class TapHome extends StatefulWidget {
  final String answer;
  final List<String> choices;
  final OnGameOver onGameOver;

  TapHome({
    key,
    this.answer,
    this.choices,
    this.onGameOver,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TapState();
}

class _TapState extends State<TapHome> with TickerProviderStateMixin {
  Animation _animation, _animationTimer, _screenAnim;
  AnimationController _animationController,
      _animTimerController,
      _screenController;
  int count = 0, score = 0;
  bool _isLoading = true;
  List<String> _option;
  String _answer;
  double _status = 1.0;

  @override
  void initState() {
    super.initState();
    _animTimerController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 10));

    _animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);

    _animation = new Tween(begin: 0.0, end: 15.0).animate(_animationController);

    _animationTimer =
        new StepTween(begin: 0, end: 7).animate(_animTimerController);

    _screenController = new AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _screenController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animTimerController.stop();
        });
        new Future.delayed(const Duration(milliseconds: 1000), () {
          print('calling onEnd');
          widget.onGameOver(1);
        });
      }
    });

    _animationTimer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("count $count");
        _animTimerController.forward(from: 0.0);
        if (count > 3) {
          setState(() {
            _status = 0.0;
          });
          _screenController.forward(from: 0.0);
        } else {
          setState(() {
            count = count + 1;
          });
          print("elsecount $count");
        }
      }
    });

    _screenAnim = new Tween(begin: 0.0, end: 2255.0).animate(_screenController);

    _initBoard();
  }

  void _initBoard() async {
    count = 0;
    _status = 1.0;
    setState(() => _isLoading = true);
    _animation = new Tween(begin: 0.0, end: 15.0).animate(_animationController);
    _option = widget.choices;
    _answer = widget.answer;
    print("data is coming $_option");
    _myAnim1();
    setState(() => _isLoading = false);
  }

  //used for shaking animation
  void _myAnim() {
    _animTimerController.stop();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
    print('Pushed the Button');
  }

  //used for changing the number at proper interval
  void _myAnim1() {
    _animTimerController.forward(from: 0.0);
    print('Pushed the Button');
  }

  //this function is used for matching on tap
  void _clickText() {
    if (_answer == _option[_animationTimer.value]) {
      _animTimerController.stop();
      widget.onGameOver(1);
      setState(() {
        score = score + 4;
        _status = 0.0;
      });

      _screenController.forward(from: 0.0);
    } else {
      if (score > 0) {}
      setState(() {
        count = count + 1;
        score = score > 0 ? score - 1 : score;
      });
      _myAnim();
      new Future.delayed(const Duration(milliseconds: 1000), () {
        _animationController.stop();
        if (count == 4) {
          setState(() {
            _status = 0.0;
          });
          _screenController.forward(from: 0.0);
        }
        _animTimerController.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print("this is  data");
      print(constraints.maxHeight);
      print(constraints.maxWidth);
      double _height, _width;
      _height = constraints.maxHeight;
      _width = constraints.maxWidth;
      if (_isLoading) {
        return new SizedBox(
          width: 20.0,
          height: 20.0,
          child: new CircularProgressIndicator(),
        );
      }

      return new Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: new Stack(alignment: Alignment.topCenter, children: <Widget>[
            new Column(children: <Widget>[
              new GestureDetector(
                  key: new Key('tap'),
                  onTap: _clickText,
                  child: new Countdown(
                      animation: _animationTimer,
                      height: _height,
                      option: _option))
            ]),
            new TextAnimation(
                animation: _status == 0.0 ? _screenAnim : _animation,
                text: _answer.toString(),
                height: _height,
                width: _width,
                status: _status)
          ]));
    });
  }

  dispose() {
    _animationController.dispose();
    _animTimerController.dispose();
    super.dispose();
  }
}

class TextAnimation extends AnimatedWidget {
  TextAnimation(
      {Key key,
      Animation animation,
      this.text,
      this.height,
      this.width,
      this.status})
      : super(key: key, listenable: animation);
  final String text;
  final double height, width, status;

  @override
  Widget build(BuildContext context) {
    Animation _animation = listenable;
    return new Container(
        height:
            _animation.value < height * 0.4 ? height * 0.4 : _animation.value,
        width: _animation.value < width ? width : _animation.value,
        color: new Color(0xFFFFDC48),
        padding: status == 1.0
            ? new EdgeInsets.only(left: _animation.value ?? 0)
            : null,
        alignment: Alignment.center,
        child: new Text(text,
            key: new Key('question'),
            style: new TextStyle(
              color: new Color(0xFF42AD56E),
              fontSize: height * 0.18,
              fontWeight: FontWeight.bold,
            )));
  }
}

class Countdown extends AnimatedWidget {
  Countdown(
      {Key key,
      this.animation,
      this.height,
      this.width,
      this.option,
      this.status})
      : super(key: key, listenable: animation);
  Animation<int> animation;
  double height, width, status;
  List<String> option;

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: height * 0.35,
        width: height * 0.35,
        alignment: Alignment.center,
        margin: new EdgeInsets.only(top: height * 0.52),
        decoration: new BoxDecoration(
            border: new Border.all(
                color: new Color(0xFF42AD56), width: height * 0.01),
            shape: BoxShape.circle),
        child: new Text(option[animation.value].toString(),
            key: new Key('answer'),
            style: new TextStyle(
                fontSize: height * 0.15,
                fontWeight: FontWeight.w500,
                color: new Color(0xFF42AD56))));
  }
}
