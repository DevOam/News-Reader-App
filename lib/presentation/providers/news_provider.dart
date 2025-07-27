import 'package:flutter/foundation.dart';
import '../../data/models/article.dart';
import '../../data/repositories/news_repository.dart';

/// Provider class for managing news state using the Provider pattern
/// 
/// This class handles the application state for news articles,
/// including loading states, error handling, and data management.
/// It acts as a bridge between the UI and the data layer.
class NewsProvider extends ChangeNotifier {
  final NewsRepository _newsRepository;

  // Private state variables
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasError = false;

  /// Constructor with dependency injection
  NewsProvider({NewsRepository? newsRepository})
      : _newsRepository = newsRepository ?? NewsRepository();

  // ==================== Getters ====================

  /// List of current articles
  List<Article> get articles => _articles;

  /// Current loading state
  bool get isLoading => _isLoading;

  /// Current error message (null if no error)
  String? get errorMessage => _errorMessage;

  /// Whether there's currently an error
  bool get hasError => _hasError;

  /// Whether there are any articles loaded
  bool get hasArticles => _articles.isNotEmpty;

  /// Whether the provider is in an empty state (no articles, no loading, no error)
  bool get isEmpty => _articles.isEmpty && !_isLoading && !_hasError;

  // ==================== Public Methods ====================

  /// Fetches top headlines from the repository
  /// 
  /// [forceRefresh] - If true, bypasses cache and fetches fresh data
  /// [country] - Country code for headlines (default: 'us')
  /// [category] - News category (default: 'general')
  /// 
  /// This method updates the UI state and notifies listeners
  Future<void> fetchTopHeadlines({
    bool forceRefresh = false,
    String country = 'us',
    String category = 'general',
  }) async {
    // Don't fetch if already loading
    if (_isLoading) return;

    _setLoadingState(true);
    _clearError();

    try {
      final List<Article> fetchedArticles = await _newsRepository.getTopHeadlines(
        forceRefresh: forceRefresh,
        country: country,
        category: category,
      );

      _articles = fetchedArticles;
      _setLoadingState(false);

      // Log success for debugging
      debugPrint('NewsProvider: Successfully fetched ${_articles.length} articles');
    } on NewsRepositoryException catch (e) {
      _handleRepositoryException(e);
    } catch (e) {
      _handleUnknownError(e);
    }
  }

  /// Searches for articles based on a query
  /// 
  /// [query] - Search query string
  /// [sortBy] - Sort order for results (default: 'publishedAt')
  /// 
  /// This method replaces current articles with search results
  Future<void> searchArticles({
    required String query,
    String sortBy = 'publishedAt',
  }) async {
    if (_isLoading) return;

    _setLoadingState(true);
    _clearError();

    try {
      final List<Article> searchResults = await _newsRepository.searchArticles(
        query: query,
        sortBy: sortBy,
      );

      _articles = searchResults;
      _setLoadingState(false);

      debugPrint('NewsProvider: Search returned ${_articles.length} articles for query: "$query"');
    } on NewsRepositoryException catch (e) {
      _handleRepositoryException(e);
    } catch (e) {
      _handleUnknownError(e);
    }
  }

  /// Refreshes the current articles (force refresh)
  Future<void> refreshArticles() async {
    await fetchTopHeadlines(forceRefresh: true);
  }

  /// Gets a specific article by URL
  /// 
  /// [url] - The URL of the article to find
  /// 
  /// Returns the article if found, null otherwise
  Article? getArticleByUrl(String url) {
    try {
      return _articles.firstWhere((article) => article.url == url);
    } catch (e) {
      return _newsRepository.getArticleByUrl(url);
    }
  }

  /// Clears all articles and resets state
  void clearArticles() {
    _articles = [];
    _clearError();
    notifyListeners();
  }

  /// Clears the current error state
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // ==================== Private Helper Methods ====================

  /// Sets the loading state and notifies listeners
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clears error state
  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  /// Sets error state and notifies listeners
  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  /// Handles NewsRepositoryException with appropriate error messages
  void _handleRepositoryException(NewsRepositoryException e) {
    String userFriendlyMessage;

    switch (e.type) {
      case NewsRepositoryExceptionType.network:
        userFriendlyMessage = 'No internet connection. Please check your network and try again.';
        break;
      case NewsRepositoryExceptionType.timeout:
        userFriendlyMessage = 'Request timed out. Please try again.';
        break;
      case NewsRepositoryExceptionType.authentication:
        userFriendlyMessage = 'API authentication failed. Please check the configuration.';
        break;
      case NewsRepositoryExceptionType.rateLimited:
        userFriendlyMessage = 'Too many requests. Please wait a moment and try again.';
        break;
      case NewsRepositoryExceptionType.configuration:
        userFriendlyMessage = 'App configuration error. Please contact support.';
        break;
      case NewsRepositoryExceptionType.validation:
        userFriendlyMessage = e.message;
        break;
      default:
        userFriendlyMessage = 'Something went wrong. Please try again later.';
    }

    _setError(userFriendlyMessage);
    debugPrint('NewsProvider Error: ${e.message}');
  }

  /// Handles unknown errors
  void _handleUnknownError(Object error) {
    _setError('An unexpected error occurred. Please try again.');
    debugPrint('NewsProvider Unknown Error: $error');
  }

  /// Disposes resources when the provider is no longer needed
  @override
  void dispose() {
    _newsRepository.dispose();
    super.dispose();
  }
}
