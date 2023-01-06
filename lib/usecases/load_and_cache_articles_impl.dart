

import 'package:nytfeed/data/nyt_feed_repo.dart';
import 'package:nytfeed/data/nyt_feed_storage_repo.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/model/article.dart';
import 'package:nytfeed/model/list_part.dart';
import 'package:nytfeed/usecases/load_and_cache_articles.dart';

class LoadAndCacheArticlesImpl extends LoadAndCacheArticles {
  final NytFeedRepo _repo;
  final NytFeedStorageRepo _storage;

  LoadAndCacheArticlesImpl(this._repo, this._storage);

  @override
  Future<ListPart<Article>> getArticles(AppMode mode, int offset, int limit) async {
    if (mode == AppMode.online) {
      final listPart = await _repo.getArticles(offset, limit);
      await _storage.storeArticles(listPart.items);
      return listPart;
    } else {
      return _storage.getArticles(offset, limit);
    }
  }
}