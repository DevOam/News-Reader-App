import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/news_response.dart';
import '../../core/constants/app_constants.dart';

/// Service class responsible for fetching news data from NewsAPI
/// 
/// This class handles all HTTP requests to the NewsAPI endpoints
/// and provides methods to fetch different types of news content.
class NewsService {
  final http.Client _client;

  /// Constructor with optional HTTP client for testing
  NewsService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches top headlines from NewsAPI
  /// 
  /// [country] - Country code for headlines (default: 'us')
  /// [category] - News category (default: 'general')
  /// [pageSize] - Number of articles to fetch (default: 20)
  /// [page] - Page number for pagination (default: 1)
  /// 
  /// Returns [NewsResponse] containing the list of articles
  /// Throws [NewsServiceException] if the request fails
  Future<NewsResponse> getTopHeadlines({
    String country = AppConstants.defaultCountry,
    String category = AppConstants.defaultCategory,
    int pageSize = AppConstants.defaultPageSize,
    int page = 1,
  }) async {
    try {
      // Validate API key
      if (AppConstants.apiKey == 'YOUR_API_KEY_HERE') {
        throw NewsServiceException(
          'API key not configured. Please set your NewsAPI key in AppConstants.',
          type: NewsServiceExceptionType.configuration,
        );
      }

      // Build the request URL
      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.topHeadlinesEndpoint}'
      ).replace(queryParameters: {
        'country': country,
        'category': category,
        'pageSize': pageSize.toString(),
        'page': page.toString(),
        'apiKey': AppConstants.apiKey,
      });

      // Make the HTTP request
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': '${AppConstants.appName}/${AppConstants.appVersion}',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw NewsServiceException(
          'Request timeout. Please check your internet connection.',
          type: NewsServiceExceptionType.timeout,
        ),
      );

      // Handle the response
      return _handleResponse(response);
    } on SocketException {
      throw NewsServiceException(
        AppConstants.networkErrorMessage,
        type: NewsServiceExceptionType.network,
      );
    } on FormatException catch (e) {
      throw NewsServiceException(
        'Invalid response format: ${e.message}',
        type: NewsServiceExceptionType.parsing,
      );
    } catch (e) {
      if (e is NewsServiceException) rethrow;
      throw NewsServiceException(
        'Unexpected error: ${e.toString()}',
        type: NewsServiceExceptionType.unknown,
      );
    }
  }

  /// Searches for articles using the everything endpoint
  /// 
  /// [query] - Search query string
  /// [sortBy] - Sort order ('relevancy', 'popularity', 'publishedAt')
  /// [pageSize] - Number of articles to fetch (default: 20)
  /// [page] - Page number for pagination (default: 1)
  /// 
  /// Returns [NewsResponse] containing the search results
  Future<NewsResponse> searchArticles({
    required String query,
    String sortBy = 'publishedAt',
    int pageSize = AppConstants.defaultPageSize,
    int page = 1,
  }) async {
    try {
      if (AppConstants.apiKey == 'YOUR_API_KEY_HERE') {
        throw NewsServiceException(
          'API key not configured. Please set your NewsAPI key in AppConstants.',
          type: NewsServiceExceptionType.configuration,
        );
      }

      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.everythingEndpoint}'
      ).replace(queryParameters: {
        'q': query,
        'sortBy': sortBy,
        'pageSize': pageSize.toString(),
        'page': page.toString(),
        'apiKey': AppConstants.apiKey,
      });

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': '${AppConstants.appName}/${AppConstants.appVersion}',
        },
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NewsServiceException(
        AppConstants.networkErrorMessage,
        type: NewsServiceExceptionType.network,
      );
    } catch (e) {
      if (e is NewsServiceException) rethrow;
      throw NewsServiceException(
        'Search failed: ${e.toString()}',
        type: NewsServiceExceptionType.unknown,
      );
    }
  }

  /// Handles HTTP response and converts to NewsResponse
  NewsResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(jsonData);
      
      if (!newsResponse.isSuccess) {
        throw NewsServiceException(
          newsResponse.errorMessage,
          type: NewsServiceExceptionType.api,
        );
      }
      
      return newsResponse;
    } else if (response.statusCode == 401) {
      throw NewsServiceException(
        'Invalid API key. Please check your NewsAPI configuration.',
        type: NewsServiceExceptionType.authentication,
      );
    } else if (response.statusCode == 429) {
      throw NewsServiceException(
        'API rate limit exceeded. Please try again later.',
        type: NewsServiceExceptionType.rateLimited,
      );
    } else {
      throw NewsServiceException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        type: NewsServiceExceptionType.http,
      );
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Custom exception class for NewsService errors
class NewsServiceException implements Exception {
  final String message;
  final NewsServiceExceptionType type;

  const NewsServiceException(
    this.message, {
    required this.type,
  });

  @override
  String toString() => 'NewsServiceException: $message';
}

/// Enum defining different types of NewsService exceptions
enum NewsServiceExceptionType {
  network,
  timeout,
  authentication,
  rateLimited,
  parsing,
  api,
  http,
  configuration,
  unknown,
}
