import 'package:nytfeed/data/model/article.dart';
import 'package:nytfeed/model/article.dart' as app;

app.Article toAppArticle(Article a) {
  return app.Article(
    a.section,
    a.subsection,
    a.title,
    a.abstract,
    a.uri,
    a.url,
    a.short_url,
    a.byline,
    a.thumbnail_standard,
    a.item_type,
    a.source,
    a.updated_date,
    a.created_date,
    a.published_date,
    a.material_type_facet,
    a.kicker,
    a.headline,
    a.des_facet?.where((f) => f != null).map((f) => f!).toList() ?? [],
    a.items,
    a.org_facet?.where((f) => f != null).map((f) => f!).toList() ?? [],
    a.per_facet?.where((f) => f != null).map((f) => f!).toList() ?? [],
    a.geo_facet?.where((f) => f != null).map((f) => f!).toList() ?? [],
    a.blog_name,
    a.related_urls?.where((u) => u != null)
        .map((u) => toAppUrl(u!))
        .toList() ?? [],
    a.multimedia?.where((m) => m != null)
        .map((m) => toAppMultimedia(m!))
        .toList() ?? [],
  );
}

app.Multimedia toAppMultimedia(Multimedia m) {
  return app.Multimedia(
    m.url,
    m.format,
    m.height,
    m.width,
    m.type,
    m.subtype,
    m.caption,
    m.copyright,
  );
}

app.Url toAppUrl(Url url) {
  return app.Url(url.suggested_link_text, url.url);
}

Article toDataArticle(app.Article a) {
  return Article(
    a.section,
    a.subsection,
    a.title,
    a.abstract,
    a.uri,
    a.url,
    a.shortUrl,
    a.byline,
    a.thumbnailStandard,
    a.itemType,
    a.source,
    a.updatedDate,
    a.createdDate,
    a.publishedDate,
    a.materialTypeFacet,
    a.kicker,
    a.headline,
    a.desFacet,
    a.items,
    a.orgFacet,
    a.perFacet,
    a.geoFacet,
    a.blogName,
    a.relatedUrls.map(toDataUrl).toList(),
    a.multimedia.map(toDataMultimedia).toList(),
  );
}

Url toDataUrl(app.Url u) {
  return Url(
    u.suggestedLinkText,
    u.url,
  );
}

Multimedia toDataMultimedia(app.Multimedia m) {
  return Multimedia(
    m.url,
    m.format,
    m.height,
    m.width,
    m.type,
    m.subtype,
    m.caption,
    m.copyright,
  );
}
