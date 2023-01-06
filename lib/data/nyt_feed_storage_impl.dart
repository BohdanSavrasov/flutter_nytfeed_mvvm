
import 'dart:async';
import 'dart:convert';

import 'package:nytfeed/data/model/article.dart';
import 'package:nytfeed/data/model_converters.dart';
import 'package:nytfeed/data/nyt_feed_storage_repo.dart';
import 'package:nytfeed/model/article.dart' as app;
import 'package:nytfeed/model/list_part.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class NytFeedStorageRepoImpl extends NytFeedStorageRepo {
  static const _articlesTableName = "articles";
  late final Future<Database> dbFuture;

  NytFeedStorageRepoImpl() {
    dbFuture = openDatabase("articles.db", onCreate: _onCreateDb, version: 1);
  }

  FutureOr<void> _onCreateDb(Database db, int version) async {
    final cmd = StringBuffer("CREATE TABLE IF NOT EXISTS $_articlesTableName (");
    cmd.write("id TEXT PRIMARY KEY, ");
    cmd.write("section TEXT, ");
    cmd.write("subsection TEXT, ");
    cmd.write("title TEXT, ");
    cmd.write("abstract TEXT, ");
    cmd.write("uri TEXT, ");
    cmd.write("url TEXT, ");
    cmd.write("short_url TEXT, ");
    cmd.write("byline TEXT, ");
    cmd.write("thumbnail_standard TEXT, ");
    cmd.write("item_type TEXT, ");
    cmd.write("source TEXT, ");
    cmd.write("updated_date TEXT, ");
    cmd.write("created_date TEXT, ");
    cmd.write("published_date TEXT, ");
    cmd.write("material_type_facet TEXT, ");
    cmd.write("kicker TEXT, ");
    cmd.write("headline TEXT, ");
    cmd.write("des_facet TEXT, ");
    cmd.write("items TEXT, ");
    cmd.write("org_facet TEXT, ");
    cmd.write("per_facet TEXT, ");
    cmd.write("geo_facet TEXT, ");
    cmd.write("blog_name TEXT, ");
    cmd.write("related_urls TEXT, ");
    cmd.write("multimedia TEXT ");
    cmd.write(");");

    await db.execute(cmd.toString());
  }

  @override
  Future<ListPart<app.Article>> getArticles(int offset, int limit) async {
    final db = await dbFuture;
    final count = await db.rawQuery("SELECT COUNT(*) FROM $_articlesTableName");
    final allResults = await db.query(
        _articlesTableName,
        orderBy: "created_date DESC",
        limit: limit,
        offset: offset,
    );

    MapEntry<String, Object?> mapArticle(String key, Object? value) {
      switch(key) {
        case "des_facet":
        case "org_facet":
        case "per_facet":
        case "geo_facet":
        case "related_urls":
        case "multimedia":
          return MapEntry(key, jsonDecode(value as String));
      }
      return MapEntry(key, value);
    }

    final appArticles = allResults
        .map((a) => a.map(mapArticle))
        .map((a) => Article.fromJson(a))
        .map((a) => toAppArticle(a))
        .toList();

    return ListPart(count.first.entries.first.value as int, appArticles);
  }

  @override
  Future<void> storeArticles(Iterable<app.Article> articles) async {
    for (app.Article article in articles) {
      final dataArticle = toDataArticle(article);
      final id = _getId(dataArticle);
      final dataArticleJson = dataArticle.toJson();
      dataArticleJson["id"] = id;
      dataArticleJson["des_facet"] = jsonEncode(dataArticleJson["des_facet"]);
      dataArticleJson["org_facet"] = jsonEncode(dataArticleJson["org_facet"]);
      dataArticleJson["per_facet"] = jsonEncode(dataArticleJson["per_facet"]);
      dataArticleJson["geo_facet"] = jsonEncode(dataArticleJson["geo_facet"]);
      dataArticleJson["related_urls"] = jsonEncode(dataArticleJson["related_urls"]);
      dataArticleJson["multimedia"] = jsonEncode(dataArticleJson["multimedia"]);
      final db = await dbFuture;
      await db.insert(
          _articlesTableName,
          dataArticleJson,
          conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  String _getId(Article article) {
    final uri = article.uri;
    if (uri != null && uri.isNotEmpty) {
      try {
        final uuid = uri.substring(uri.length - 36);
        Uuid.isValidOrThrow(fromString: uuid);
        return uuid;
      } catch (e) {
        // do nothing
      }
    }

    String fallbackData = article.uri ??
        article.short_url ??
        article.short_url ??
        jsonEncode(article.toJson());

    return const Uuid().v5(Uuid.NAMESPACE_NIL, fallbackData);
  }

}