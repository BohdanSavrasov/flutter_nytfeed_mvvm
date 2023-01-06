
import 'package:nytfeed/model/article.dart';
import 'package:nytfeed/model/list_part.dart';

abstract class NytFeedRepo {
  Future<ListPart<Article>> getArticles(int offset, int limit);
}