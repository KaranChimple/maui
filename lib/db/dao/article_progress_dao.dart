import 'dart:async';
import 'package:maui/app_database.dart';
import 'package:maui/db/entity/article_progress.dart';
import 'package:sqflite/sqflite.dart';

class ArticleProgressDao {
  const ArticleProgressDao();

  Future<ArticleProgress> getArticleProgressByTopicIdAndArticleIdAndUserId(
      String topicId, String articleId, String userId,
      {Database db}) async {
    print("Inside article_progress_dao $topicId, $articleId, $userId");
    db = db ?? await new AppDatabase().getDb();
    List<Map> maps = await db.query(ArticleProgress.table,
        columns: [
          ArticleProgress.userIdCol,
          ArticleProgress.topicIdCol,
          ArticleProgress.articleIdCol,
          ArticleProgress.timeStampIdCol
        ],
        where:
            '''${ArticleProgress.topicIdCol} = ? AND ${ArticleProgress.articleIdCol} = ? AND ${ArticleProgress.userIdCol} = ?''',
        whereArgs: [
          topicId,
          articleId,
          userId
        ]);
    if (maps.length > 0) {
      print(maps);
      return ArticleProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertArticleProgress(ArticleProgress articleProgress,
      {Database db}) async {
    db = db ?? await new AppDatabase().getDb();
    await db.insert(ArticleProgress.table, articleProgress.toMap());
  }
}