import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nytfeed/feed/feed_view_model.dart';
import 'package:nytfeed/model/app_mode.dart';
import 'package:nytfeed/model/article.dart';
import 'package:provider/provider.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    final vm = Provider.of<FeedViewModel>(context, listen: false);

    _scrollController = ScrollController()
      ..addListener(() {
        if (vm.isEmpty) return;

        final lengthPerItem =
            _scrollController.position.maxScrollExtent / vm.length;
        final nextPageBorder = (vm.length - 5) * lengthPerItem;

        if (_scrollController.position.pixels > nextPageBorder) {
          vm.loadMore();
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      vm.init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedViewModel>(
      builder: (ctx, vm, child) {
        Widget content;
        if (vm.isEmpty && vm.exception != null) {
          content = Center(child: _buildExceptionItem(vm));
        } else if (vm.isEmpty && vm.isLoading) {
          content = _buildFullScreenLoader();
        } else if (vm.isEmpty) {
          content = const Center(child: Text("No data"));
        } else {
          content = _buildList(vm);
        }

        IconData cloudIcon;
        if (vm.appMode == AppMode.online) {
          cloudIcon = Icons.cloud_outlined;
        } else {
          cloudIcon = Icons.cloud_off_outlined;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("\"NewYork Times\" feed"),
            actions: [
              IconButton(
                onPressed: () {
                  vm.switchAppMode();
                },
                icon: Icon(cloudIcon),
              )
            ],
          ),
          body: Column(
            children: [
              if (vm.appMode == AppMode.offline)
                Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).focusColor),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      child: Text(
                        "You are offline",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFullScreenLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(FeedViewModel vm) {
    final shouldShowExtraItem = vm.isLoading || vm.exception != null;
    final count = vm.length + (shouldShowExtraItem ? 1 : 0);

    return RefreshIndicator(
      onRefresh: () => vm.init(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: count,
        itemBuilder: (ctx, i) {
          final isLast = i == count - 1;

          if (isLast && vm.exception != null) {
            return _buildExceptionItem(vm);
          } else if (isLast && vm.isLoading) {
            return _buildLoadingItem();
          } else {
            return _buildPostItem(vm.articles![i], vm);
          }
        },
      ),
    );
  }

  Widget _buildPostItem(Article article, FeedViewModel vm) {
    return InkWell(
      onTap: () => vm.onArticleTap(article),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(article, vm),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? "",
                    style: Theme.of(context).textTheme.titleSmall,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    article.abstract ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingItem() {
    return const SizedBox(
      height: 72,
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildExceptionItem(FeedViewModel vm) {
    return SizedBox(
      height: 72,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: "${vm.exception}\n"),
              TextSpan(
                text: "retry",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    vm.retry();
                  },
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              if (vm.appMode == AppMode.online)
                const TextSpan(text: " or "),
              if (vm.appMode == AppMode.online)
                TextSpan(
                  text: "go offline",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () { vm.switchAppMode(); },
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
            ],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(Article article, FeedViewModel vm) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 72.0,
        minHeight: 72.0,
        maxWidth: 72.0,
        maxHeight: 72.0,
      ),
      child: FutureBuilder<Uri?>(
        future: vm.getImageForArticle(article),
        builder: (BuildContext context, AsyncSnapshot<Uri?> snapshot) {
          Widget errorWidget = const Center(
            child: Opacity(opacity: 0.5, child: Icon(Icons.newspaper)),
          );

          if (snapshot.hasError) {
            return errorWidget;
          }

          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            );
          }

          return Image.file(
            File(snapshot.data?.toFilePath() ?? ""),
            errorBuilder: (ctx, e, s) => errorWidget,
          );
        },
      ),
    );
  }
}
