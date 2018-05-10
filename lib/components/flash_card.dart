import 'package:flutter/material.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:meta/meta.dart';

class FlashCard extends StatefulWidget {
  final String text;
  final VoidCallback onChecked;

  FlashCard({Key key, @required this.text, this.onChecked}) : super(key: key);

  @override
  _FlashCardState createState() {
    return new _FlashCardState();
  }
}

class _FlashCardState extends State<FlashCard> {
  Unit _unit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _unit = await new UnitRepo().getUnit(widget.text);
    setState(() => _isLoading = false);
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
    return new LayoutBuilder(builder: (context, constraints) {
      return new Card(
          color: Colors.purple,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.volume_up),
                    iconSize: constraints.maxHeight * 0.18,
                    color: Colors.white,
                    onPressed: () =>
                        AppStateContainer.of(context).play(widget.text)),
                new Row(
                  children: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.arrow_left),
                        onPressed: widget.onChecked,
                        iconSize: constraints.maxHeight * 0.15,
                        color: Colors.white),
                    new Expanded(child
                        : new Image.asset('assets/apple.png')),
                    new IconButton(
                        icon: new Icon(Icons.arrow_right),
                        onPressed: widget.onChecked,
                        iconSize: constraints.maxHeight * 0.15,
                        color: Colors.white,)
                  ],
                ),
                new Container(
                    height: constraints.maxHeight * 0.2 ,
                    width: constraints.maxWidth * 0.9,
                    alignment: const Alignment(0.0, 0.0),
                    padding: const EdgeInsets.all(8.0),
                    margin: new EdgeInsets.all(constraints.maxHeight * 0.04),
                    decoration: new BoxDecoration(
                        color: Colors.amber,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(constraints.maxHeight * 0.015)),
                        shape: BoxShape.rectangle),
                    child: new Text(_unit?.name ?? widget.text,
                        style: new TextStyle(color: Colors.white, fontSize: constraints.maxHeight * 0.15))),
              ]));
    });
  }}
