import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';

class TrueFalseGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;


  TrueFalseGame({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId, this.isRotated}) : super(key: key);
  
  @override
  State createState() => new TrueFalseGameState();
}

class TrueFalseGameState extends State<TrueFalseGame> {
  bool _isLoading = true;
 
 Tuple2<String, bool> _allques;
  String questionText;
  bool tf;
  bool isCorrect;
  bool overlayShouldBeVisible = false;
  int scoretrack = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(()=>_isLoading=true);
    _allques =  await fetchTrueOrFalse(widget.gameCategoryId);
    print("this is my data  $_allques");
    print(_allques.item1);
    questionText = _allques.item1;
    print(_allques.item2);
    tf = _allques.item2;
    setState(()=>_isLoading=false);
  }

  void handleAnswer(bool answer) {
    isCorrect = (tf == answer);
    if (isCorrect) {
      scoretrack = scoretrack + 4;
      widget.onScore(4);
      widget.onProgress(1.0);
    } else {
      if(scoretrack > 0){        
      scoretrack = scoretrack - 1;
      widget.onScore(-1);
      } else {
        widget.onScore(0);
      }
    }
    this.setState(() {
      print(4);
      overlayShouldBeVisible = true;
    });
  }
  
    @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    print("Question text here $questionText");
    print("Answer here $tf");

    if(_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }    

    return new LayoutBuilder(builder: (context, constraints)
    {
      double ht=constraints.maxHeight;
      double wd = constraints.maxWidth;
      print("My Height - $ht");
      print("My Width - $wd");
      return new Material(
      child: new Stack(
      fit: StackFit.loose,
      children: <Widget>[
        new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
          
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Expanded(
                  child:   new QuestionText(questionText, ht, wd),
                )
              ]
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                  new Padding(
                    padding: new EdgeInsets.all(wd * 0.015),
                  ),

                  new AnswerButton(true, () => handleAnswer(true), ht, wd), //true button

                  new Padding(
                    padding: new EdgeInsets.all(wd * 0.015),
                  ),

                  new AnswerButton(false, () => handleAnswer(false), ht, wd), //false button

                  new Padding(
                    padding: new EdgeInsets.all(wd * 0.015),
                  ),

                ]
            ),
          ],
        ),
        

        overlayShouldBeVisible == true ? new Container(
          height: ht,
          width: wd,
          child: new CorrectWrongOverlay(
            isCorrect,
                () {                     
              this.setState(() {
                print(1);
                overlayShouldBeVisible = false;
              }); 
              new Future.delayed(const Duration(milliseconds: 20), () {
                widget.onEnd();
                _initBoard();
              });         
            }
        )) : new Container()
      ],
    ),
    );
    });
  }
    
}


class QuestionText extends StatefulWidget {

  final String _question;
  double ht, wd;

  QuestionText(this._question, this.ht, this.wd);

  @override
  State createState() => new QuestionTextState();
}

class QuestionTextState extends State<QuestionText> with SingleTickerProviderStateMixin {

  Animation<double> _fontSizeAnimation;
  AnimationController _fontSizeAnimationController;

  @override
  void initState() {
    super.initState();
    _fontSizeAnimationController = new AnimationController(duration: new Duration(milliseconds: 500), vsync: this);
    _fontSizeAnimation = new CurvedAnimation(parent: _fontSizeAnimationController, curve: Curves.bounceOut);
    _fontSizeAnimation.addListener(() => this.setState(() {print(2);}));
    _fontSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _fontSizeAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuestionText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._question != widget._question) {
      _fontSizeAnimationController.reset();
      _fontSizeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
      return new Material(
      child:  new Container(
        height: widget.ht * 0.3,
        width: widget.ht>widget.wd? widget.wd * 0.6 : widget.wd*0.5,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(25.0),
              color: const Color(0xFFf8c43c),              
              
                ),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ new Text( widget._question,
              style: new TextStyle(color: Colors.white, fontSize: widget.ht>widget.wd? widget.ht*0.06 : widget.wd*0.06, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
                  ),
              ],
              ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {

  final bool _answer;
  final VoidCallback _onTap;
  double ht, wd;

  AnswerButton(this._answer, this._onTap, this.ht, this.wd);

  @override
  Widget build(BuildContext context) {
      return new Expanded( 
      child: new Material(      
        child: new InkWell(
          onTap: () => _onTap(),
          child: new Container( 
                height: ht>wd? ht * 0.35 : ht * 0.43,
                width: wd * 0.6,             
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(25.0),
                  color: _answer == true ? const Color(0xFF64DD17) : const Color(0xFFE53935),
                    
                ),
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Icon(_answer == true ? Icons.check : Icons.close, size: ht>wd? ht*0.15 : wd*0.15, color: Colors.white,),
                      
                    ],
                  )
                ),
              ),
        ),
      ),
    );
  }
}



class CorrectWrongOverlay extends StatefulWidget {

  final bool _isCorrect;
  final VoidCallback _onTap;

  CorrectWrongOverlay(this._isCorrect, this._onTap);

  @override
  State createState() => new CorrectWrongOverlayState();
}

class CorrectWrongOverlayState extends State<CorrectWrongOverlay> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(duration: new Duration(seconds: 2), vsync: this);
    _iconAnimation = new CurvedAnimation(parent: _iconAnimationController, curve: Curves.elasticOut);
    _iconAnimation.addListener(() => this.setState(() {print(3);}));
    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black54,
      child: new InkWell(
        onTap: () => widget._onTap(),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: new Transform.rotate(
                angle: _iconAnimation.value * 2 * PI,
                child: new Icon(widget._isCorrect == true ? Icons.done : Icons.clear, size: _iconAnimation.value * 80.0,),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(bottom: 20.0),
            ),
            new Text(widget._isCorrect == true ? "Correct!" : "Wrong!", style: new TextStyle(color: Colors.white, fontSize: 30.0),)
          ],
        ),
      ),
    );
  }
}