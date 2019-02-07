import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MoveContainer extends StatefulWidget {
   int coinCount;
  List<int> starValue;
  int index;
  Offset offset;
  final AnimationController animationController;
  final double duration;
  int starCount;

  MoveContainer(
      {Key key,
      this.index,
      this.coinCount,
      this.offset,
      this.starValue,
      this.starCount,
      this.animationController,
      this.duration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyMoveContainer();
  }
}

class _MyMoveContainer extends State<MoveContainer>
    with TickerProviderStateMixin {
  GlobalKey _globalKey2 = new GlobalKey();
  Animation<Offset> rotate;
  Animation<double> _width;
  Animation<double> _height;
  List<Offset> _offsetOffAllDottedCircle = [];
  AnimationController _controller;
  Animation<EdgeInsets> movement;
  Animation<Offset> _offset;
  Offset begin = Offset(0.0, 0.0);
  Offset end = Offset(100, 200.0);
  double myEnd;
  Offset local;
  var countOpacity = 1.0;
  var size = 0.0;
  var extraSize = 0.0;
  double ending;
  int index = 100;
  double animationDuration = 0.0;
  bool animeDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((s) {
      _afterLayout();
    });

    // start = (widget.duration * widget.starCount) * 3.toDouble();
    // ending = (start + widget.duration) * 2500;
    // Offset endOffset = Offset(ending, 0.0);
    final int totalDuration = 2000;
    _controller = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));
    animationDuration = totalDuration / (100 * (totalDuration / widget.index));

    _width = Tween<double>(
      begin: 0,
      end: 50,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    _width.addListener(() {
      // print(
          // "start issssssssssssssssssssssssssssssssssssssssssssssssssssssssssss  ${_controller.value}");
      if (_controller.value < 0.3) {
        extraSize = extraSize;
      } else if (_controller.value > 0.3 && _controller.value < 0.35) {
        extraSize = extraSize + 4;
      } else if (_controller.value > 0.35 && _controller.value < 0.6) {
        extraSize = extraSize + .5;
      } else if (_controller.value > 0.6 && _controller.value < .7) {
        extraSize = extraSize - 1.5;
      } else {
        extraSize = extraSize - 2.5;
      }
      // setState(() {
      // extraSize = _controller.value > 0.3 ? _width.value + _controller.value + 4 : ;
      // });
    });
    _controller.forward();

    _controller.addStatusListener((status) {
      if (_controller.isCompleted) {
        setState(() {
          animeDone = true;
           widget.coinCount = widget.starCount;
        });
      }
    });
  }

  void _afterLayout() {
    final RenderBox renderBoxRed =
        _globalKey2.currentContext.findRenderObject();
    Offset offset = -renderBoxRed.globalToLocal(Offset.zero);
    begin = offset;
    // print("ofsetsssssssssssssssssssssssssssisss  $begin");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double start = (animationDuration * widget.index).toDouble();
    // myEnd = (start + widget.duration).toDouble();
    Size media = MediaQuery.of(context).size;

    return !animeDone
        ? AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Stack(
                children: <Widget>[
                  _Animated(
                    scale: Tween<Offset>(
                            begin: begin / 100, end: (widget.offset) / 100)
                        .animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          start,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    ),
                    child: Container(
                      key: _globalKey2,
                      height: media.height * 0.1 + extraSize,
                      width: media.width * 0.12 + extraSize,
                      //  transform: Matrix4.identity()..rotateZ(_offset.value.dx*extraSize2),
                      child: FlareActor(
                        "assets/coin.flr",
                        // animation: "rotate",
                      ),
                    ),
                  ),
                ],
              );
            })
        : new Container(
            height: media.height * .15,
            child: Center(
                child: Text("Excellent",
                    style: TextStyle(
                        fontSize: 60.0, fontWeight: FontWeight.w900))),
          );
  }
}

class _Animated extends AnimatedWidget {
  final Widget child;
  _Animated({
    Key key,
    this.child,
    Animation<Offset> scale,
  }) : super(key: key, listenable: scale);
  Animation<Offset> get listenable => super.listenable;
  double get translateX {
    double x = listenable.value.dx * 100;
    double val = x;
    // print(x);
    // final val = sin(x / 2) * 100;
    // double val = -sqrt(-x * 2) * 50;

    return val;
  }

  double get translateY {
    double val = listenable.value.dy * 100;
    // print(listenable.value);
    return val;
  }

  double get translateZ {
    double val = listenable.value.dx * 100;
    // print(val);
    // print(-listenable.value.dx);
    if (val <= 1.0)
      return 1.0;
    else
      return val;
  }

  @override
  Widget build(BuildContext context) {
    return _SingleChild(
      child: child,
      offset: Offset(
        translateZ,
        translateY,
      ),
    );
  }
}

class _SingleChild extends SingleChildRenderObjectWidget {
  final Widget child;
  final Offset offset;
  _SingleChild({this.child, this.offset}) : super(child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    print('redner box');
    return _RenderObject(offset: offset);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderObject renderObject) {
    super.updateRenderObject(context, renderObject..offsetUpdate = offset);
  }
}

class _RenderObject extends RenderProxyBox {
  final Offset offset;
  _RenderObject({RenderBox child, this.offset})
      : assert(offset != null),
        _offset = offset,
        super(child);
  Offset _offset;

  set offsetUpdate(Offset of) {
    _offset = of;
    markNeedsPaint();
  }

  @override
  void paint(context, offset) {
    if (child != null) {
      offset = _offset;
      context.paintChild(child, offset);
    }
  }
}
