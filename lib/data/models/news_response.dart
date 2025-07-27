import 'package:json_annotation/json_annotation.dart';
import 'article.dart';

part 'news_response.g.dart';

/// Model class representing the API response from NewsAPI
/// 
/// This class wraps the list of articles along with metadata
/// about the API response such as status and total results.
@JsonSerializable()
class NewsResponse {
  /// Status of the API response (e.g., "ok", "error")
  final String status;
  
  /// Total number of results available
  final int totalResults;
  
  /// List of articles returned by the API
  final List<Article> articles;
  
  /// Error code if the request failed
  final String? code;
  
  /// Error message if the request failed
  final String? message;

  /// Constructor for NewsResponse model
  const NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
    this.code,
    this.message,
  });

  /// Creates a NewsResponse instance from JSON data
  factory NewsResponse.fromJson(Map<String, dynamic> json) => 
      _$NewsResponseFromJson(json);

  /// Converts NewsResponse instance to JSON
  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);

  /// Checks if the API response was successful
  bool get isSuccess => status == 'ok' && code == null;

  /// Gets the error message if the response failed
  String get errorMessage => message ?? 'Unknown error occurred';

  @override
  String toString() {
    return 'NewsResponse(status: $status, totalResults: $totalResults, '
           'articlesCount: ${articles.length})';
  }
}
