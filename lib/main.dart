import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nytfeed/data/file_service.dart';
import 'package:nytfeed/data/file_service_impl.dart';
import 'package:nytfeed/data/nyt_feed_repo.dart';
import 'package:nytfeed/data/nyt_feed_repo_impl.dart';
import 'package:nytfeed/data/nyt_feed_storage_impl.dart';
import 'package:nytfeed/data/nyt_feed_storage_repo.dart';
import 'package:nytfeed/feed/feed_view.dart';
import 'package:nytfeed/feed/feed_view_model.dart';
import 'package:nytfeed/usecases/load_and_cache_articles.dart';
import 'package:nytfeed/usecases/load_and_cache_articles_impl.dart';
import 'package:nytfeed/usecases/load_and_cache_images.dart';
import 'package:nytfeed/usecases/load_and_cache_images_impl.dart';
import 'package:provider/provider.dart';

void main() {
  MyApp.setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void setupDI() {
    GetIt.instance.registerFactory<NytFeedRepo>(() => NytFeedRepoImpl());
    GetIt.instance.registerFactory<NytFeedStorageRepo>(() => NytFeedStorageRepoImpl());
    GetIt.instance.registerFactory<FileService>(() => FileServiceImpl());
    GetIt.instance.registerFactory<LoadAndCacheArticles>(() => LoadAndCacheArticlesImpl(
      GetIt.I<NytFeedRepo>(),
      GetIt.I<NytFeedStorageRepo>(),
    ));
    GetIt.instance.registerFactory<LoadAndCacheImages>(() => LoadAndCacheImagesImpl(
      GetIt.I<FileService>(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FeedViewModel>(
            create: (_) => FeedViewModel(
                GetIt.I<LoadAndCacheArticles>(),
                GetIt.I<LoadAndCacheImages>(),
            )),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Tinos',
        ),
        home: const FeedView(),
      ),
    );
  }
}

