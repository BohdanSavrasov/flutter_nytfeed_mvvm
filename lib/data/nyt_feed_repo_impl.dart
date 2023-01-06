
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nytfeed/const.dart';
import 'package:nytfeed/data/model/article.dart';
import 'package:nytfeed/data/model/nyt_result.dart';
import 'package:nytfeed/data/model_converters.dart';
import 'package:nytfeed/data/nyt_feed_repo.dart';
import 'package:nytfeed/model/article.dart' as app;
import 'package:nytfeed/model/list_part.dart';


class NytFeedRepoImpl extends NytFeedRepo {

  @override
  Future<ListPart<app.Article>> getArticles(int offset, int limit) async {
    assert(offset % 20 == 0, "Offset must be a multiple of 20");
    assert(limit % 20 == 0, "Limit must be a multiple of 20");

    final params = <String, String> {
      "offset": offset.toString(),
      "limit": limit.toString(),
      "api-key": nytApiKey,
    };

    final url = Uri.https("api.nytimes.com", "svc/news/v3/content/nyt/all.json", params);
    final res = await http.get(url);

    if (res.statusCode ~/ 100 != 2) {
      throw Exception(res.reasonPhrase);
    }

    final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final parsed = NytResult<Article?>.fromJson(
      json,
      (json) => Article.fromJson(json as Map<String, dynamic>),
    );

    return ListPart<app.Article>(
      parsed.num_results ?? 0,
      parsed.results
              ?.where((a) => a != null)
              .map((a) => toAppArticle(a!))
              .toList() ?? [],
    );
  }

}