import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;

class AddComment implements AsyncAction<RootState> {
  final Comment comment;
  final TileType tileType;
  CommentRepo commentRepo;
  TileRepo tileRepo;

  AddComment({this.comment, this.tileType});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(commentRepo != null, 'commentRepo not injected');
    assert(tileRepo != null, 'tileRepo not injected');

    commentRepo.insert(comment, tileType);
    state.cardMap[comment.parentId].comments =
        (state.cardMap[comment.parentId].comments ?? 0) + 1;

    final tiles = await tileRepo.getTilesByCardId(comment.parentId);
    if (tiles.length == 0) {
      await tileRepo.insert(Tile(
          id: Uuid().v4(),
          cardId: comment.parentId,
          content: '${comment.user.name} commented on this',
          type: TileType.card,
          userId: comment.userId,
          updatedAt: DateTime.now()));
    }
    if (comment.userId == state.user.id)
      try {
        await p2p.addMessage(
            state.user.id,
            '0',
            'comment',
            '${comment.id}*${tileType.index}*${comment.parentId}*${comment.comment}',
            true,
            '');
      } on PlatformException {
        print('Flores: Failed addMessage');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }

    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap,
        commentMap: state.commentMap..[comment.parentId].add(comment),
        tiles: state.tiles,
        templates: state.templates);
  }
}
