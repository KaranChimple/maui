import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/state/app_state_container.dart';
import '../actions/deduct_points.dart';
import 'package:nima/nima_actor.dart';

class DrawingLock extends StatefulWidget {
  final Tile tile;
  DrawingLock({Key key, this.tile}) : super(key: key);

  @override
  State createState() {
    return new DrawingLockState();
  }
}

class DrawingLockState extends State<DrawingLock> {
  int initialPoints;
  void _goToDrawing(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => DrawingWrapper(
              activityId: widget.tile.cardId,
              drawingId: widget.tile.id,
            )));
  }

  void onPressed() {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogContent(
              onPressed: onPressed,
              initialPoints: initialPoints + 1,
              shouldDisplayNima: true);
        },
        barrierDismissible: false);
    new Future.delayed(const Duration(seconds: 4), () {
      _goToDrawing(context);
    });

    Provider.dispatch<RootState>(context, DeductPoints(points: 1));
  }

  @override
  Widget build(BuildContext context) {
    initialPoints = AppStateContainer.of(context).state.loggedInUser.points;
    return widget.tile.updatedAt == null
        ? InkWell(
            onTap: () => initialPoints < 3
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogContent(
                          onPressed: onPressed,
                          initialPoints: initialPoints,
                          shouldDisplayNima: true);
                    },
                    barrierDismissible: false)
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogContent(
                          onPressed: onPressed,
                          initialPoints: initialPoints,
                          shouldDisplayNima: false);
                    }),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                constraints: BoxConstraints.expand(),
                alignment: AlignmentDirectional(1.2, -1.2),
//                    color: Color(0x99999999),
                child: Icon(
                  Icons.lock,
                  color: Colors.blue,
                  size: 24.0,
                ),
              ),
            ),
          )
        : Container();
  }
}

class DialogContent extends StatelessWidget {
  final VoidCallback onPressed;
  final bool shouldDisplayNima;
  final int initialPoints;
  DialogContent(
      {Key key, this.onPressed, this.shouldDisplayNima, this.initialPoints})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    return Connect<RootState, int>(
        convert: (state) => state.user.points,
        where: (prev, next) {
          return next != prev;
        },
        builder: (points) {
          if (initialPoints < 3) {
            new Future.delayed(const Duration(seconds: 4), () {
              Navigator.of(context).pop();
            });
          }
          return new Center(
            child: Material(
              type: MaterialType.transparency,
              child: new Container(
                height: size.height * 0.3,
                width: size.width * 0.7,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(25.0),
                ),
                child: Container(
                  child: new Column(
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.blue,
                          borderRadius: new BorderRadius.only(
                              topLeft: new Radius.circular(20.0),
                              topRight: new Radius.circular(20.0)),
                        ),
                        height: 60.0,
                        width: size.width * 0.7,
                        child: Center(
                          child: new Text(
                            'Your Points-$points',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      shouldDisplayNima
                          ? Container(
                              height: size.height * 0.3 - 90,
                              width: (size.width * 0.7) * 0.5,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 0.5,
                                  child: Container(
                                    height: size.height * 0.25 - 90,
                                    width: (size.width * 0.7) * 0.5,
                                    child: new NimaActor(
                                      "assets/quack",
                                      alignment: Alignment.center,
                                      fit: BoxFit.scaleDown,
                                      animation:
                                          initialPoints > 3 ? 'happy' : 'sad',
                                      mixSeconds: 0.02,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: size.height * 0.3 - 75,
                              width: (size.width * 0.7) * 0.5,
                              child: Center(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Center(
                                        child: new Text(
                                      "Cost is - 3",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        // margin: EdgeInsets.only(top: 80.0),
                                        width: ((size.width * 0.7) * 0.5) / 1.8,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.blue),
                                        child: new FlatButton(
                                          onPressed: onPressed,
                                          child: Center(
                                            child: Text(
                                              "Buy",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}