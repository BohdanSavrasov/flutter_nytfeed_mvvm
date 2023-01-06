
class Article {
  final String? section;
  final String? subsection;
  final String? title; //Article headline.
  final String? abstract; //Article summary.
  final String? uri; //Uniquely identifies an article.
  final String? url; //Article URL.
  final String? shortUrl;
  final String? byline;
  final String? thumbnailStandard;
  final String? itemType;
  final String? source;
  final String? updatedDate;
  final String? createdDate;
  final String? publishedDate;
  final String? materialTypeFacet;
  final String? kicker;
  final String? headline;
  final List<String> desFacet;
  final String? items;
  final List<String> orgFacet;
  final List<String> perFacet;
  final List<String> geoFacet;
  final String? blogName;
  final List<Url> relatedUrls;
  final List<Multimedia> multimedia;

  Article(
    this.section,
    this.subsection,
    this.title,
    this.abstract,
    this.uri,
    this.url,
    this.shortUrl,
    this.byline,
    this.thumbnailStandard,
    this.itemType,
    this.source,
    this.updatedDate,
    this.createdDate,
    this.publishedDate,
    this.materialTypeFacet,
    this.kicker,
    this.headline,
    this.desFacet,
    this.items,
    this.orgFacet,
    this.perFacet,
    this.geoFacet,
    this.blogName,
    this.relatedUrls,
    this.multimedia,
  );

}

class Url {
  final String? suggestedLinkText;
  final String? url;

  Url(this.suggestedLinkText, this.url);

}

class Multimedia {
  final String? url;
  final String? format;
  final int? height;
  final int? width;
  final String? type;
  final String? subtype;
  final String? caption;
  final String? copyright;

  Multimedia(
    this.url,
    this.format,
    this.height,
    this.width,
    this.type,
    this.subtype,
    this.caption,
    this.copyright,
  );

}
