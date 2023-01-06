
import 'package:flutter/foundation.dart';
import 'package:nytfeed/const.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/usecases/load_and_cache_articles.dart';
import 'package:nytfeed/usecases/load_and_cache_images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/article.dart';

class FeedViewModel extends ChangeNotifier {
  final LoadAndCacheArticles _articlesRepo;
  final LoadAndCacheImages _loadAndCacheImages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _totalItems = 0;
  bool get isEndReached => length >= _totalItems && length > 0;

  List<Article>? _articles;
  List<Article>? get articles => _articles;
  int get length => _articles?.length ?? 0;
  bool get isEmpty => length == 0;

  Exception? _exception;
  Exception? get exception => _exception;

  AppMode _appMode = AppMode.online;
  AppMode get appMode => _appMode;

  FeedViewModel(this._articlesRepo, this._loadAndCacheImages);

  Future<void> init() async {
    _isLoading = true;
    _totalItems = 0x7fffffff; //max value
    _exception = null;
    _articles = null;
    notifyListeners();

    try {
      final part = await _articlesRepo.getArticles(_appMode, 0, feedPageSize);
      _articles = part.items;
      _totalItems = part.totalItems;
    } on Exception catch(e) {
      _exception = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_exception != null || isEndReached || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final part = await _articlesRepo.getArticles(_appMode, length, feedPageSize);
      _articles?.addAll(part.items);
      _totalItems = part.totalItems;
    } on Exception catch (e) {
      _exception = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    _exception = null;
    await loadMore();
  }

  Future<void> switchAppMode() async {
    if (appMode == AppMode.offline) {
      _appMode = AppMode.online;
    } else {
      _appMode = AppMode.offline;
    }
    notifyListeners();
    await init();
  }

  Future<Uri?> getImageForArticle(Article a) async {
    final remoteUri = Uri.parse(a.thumbnailStandard ?? "");
    return _loadAndCacheImages.getImage(_appMode, remoteUri);
  }

  void onArticleTap(Article a) {
    final uri = Uri.tryParse(a.url ?? "");
    if (uri != null) {
      launchUrl(uri);
    }
  }
}