
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nytfeed/data/file_service.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/usecases/load_and_cache_images_impl.dart';

import 'load_and_cache_images_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FileService>(),
])

void main() {
  test("should load from cache if image is cached", () async {
    final fs = MockFileService();
    final cache = LoadAndCacheImagesImpl(fs);

    final uri = Uri.parse("http://test.com/test.jpg");
    when(fs.isExists(any)).thenAnswer((_) async => true);
    when(fs.getCacheDir()).thenAnswer((_) async => Uri.file("/cache/"));

    final cachedUri = await cache.getImage(AppMode.online, uri);
    expect(cachedUri.pathSegments.first, "cache");

    verify(fs.isExists(any));
    verify(fs.getCacheDir());
  });

  test("should load from internet if image is not cached", () async {
    final fs = MockFileService();
    final cache = LoadAndCacheImagesImpl(fs);

    final uri = Uri.parse("http://test.com/test.jpg");
    when(fs.isExists(any)).thenAnswer((_) async => false);
    when(fs.getCacheDir()).thenAnswer((_) async => Uri.file("/cache/"));
    when(fs.load(any)).thenAnswer((_) async => Uint8List(3));

    final cachedUri = await cache.getImage(AppMode.online, uri);
    expect(cachedUri.pathSegments.first, "cache");

    verify(fs.isExists(any));
    verify(fs.load(uri));
    verify(fs.save(any, any));
    verify(fs.getCacheDir());
  });

  test("should throw if offline and no cached image", () async {
    final fs = MockFileService();
    final cache = LoadAndCacheImagesImpl(fs);

    final uri = Uri.parse("http://test.com/test.jpg");
    when(fs.isExists(any)).thenAnswer((_) async => false);
    when(fs.getCacheDir()).thenAnswer((_) async => Uri.file("/cache/"));

    expect(() async { await cache.getImage(AppMode.offline, uri); }, throwsException);
  });
}