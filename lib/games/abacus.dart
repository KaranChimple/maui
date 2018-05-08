import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'dart:ui' show window;
import 'dart:math';
import 'package:maui/repos/game_data.dart';
import 'package:maui/games/single_game.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';

class Abacus extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
   GameConfig gameConfig;
  bool isRotated;

  Abacus(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
         this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new AbacusState();
}

class AbacusState extends State<Abacus> {
  var quest = 0;
  var result = 0;
  var sum = 0;
  var ia = 0;
  List Check = [];
  final List<String> _allLetters = [
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
    '1',
  ];
  int _size = 4;
  bool _isLoading = true;
  List<String> _shuffledLetters = [];
  List _Index = [];
  List status = [0, 1, 1, 1, 1];
  List<String> _letters;
  Tuple4<int, String, int, int> data;
  final List<String> _allLetters1 = ['', '', '', '', '', ''];
  List flags = [];
  var u = 1;
  var n = 0;
  var m = 0;
  var finalans = 0;
  int count = 0;
  var maxcount = 0;
  List<String> _letters1 = [];

  // var result=0;
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    data = await fetchMathData(widget.gameConfig.gameCategoryId);
    print('data is $data');
    print('data is ${data.item1}');
    var q = data.item4.toString();
    var p = data.item1.toString();

    if (q.length > p.length) {
      _size = q.length;
    } else {
      _size = p.length;
    }
    for (var i = 0; i < 4; i++) {
      _shuffledLetters
          .addAll(_allLetters1.skip(0).take(_size).toList(growable: true));
    }
    print(_shuffledLetters);

    for (var i = 0; i < _allLetters.length; i++) {
      _shuffledLetters
          .addAll(_allLetters.skip(0).take(_size).toList(growable: true));
    }
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _shuffledLetters.length);
    quest = data.item1;
    result = 0;
    //flags=_letters;

    for (var i = 0; i < _letters.length; i++) {
      flags.add('-1');
    }
    print('flags array     $flags');
    finalans = data.item4;
    var x = data.item1;
    var y = data.item2;
    var z = data.item3;
    for (var i = 0; i < _size; i++) {
      _letters[i] = count.toString();
    }
    _letters1.add(x.toString());
    _letters1.add(y.toString());
    _letters1.add(z.toString());
    _letters1.add('=');
    _letters1.add('?');
    print('data in array$_letters1');
    setState(() => _isLoading = false);
    //print(' data from database${fetchMathData(1)}');
  }

  Widget _buildItem(int index, String text,int stat,String flag) {
 Size size=MediaQuery.of(context).size;
    final TextEditingController t1= new TextEditingController(text: text);
    return new MyButton(
      key:new  ValueKey<int>(index),
      text: text,
      index: index,
      screenSize:size.width,
      colorflag: stat,
      size: _size,
      flag:flag,
      onac: (index) {
      
          print('control transfer');
          print('index$index');
          setState(() {
            var val = index;
            _Index.add(val);
            var num1 = _letters[index];
            Check.add(num1);

            print("...............$index,$_Index,$u");

            if (result == finalans && status[4] == 0) {} else {
              for (var i = 0; i < _size; i++) {
                if (_Index[0] % _size == i) {
                  if (Check[0] == '1' && _Index[0] + _size >= _letters.length) {
                    if (_letters[_Index[0] - _size] == '') {
                      if (_Index[0] == _letters.length - _size) {
                        count = int.parse(_letters[i]);
                        count = count + 1;
                        _letters[i] = count.toString();

                        _letters[_Index[0] - (3 * _size)] = '1';
                        _letters[_Index[0]] = '';
                        result = result + pow(10, (_size - 1 - i));
                      } else {
                        count = int.parse(_letters[i]);
                        count = count + 1;
                        _letters[i] = count.toString();

                        _letters[_Index[0] - (3 * _size)] = '1';
                        _letters[_Index[0]] = '';
                        result = result + pow(10, (_size - 1 - i));

                        for (var xx = i; xx > 0; xx--) {
                          count = 0;
                          maxcount = int.parse(_letters[xx]);
                          if (maxcount > 9) {
                            for (var x = xx + _size;
                                x < _letters.length;
                                x = x + _size) {
                              if (count < 3) {
                                _letters[x] = '';
                                count++;
                              } else {
                                flags[x] = '0';
                                _letters[x] = '1';
                              }
                            }
                            count = 0;
                            for (var x = xx + _size - 1;
                                x < _letters.length;
                                x = x + _size) {
                              if (_letters[x] == '') {
                                count++;
                              }
                              if (count == 3) {
                                _letters[x + _size] = '';
                                flags[x - (2 * _size)] = '1';
                                _letters[x - (2 * _size)] = '1';
                              }
                            }

                            _letters[xx] = '0';
                            count = int.parse(_letters[xx - 1]);
                            count = count + 1;
                            _letters[xx - 1] = count.toString();
                          }
                        }
                      }
                    } else {}
                  } else if (Check[0] == '1' &&
                      _letters[_Index[0] + _size] == '1' &&
                      _Index[0] == i) {} else if (Check[0] ==
                          '1' &&
                      _letters[_Index[0] + _size] == '') {
                    flags[_Index[0] + (3 * _size)] = '0';
                    // flags[_Index[0]]='0';
                    _letters[_Index[0]] = '';
                    _letters[_Index[0] + (3 * _size)] = '1';

                    if (i != _size - 1 && _letters[(i + 1 + _size)] == '') {
                      int cnt = 0;
                      for (int vari = (i + 1 + _size);
                          vari < _letters.length;
                          vari = vari + _size) {
                        if (cnt < 10) {
                          _letters[vari] = '1';
                          cnt++;
                          flags[vari] = '1';
                        } else {
                          _letters[vari] = '';
                        }
                      }
                      _letters[i + 1] = '10';
                    } else {
                      result = result - pow(10, (_size - 1 - i));
                    }
                    count = int.parse(_letters[i]);
                    count = count - 1;
                    _letters[i] = count.toString();
                    new Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        var x = flags.length;
                        // flags.removeRange(0, flags.length);
                        for (var i = 0; i < x; i++) {
                          flags[i] = '-1';
                        }
                      });
                    });
                  } else if (Check[0] == '1' &&
                      _letters[_Index[0] - _size] == '') {
                    // flags[_Index[0]]='1';
                    flags[_Index[0] - (3 * _size)] = '1';
                    _letters[_Index[0]] = '';
                    _letters[_Index[0] - (3 * _size)] = '1';
                    result = result + pow(10, (_size - 1 - i));
                    count = int.parse(_letters[i]);
                    count = count + 1;
                    _letters[i] = count.toString();

                    new Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        // flags[_Index[0]]='-1';
                        var x = flags.length;
                        // flags.removeRange(0, flags.length);
                        for (var i = 0; i < x; i++) {
                          flags[i] = '-1';
                        }
                      });
                    });
                  }
                }
              }
            }
            if (result == quest) {
              quest = finalans;
              status[2] = 0;
              status[0] = 1;
              widget.onScore(5);
              if (result == finalans) {
                _letters1[4] = finalans.toString();
                status[2] = 1;
                status[4] = 0;
                widget.onEnd();
                new Future.delayed(const Duration(milliseconds: 1500), () {
                  widget.onEnd();
                });
              }
            }
            _Index = [];
            Check = [];
            print("result==$result");
          });
        });
  }

  @override
  Widget build(BuildContext context) {
     Size size=MediaQuery.of(context).size;
    print("MyTableState.build");
    print("letters1 $_letters1");
    print("letters $_letters");
    print('flagsss      $flags');
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    int k=100;
    int j=0;
   return new Column(
     children: <Widget>[
      //  new Container(
      //    child: new Text('result==$result',style: new TextStyle(color: Colors.red),),
      //  ),
       new Container(
         height: 80.0,
         width: size.width,
         child: new ResponsiveGridView(
           padding:0.0,
           rows: 1,
           cols: 5,
           children: _letters1.map((e) => _buildItem(k, e,status[k++-100],flags[1])).toList(growable: false),
         ),
       ),
       new Container(height: 4.0,
       color: Colors.pink,
       ),
       new Expanded(
         child: new ResponsiveGridView(
          
           padding: 0.0,
          // mainAxisSpacing: 0.0,
          // crossAxisSpacing: 0.0,
           rows: 14,
           cols: _size,
           children: _letters.map((e) => _buildItem(j, e,status[1],flags[j++])).toList(growable: false),
         ),
       ), new Container(height: 4.0,
       color: Colors.pink,
       ),
     ],
   );
  
  }
}

class Shake extends AnimatedWidget {
  const Shake({
    Key key,
    Animation<double> animation,
    this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable;
  double get translateX {
    final double t = animation.value;
    const double shakeDelta = 2.0;
    return t * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.translationValues(0.0, translateX, 0.0),
      child: child,
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text,this.index,this.onac,this.colorflag,this.size,this.flag,this.screenSize}) : super(key: key);
 
  final String text;
  final DragTargetAccept onac;
  final int colorflag;
  final double screenSize;
  String flag;
  final int size;
  List<String> letters;
  int index;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;
  List _Index = [];
  List Check = [];
  int flag = 0;
  String let = '';
  var val = 0;
  var f = 0;
  initState() {
    super.initState();

    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller =new
        AnimationController(duration:new Duration(milliseconds:500), vsync: this);
        controller1 =new
        AnimationController(duration:new Duration(milliseconds:500), vsync: this);
   // animation1 = new CurvedAnimation(parent: controller1, curve: Curves.easeIn);
   animation1= new Tween(begin: -widget.screenSize/10, end: 00.0).animate(controller1)
      ..addStatusListener((state) {
        print("$state:${animation.value}");

        if (state == AnimationStatus.dismissed) {
          controller1.forward();
        }
      }
      );
animation = new Tween(begin: widget.screenSize/10, end: 00.0).animate(controller)
      ..addStatusListener((state) {
        print("$state:${animation.value}");

        if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flag != oldWidget.flag) {
      if (widget.flag == '0') {
        controller1.reset();
        f = 1;
      } else if (widget.flag == '1') {
        controller.reset(); // setState(() => _displayText = widget.text);
        print('workin 1');
      }
    }

    print("_MyButtonState.didUpdateWidget: ${widget.flag} ${oldWidget.flag}");
  }
   @override
  void dispose() {
   
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

var tt=0.0;
  @override
  Widget build(BuildContext context) {
     Size size=MediaQuery.of(context).size;
if(size.height>size.width)
tt=size.width;
else tt=size.height;
    print("_MyButtonState.build");

   if(widget.index>=100){

return  new Center(
   child:  new Container(
    // height: 50.0,
    // width: 50.0,
      decoration: new BoxDecoration(
        color:widget.colorflag!=0? Colors.white30:Colors.yellowAccent,
        shape: BoxShape.rectangle
        
      ), padding: new EdgeInsets.all(10.0),
      child: new Center(child:new Text(widget.text,
      key: new Key(widget.index.toString()+"but"),
       style:new
                            TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20.0))),
    )
  )

;

   }
   else if(widget.index<widget.size){
    return  new Container(
    // height: 50.0,
    // width: 50.0,
      decoration: new BoxDecoration(
        color:Colors.blue,
        shape: BoxShape.rectangle
        
      ), padding: new EdgeInsets.all(10.0),
      child: new Text(widget.text,textAlign: TextAlign.center,
       style:new
                            TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: tt/30 )) ,
    );
   }
   else{
    return  new Center(
           child:    new Container(
           // height: 35.0,
          //   width: 35.0,
           
            child:new Stack( alignment: const Alignment(0.0, 0.0), children: <Widget>[
             
                 new Container(
        //  height: 4000.0,
          width: tt/140,
          color: Colors.black,
        ), //new Column(  
    new Shake(
              animation:widget.flag=='1'?animation:animation1,
               child:new Draggable(
                affinity: Axis.vertical,
                 onDragStarted: ()=>widget.onac(widget.index),
                 child: 
               
  new GestureDetector(
               
  //onVerticalDragEnd: (dynamic)=>widget.onac(widget.index),
             child:  new Container(
               margin: new EdgeInsets.only(top: 5.0),
            // height: 10.0,
           //  width: 10.0,
          decoration:widget.text!=''? new BoxDecoration(
        color: Colors.red[400],
        shape: BoxShape.circle, 
      ):new BoxDecoration(), padding: new EdgeInsets.all(5.0),
                    // child:new Text(widget.text,
                    //     style:new
                    //         TextStyle(color: Colors.white, fontSize: 34.0))),
             ) 
             ),
             feedback: new Container(),
                         //   onDragStarted: ()=>widget.onac(widget.index),
                          
    ))]),));}
  }
}
