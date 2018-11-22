import 'dart:async';
import 'dart:convert';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProgress implements AsyncAction<RootState> {
  final String cardId;
  final String parentCardId;
  final int index;

  CardProgressRepo cardProgressRepo;
  CollectionRepo collectionRepo;

  AddProgress({this.cardId, this.parentCardId, this.index});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(cardProgressRepo != null, 'CardProgressRepo not injected');
    assert(collectionRepo != null, 'collectionRepo not injected');

    await cardProgressRepo.upsert(CardProgress(
        userId: state.user.id, cardId: cardId, updatedAt: DateTime.now()));
    final progress =
        await cardProgressRepo.getProgressStatusByCollectionAndTypeAndUserId(
            parentCardId, CardType.knowledge, state.user.id);

    print('index: $index $parentCardId');
    final userActivity = state.activityMap[parentCardId] ?? UserActivity();
    if ((userActivity.done ?? -1) < index) {
      print('userActivity: ${state.activityMap}');
      userActivity.done = index;
      userActivity.total = userActivity.total ??
          await collectionRepo
              .getKnowledgeAndQuizCardCountInCollection(parentCardId);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      state.activityMap[parentCardId] = userActivity;
      print('userActivity: $userActivity');
      prefs.setString('userActivity', json.encode(state.activityMap));
    }

    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap..[parentCardId] = userActivity,
        commentMap: state.commentMap,
        drawings: state.drawings,
        templates: state.templates);
  }
}
