// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  content: json['content'] as String?,
  url: json['url'] as String,
  imageUrl: json['urlToImage'] as String?,
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  source: json['source'] == null
      ? null
      : Source.fromJson(json['source'] as Map<String, dynamic>),
  author: json['author'] as String?,
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'content': instance.content,
  'url': instance.url,
  'urlToImage': instance.imageUrl,
  'publishedAt': instance.publishedAt?.toIso8601String(),
  'source': instance.source,
  'author': instance.author,
};

Source _$SourceFromJson(Map<String, dynamic> json) =>
    Source(id: json['id'] as String?, name: json['name'] as String);

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
