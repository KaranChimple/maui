import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/quiz_progress.dart';
import 'package:sqflite/sqflite.dart';

class QuizProgressDao {
  Future<QuizProgress> getQuizProgressByQuizProgressId(String id,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuizProgress.table,
        columns: [
          QuizProgress.idCol,
          QuizProgress.userIdCol,
          QuizProgress.topicIdCol,
          QuizProgress.quizIdCol,
          QuizProgress.maxScoreCol,
          QuizProgress.outOfTotalCol
        ],
        where: "${QuizProgress.idCol} = ? ",
        whereArgs: [id]);
    if (maps.length > 0) {
      return QuizProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<QuizProgress> getQuizProgressByTopicAndQuizId(
      String topicId, String quizId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuizProgress.table,
        columns: [
          QuizProgress.idCol,
          QuizProgress.userIdCol,
          QuizProgress.topicIdCol,
          QuizProgress.quizIdCol,
          QuizProgress.maxScoreCol,
          QuizProgress.outOfTotalCol
        ],
        where:
            '''${QuizProgress.topicIdCol} = ? AND ${QuizProgress.quizIdCol} = ?''',
        whereArgs: [
          topicId,
          quizId
        ]);
    print("Topic Id received in QuizprogressDao - $topicId");
    if (maps.length > 0) {
      return QuizProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<QuizProgress> getQuizProgressByTopicId(String topicId,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(QuizProgress.table,
        columns: [
          QuizProgress.idCol,
          QuizProgress.userIdCol,
          QuizProgress.topicIdCol,
          QuizProgress.quizIdCol,
          QuizProgress.maxScoreCol,
          QuizProgress.outOfTotalCol
        ],
        where: "${QuizProgress.topicIdCol} = ?",
        whereArgs: [topicId]);
    print("Topic Id received in QuizprogressDao - $topicId");
    if (maps.length > 0) {
      return QuizProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertQuizProgress(QuizProgress quizProgress,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(QuizProgress.table, quizProgress.toMap());
  }

  Future<void> updateQuizProgress(QuizProgress quizProgress,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.update(QuizProgress.table, quizProgress.toMap(),
        where:
            '''${QuizProgress.topicIdCol} = ? AND ${QuizProgress.quizIdCol} = ?''',
        whereArgs: [quizProgress.topicId, quizProgress.quizId]);
  }
}
