import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_comments.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/social_summary.dart';
import 'package:maui/quack/tile_detail.dart';

class TileCard extends StatelessWidget {
  final Tile tile;

  const TileCard({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (tile.type) {
      case TileType.card:
        return _buildTile(
            context: context,
            tile: tile,
            header: CardHeader(card: tile.card),
            title: tile.card.title,
            trailer: SocialSummary(
              parentId: tile.cardId,
              likes: tile.card.likes,
              comments: tile.card.comments,
              tileType: tile.type,
            ));
        break;
      case TileType.drawing:
        return _buildTile(
            context: context,
            tile: tile,
            header: DrawingCard(
              tile: tile,
              isInteractive: false,
            ),
            title: tile.card.title,
            trailer: SocialSummary(
              parentId: tile.id,
              likes: tile.likes,
              comments: tile.comments,
              tileType: tile.type,
            ));
        break;
      case TileType.message:
        return _buildTile(
            context: context,
            tile: tile,
            title: tile.content,
            trailer: SocialSummary(
              parentId: tile.id,
              likes: tile.likes,
              comments: tile.comments,
              tileType: tile.type,
            ));
        break;
      case TileType.dot:
        return Container();
        break;
    }
  }

  Widget _buildTile(
      {BuildContext context,
      Tile tile,
      Widget header,
      String title,
      Widget trailer}) {
    return InkWell(
      onTap: () {
        Provider.dispatch<RootState>(
            context, FetchComments(parentId: tile.id, tileType: tile.type));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TileDetail(tile: tile)));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          print(constraints);
          final widgets = <Widget>[];
          if (header != null) {
            widgets.add(SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxHeight,
                child: header));
          }
          widgets.add(Expanded(
              child: Column(
            children: <Widget>[Expanded(child: Text(title)), trailer],
          )));
          return Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
        },
      ),
    );
//    switch (tile.type) {
//      case TileType.card:
//        return Container(
//          decoration: new BoxDecoration(
//            borderRadius: new BorderRadius.circular(8.0),
//            border: new Border.all(
//              width: 1.0,
//              color: Color(0xFFEF823F),
//            ),
//          ),
////          constraints: BoxConstraints.tightFor(height: 120.0),
//          child: CardSummary(
//            card: tile.card,
//            orientation: Orientation.landscape,
//          ),
//        );
//        break;
//      case TileType.drawing:
//        return Container(
//          constraints: BoxConstraints.tightFor(height: 120.0),
//          child: DrawingCard(tile: tile),
//        );
//        break;
//      case TileType.message:
//        return Container(
//          decoration: new BoxDecoration(
//            borderRadius: new BorderRadius.circular(8.0),
//            border: new Border.all(
//              width: 1.0,
//              color: Color(0xFFEF823F),
//            ),
//          ),
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text(
//              tile.content,
//              style: Theme.of(context).textTheme.title,
//              overflow: TextOverflow.ellipsis,
//            ),
//          ),
//        );
//    }
  }
}
