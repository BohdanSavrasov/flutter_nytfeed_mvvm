

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nytfeed/data/nyt_feed_repo.dart';
import 'package:nytfeed/data/nyt_feed_storage_repo.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/model/list_part.dart';
import 'package:nytfeed/usecases/load_and_cache_articles_impl.dart';

import '../utils.dart';
import 'load_and_cache_articles_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NytFeedRepo>(),
  MockSpec<NytFeedStorageRepo>(),
])

void main() {
  test("when online should load and store articles", () async {
    final repo = MockNytFeedRepo();
    final storage = MockNytFeedStorageRepo();

    const offset = 0;
    const limit = 60;
    final articles = ListPart(3, [
      generateFakeArticle("one"),
      generateFakeArticle("two"),
      generateFakeArticle("three"),
    ]);

    when(repo.getArticles(offset, limit)).thenAnswer((_) async => articles);
    when(storage.getArticles(offset, limit)).thenAnswer((_) async => articles);

    final cache = LoadAndCacheArticlesImpl(repo, storage);

    final listPart = await cache.getArticles(AppMode.online, offset, limit);

    expect(listPart, articles);
    verify(repo.getArticles(offset, limit));
    verify(storage.storeArticles(argThat(equals(articles.items))));
  });

  test("when offline should load articles from cache", () async {
    final repo = MockNytFeedRepo();
    final storage = MockNytFeedStorageRepo();

    const offset = 0;
    const limit = 60;
    final articles = ListPart(3, [
      generateFakeArticle("one"),
      generateFakeArticle("two"),
      generateFakeArticle("three"),
    ]);

    when(repo.getArticles(offset, limit)).thenAnswer((_) async => articles);
    when(storage.getArticles(offset, limit)).thenAnswer((_) async => articles);

    final cache = LoadAndCacheArticlesImpl(repo, storage);

    final listPart = await cache.getArticles(AppMode.offline, offset, limit);

    expect(listPart, articles);
    verifyNever(repo.getArticles(any, any));
    verify(storage.getArticles(offset, limit));
  });
}