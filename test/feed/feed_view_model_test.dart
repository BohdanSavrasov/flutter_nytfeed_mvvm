
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nytfeed/feed/feed_view_model.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/model/list_part.dart';
import 'package:nytfeed/usecases/load_and_cache_articles.dart';
import 'package:nytfeed/usecases/load_and_cache_images.dart';

import '../utils.dart';

@GenerateNiceMocks([
  MockSpec<LoadAndCacheArticles>(),
  MockSpec<LoadAndCacheImages>(),
])
import 'feed_view_model_test.mocks.dart';

void main() {

  test("should be empty before init", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();

    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    expect(vm.isEmpty, true);
    expect(vm.length, 0);
  });

  test("should request articles on init", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, []));

    await vm.init();

    verify(loadAndCacheArticles.getArticles(any, any, any));
  });

  test("should save in memory articles got on init", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, [
      generateFakeArticle("one"),
      generateFakeArticle("two"),
      generateFakeArticle("three"),
    ]));

    await vm.init();

    expect(vm.length, 3);
  });

  test("should request articles on loadMore", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, []));

    await vm.init();

    verify(loadAndCacheArticles.getArticles(any, any, any));

    await vm.loadMore();

    verify(loadAndCacheArticles.getArticles(any, any, any));
  });

  test("should save in memory articles got on loadMore", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, []));

    await vm.init();

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, [
      generateFakeArticle("one"),
      generateFakeArticle("two"),
      generateFakeArticle("three"),
    ]));

    await vm.loadMore();

    expect(vm.length, 3);
  });

  test("should switch to offline mode and back", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, []));

    await vm.init();

    expect(vm.appMode, AppMode.online);

    await vm.switchAppMode();

    expect(vm.appMode, AppMode.offline);

    await vm.switchAppMode();

    expect(vm.appMode, AppMode.online);
  });

  test("init() should catch and display exceptions", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    final exception = Exception("exception message");

    when(loadAndCacheArticles.getArticles(any, any, any)).thenThrow(exception);

    expect(vm.exception, null);

    await vm.init();

    expect(vm.exception, exception);
  });

  test("loadMore() should catch and display exceptions", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    final exception = Exception("exception message");

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, []));

    await vm.init();

    expect(vm.exception, null);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenThrow(exception);

    await vm.loadMore();

    expect(vm.exception, exception);
  });

  test("getImageForArticle() should request an image", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheImages.getImage(any, any)).thenAnswer((_) async => Uri());

    await vm.getImageForArticle(generateFakeArticle("one"));

    verify(loadAndCacheImages.getImage(any, any));
  });

  test("ViewModel should set isLoading when loading", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(500, []));

    int isLoadingCounter = 0;

    vm.addListener(() {
      if (vm.isLoading) {
        isLoadingCounter += 1;
      }
    });

    await vm.init();
    
    expect(isLoadingCounter, greaterThan(0));

    isLoadingCounter = 0;

    await vm.loadMore();

    expect(isLoadingCounter, greaterThan(0));

  });

  test("flag isEndReached should be true when enough articles loaded", () async {
    final loadAndCacheArticles = MockLoadAndCacheArticles();
    final loadAndCacheImages = MockLoadAndCacheImages();
    final vm = FeedViewModel(loadAndCacheArticles, loadAndCacheImages);

    when(loadAndCacheArticles.getArticles(any, any, any)).thenAnswer((_) async => ListPart(3, [
      generateFakeArticle("one"),
      generateFakeArticle("two"),
      generateFakeArticle("three"),
    ]));

    expect(vm.isEndReached, false);

    await vm.init();

    expect(vm.isEndReached, true);
  });
}