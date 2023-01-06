// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nyt_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NytResult<T> _$NytResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    NytResult<T>(
      json['status'] as String?,
      json['copyright'] as String?,
      json['num_results'] as int?,
      (json['results'] as List<dynamic>?)?.map(fromJsonT).toList(),
    );

Map<String, dynamic> _$NytResultToJson<T>(
  NytResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'copyright': instance.copyright,
      'num_results': instance.num_results,
      'results': instance.results?.map(toJsonT).toList(),
    };
