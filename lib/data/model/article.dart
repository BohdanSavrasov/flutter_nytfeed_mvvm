import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';


@JsonSerializable()
class Article {
  final String? section;
  final String? subsection;
  final String? title; //Article headline.
  final String? abstract; //Article summary.
  final String? uri; //Uniquely identifies an article.
  final String? url; //Article URL.
  final String? short_url;
  final String? byline;
  final String? thumbnail_standard;
  final String? item_type;
  final String? source;
  final String? updated_date;
  final String? created_date;
  final String? published_date;
  final String? material_type_facet;
  final String? kicker;
  final String? headline;
  final List<String?>? des_facet;
  final String? items;
  final List<String?>? org_facet;
  final List<String?>? per_facet;
  final List<String?>? geo_facet;
  final String? blog_name;
  final List<Url?>? related_urls;
  final List<Multimedia?>? multimedia;

  Article(
    this.section,
    this.subsection,
    this.title,
    this.abstract,
    this.uri,
    this.url,
    this.short_url,
    this.byline,
    this.thumbnail_standard,
    this.item_type,
    this.source,
    this.updated_date,
    this.created_date,
    this.published_date,
    this.material_type_facet,
    this.kicker,
    this.headline,
    this.des_facet,
    this.items,
    this.org_facet,
    this.per_facet,
    this.geo_facet,
    this.blog_name,
    this.related_urls,
    this.multimedia,
  );

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

}

@JsonSerializable()
class Url {
  final String? suggested_link_text;
  final String? url;

  Url(this.suggested_link_text, this.url);

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);

  Map<String, dynamic> toJson() => _$UrlToJson(this);
}

@JsonSerializable()
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

  factory Multimedia.fromJson(Map<String, dynamic> json) => _$MultimediaFromJson(json);

  Map<String, dynamic> toJson() => _$MultimediaToJson(this);
}
