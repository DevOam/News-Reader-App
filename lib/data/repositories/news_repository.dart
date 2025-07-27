import '../models/article.dart';
import '../models/news_response.dart';
import '../services/news_service.dart';

/// Repository class that acts as a single source of truth for news data
/// 
/// This class abstracts the data layer and provides a clean interface
/// for the presentation layer to interact with news data.
/// It handles caching, error handling, and data transformation.
class NewsRepository {
  final NewsService _newsService;
  
  // Simple in-memory cache for articles
  List<Article>? _cachedArticles;
  DateTime? _lastFetchTime;
  
  /// Cache duration for articles (30 minutes)
  static const Duration _cacheDuration = Duration(minutes: 30);

  /// Constructor with dependency injection
  NewsRepository({NewsService? newsService}) 
      : _newsService = newsService ?? NewsService();

  /// Fetches top headlines with optional caching
  /// 
  /// [forceRefresh] - If true, bypasses cache and fetches fresh data
  /// [country] - Country code for headlines
  /// [category] - News category
  /// [pageSize] - Number of articles to fetch
  /// 
  /// Returns a list of [Article] objects
  /// Throws [NewsRepositoryException] if the operation fails
  Future<List<Article>> getTopHeadlines({
    bool forceRefresh = false,
    String country = 'us',
    String category = 'general',
    int pageSize = 20,
  }) async {
    try {
      // Check if we have valid cached data and don't need to force refresh
      if (!forceRefresh && _isCacheValid()) {
        return _cachedArticles!;
      }

      // Fetch fresh data from the service
      final NewsResponse response = await _newsService.getTopHeadlines(
        country: country,
        category: category,
        pageSize: pageSize,
      );

      // Filter out articles with missing essential data
      final List<Article> validArticles = response.articles
          .where((article) => _isValidArticle(article))
          .toList();

      // Update cache
      _cachedArticles = validArticles;
      _lastFetchTime = DateTime.now();

      return validArticles;
    } on NewsServiceException catch (e) {
      // Re-throw service exceptions as repository exceptions
      throw NewsRepositoryException(
        'Failed to fetch headlines: ${e.message}',
        type: _mapServiceExceptionType(e.type),
        originalException: e,
      );
    } catch (e) {
      throw NewsRepositoryException(
        'Unexpected error while fetching headlines: ${e.toString()}',
        type: NewsRepositoryExceptionType.unknown,
        originalException: e,
      );
    }
  }

  /// Searches for articles based on a query
  /// 
  /// [query] - Search query string
  /// [sortBy] - Sort order for results
  /// [pageSize] - Number of articles to fetch
  /// 
  /// Returns a list of [Article] objects matching the search criteria
  Future<List<Article>> searchArticles({
    required String query,
    String sortBy = 'publishedAt',
    int pageSize = 20,
  }) async {
    try {
      if (query.trim().isEmpty) {
        throw NewsRepositoryException(
          'Search query cannot be empty',
          type: NewsRepositoryExceptionType.validation,
        );
      }

      final NewsResponse response = await _newsService.searchArticles(
        query: query.trim(),
        sortBy: sortBy,
        pageSize: pageSize,
      );

      // Filter and return valid articles
      return response.articles
          .where((article) => _isValidArticle(article))
          .toList();
    } on NewsServiceException catch (e) {
      throw NewsRepositoryException(
        'Search failed: ${e.message}',
        type: _mapServiceExceptionType(e.type),
        originalException: e,
      );
    } catch (e) {
      if (e is NewsRepositoryException) rethrow;
      throw NewsRepositoryException(
        'Unexpected error during search: ${e.toString()}',
        type: NewsRepositoryExceptionType.unknown,
        originalException: e,
      );
    }
  }

  /// Gets a specific article by URL (useful for navigation)
  /// 
  /// [url] - The URL of the article to find
  /// 
  /// Returns the [Article] if found in cache, null otherwise
  Article? getArticleByUrl(String url) {
    if (_cachedArticles == null) return null;
    
    try {
      return _cachedArticles!.firstWhere((article) => article.url == url);
    } catch (e) {
      return null;
    }
  }

  /// Clears the cached articles
  void clearCache() {
    _cachedArticles = null;
    _lastFetchTime = null;
  }

  /// Checks if the current cache is still valid
  bool _isCacheValid() {
    if (_cachedArticles == null || _lastFetchTime == null) {
      return false;
    }
    
    final now = DateTime.now();
    final timeSinceLastFetch = now.difference(_lastFetchTime!);
    
    return timeSinceLastFetch < _cacheDuration;
  }

  /// Validates if an article has the minimum required data
  bool _isValidArticle(Article article) {
    return article.title.isNotEmpty && 
           article.url.isNotEmpty &&
           article.title != '[Removed]'; // NewsAPI sometimes returns this
  }

  /// Maps NewsServiceExceptionType to NewsRepositoryExceptionType
  NewsRepositoryExceptionType _mapServiceExceptionType(
    NewsServiceExceptionType serviceType
  ) {
    switch (serviceType) {
      case NewsServiceExceptionType.network:
        return NewsRepositoryExceptionType.network;
      case NewsServiceExceptionType.timeout:
        return NewsRepositoryExceptionType.timeout;
      case NewsServiceExceptionType.authentication:
        return NewsRepositoryExceptionType.authentication;
      case NewsServiceExceptionType.rateLimited:
        return NewsRepositoryExceptionType.rateLimited;
      case NewsServiceExceptionType.parsing:
        return NewsRepositoryExceptionType.parsing;
      case NewsServiceExceptionType.api:
        return NewsRepositoryExceptionType.api;
      case NewsServiceExceptionType.http:
        return NewsRepositoryExceptionType.http;
      case NewsServiceExceptionType.configuration:
        return NewsRepositoryExceptionType.configuration;
      case NewsServiceExceptionType.unknown:
        return NewsRepositoryExceptionType.unknown;
    }
  }

  /// Disposes resources
  void dispose() {
    _newsService.dispose();
    clearCache();
  }
}

/// Custom exception class for NewsRepository errors
class NewsRepositoryException implements Exception {
  final String message;
  final NewsRepositoryExceptionType type;
  final Object? originalException;

  const NewsRepositoryException(
    this.message, {
    required this.type,
    this.originalException,
  });

  @override
  String toString() => 'NewsRepositoryException: $message';
}

/// Enum defining different types of NewsRepository exceptions
enum NewsRepositoryExceptionType {
  network,
  timeout,
  authentication,
  rateLimited,
  parsing,
  api,
  http,
  configuration,
  validation,
  unknown,
}
