import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Side { left, right }

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {@required this.animation,
      @required this.child,
      this.side = Side.left,
      this.imageFile,
      this.imageUrl,
      this.imageAsset,
      this.isFile = true});
  final Animation animation;
  final Widget child;
  final Side side;
  final String imageUrl;
  final String imageFile;
  final String imageAsset;
  final bool isFile;

  Widget build(BuildContext context) {
    var image = imageFile != null
        ? new FileImage(new File(imageFile))
        : imageAsset != null
            ? new AssetImage(imageAsset)
            : isFile
                ? NetworkImage(imageUrl)
                : MemoryImage(base64.decode(imageUrl));
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: side == Side.left
            ? new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: new CircleAvatar(backgroundImage: image),
                  ),
                  new Flexible(
                      child: new Card(
                    color: Theme.of(context).accentColor,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: child,
                  )),
                ],
              )
            : new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Card(
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: child,
                  ),
                  new Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: new CircleAvatar(backgroundImage: image),
                  ),
                ],
              ),
      ),
    );
  }
}
