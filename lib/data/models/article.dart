import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

/// Model class representing a news article
/// 
/// This class defines the structure of a news article with all necessary
/// properties for displaying in the news reader application.
/// Uses json_annotation for automatic JSON serialization/deserialization.
@JsonSerializable()
class Article {
  /// Unique identifier for the article
  final String? id;
  
  /// The headline or title of the article
  final String title;
  
  /// A brief description or summary of the article
  final String? description;
  
  /// The main content/body of the article
  final String? content;
  
  /// URL to the full article on the source website
  final String url;
  
  /// URL to the article's featured image
  @JsonKey(name: 'urlToImage')
  final String? imageUrl;
  
  /// Publication date and time of the article
  @JsonKey(name: 'publishedAt')
  final DateTime? publishedAt;
  
  /// Information about the article's source
  final Source? source;
  
  /// Author of the article
  final String? author;

  /// Constructor for Article model
  const Article({
    this.id,
    required this.title,
    this.description,
    this.content,
    required this.url,
    this.imageUrl,
    this.publishedAt,
    this.source,
    this.author,
  });

  /// Creates an Article instance from JSON data
  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  /// Converts Article instance to JSON
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  /// Creates a copy of this Article with optionally updated fields
  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    Source? source,
    String? author,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
      author: author ?? this.author,
    );
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title, source: ${source?.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}

/// Model class representing the source of a news article
@JsonSerializable()
class Source {
  /// Unique identifier for the news source
  final String? id;
  
  /// Display name of the news source
  final String name;

  /// Constructor for Source model
  const Source({
    this.id,
    required this.name,
  });

  /// Creates a Source instance from JSON data
  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  /// Converts Source instance to JSON
  Map<String, dynamic> toJson() => _$SourceToJson(this);

  @override
  String toString() => 'Source(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Source && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
