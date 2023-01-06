
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/model/article.dart';
import 'package:nytfeed/model/list_part.dart';

abstract class LoadAndCacheArticles {
  Future<ListPart<Article>> getArticles(AppMode mode, int offset, int limit);
}