// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      json['section'] as String?,
      json['subsection'] as String?,
      json['title'] as String?,
      json['abstract'] as String?,
      json['uri'] as String?,
      json['url'] as String?,
      json['short_url'] as String?,
      json['byline'] as String?,
      json['thumbnail_standard'] as String?,
      json['item_type'] as String?,
      json['source'] as String?,
      json['updated_date'] as String?,
      json['created_date'] as String?,
      json['published_date'] as String?,
      json['material_type_facet'] as String?,
      json['kicker'] as String?,
      json['headline'] as String?,
      (json['des_facet'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      json['items'] as String?,
      (json['org_facet'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      (json['per_facet'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      (json['geo_facet'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      json['blog_name'] as String?,
      (json['related_urls'] as List<dynamic>?)
          ?.map(
              (e) => e == null ? null : Url.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['multimedia'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Multimedia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'section': instance.section,
      'subsection': instance.subsection,
      'title': instance.title,
      'abstract': instance.abstract,
      'uri': instance.uri,
      'url': instance.url,
      'short_url': instance.short_url,
      'byline': instance.byline,
      'thumbnail_standard': instance.thumbnail_standard,
      'item_type': instance.item_type,
      'source': instance.source,
      'updated_date': instance.updated_date,
      'created_date': instance.created_date,
      'published_date': instance.published_date,
      'material_type_facet': instance.material_type_facet,
      'kicker': instance.kicker,
      'headline': instance.headline,
      'des_facet': instance.des_facet,
      'items': instance.items,
      'org_facet': instance.org_facet,
      'per_facet': instance.per_facet,
      'geo_facet': instance.geo_facet,
      'blog_name': instance.blog_name,
      'related_urls': instance.related_urls,
      'multimedia': instance.multimedia,
    };

Url _$UrlFromJson(Map<String, dynamic> json) => Url(
      json['suggested_link_text'] as String?,
      json['url'] as String?,
    );

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'suggested_link_text': instance.suggested_link_text,
      'url': instance.url,
    };

Multimedia _$MultimediaFromJson(Map<String, dynamic> json) => Multimedia(
      json['url'] as String?,
      json['format'] as String?,
      json['height'] as int?,
      json['width'] as int?,
      json['type'] as String?,
      json['subtype'] as String?,
      json['caption'] as String?,
      json['copyright'] as String?,
    );

Map<String, dynamic> _$MultimediaToJson(Multimedia instance) =>
    <String, dynamic>{
      'url': instance.url,
      'format': instance.format,
      'height': instance.height,
      'width': instance.width,
      'type': instance.type,
      'subtype': instance.subtype,
      'caption': instance.caption,
      'copyright': instance.copyright,
    };
