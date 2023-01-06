
import 'package:nytfeed/model/article.dart';

Article generateFakeArticle(String title) {
  return Article(
    null,
    null,
    title,
    "abstract",
    title.toLowerCase(),
    title.toLowerCase(),
    title.toLowerCase(),
    "byline",
    "http://url.jpg",
    "itemType",
    "source",
    "2023-01-05T18:12:47Z",
    "2023-01-05T18:12:47Z",
    "2023-01-05T18:12:47Z",
    "materialTypeFacet",
    "kicker",
    "headline",
    [],
    "items",
    [],
    [],
    [],
    "blogName",
    [],
    [],
  );
}