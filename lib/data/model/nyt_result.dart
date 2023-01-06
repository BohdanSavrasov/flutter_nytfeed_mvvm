
import 'package:json_annotation/json_annotation.dart';

part 'nyt_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class NytResult<T> {
  final String? status;
  final String? copyright;
  final int? num_results;
  final List<T>? results;

  NytResult(this.status, this.copyright, this.num_results, this.results);

  factory NytResult.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$NytResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$NytResultToJson(this, toJsonT);
}