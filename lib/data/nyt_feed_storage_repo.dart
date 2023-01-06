
import 'package:nytfeed/model/article.dart';
import 'package:nytfeed/model/list_part.dart';

abstract class NytFeedStorageRepo {
  Future<ListPart<Article>> getArticles(int offset, int limit);

  Future<void> storeArticles(Iterable<Article> articles);
}