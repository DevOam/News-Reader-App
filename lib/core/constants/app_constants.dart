/// Application-wide constants and configuration values
/// 
/// This file contains all the constant values used throughout the application
/// including API endpoints, UI dimensions, and other configuration settings.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ==================== API Configuration ====================
  
  /// Base URL for NewsAPI
  static const String baseUrl = 'https://newsapi.org/v2';
  
  /// API endpoint for top headlines
  static const String topHeadlinesEndpoint = '/top-headlines';
  
  /// API endpoint for everything (search)
  static const String everythingEndpoint = '/everything';
  
  /// Default country code for news
  static const String defaultCountry = 'us';
  
  /// Default category for news
  static const String defaultCategory = 'general';
  
  /// Default page size for API requests
  static const int defaultPageSize = 20;
  
  /// Maximum page size allowed by NewsAPI
  static const int maxPageSize = 100;

  // ==================== API Key Configuration ====================
  
  /// NewsAPI key - Configured with user's actual API key
  /// Get your free API key from: https://newsapi.org/register
  static const String apiKey = '5adaa072f925402db22a37ec65f17459';
  
  // ==================== UI Constants ====================
  
  /// Default padding for screens
  static const double defaultPadding = 16.0;
  
  /// Small padding
  static const double smallPadding = 8.0;
  
  /// Large padding
  static const double largePadding = 24.0;
  
  /// Default border radius
  static const double defaultBorderRadius = 12.0;
  
  /// Card elevation
  static const double cardElevation = 4.0;
  
  /// Image aspect ratio for article cards
  static const double imageAspectRatio = 16 / 9;
  
  /// Maximum lines for article title in cards
  static const int titleMaxLines = 2;
  
  /// Maximum lines for article description in cards
  static const int descriptionMaxLines = 3;

  // ==================== Animation Constants ====================
  
  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  /// Fast animation duration
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  
  /// Slow animation duration
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // ==================== Error Messages ====================
  
  /// Generic network error message
  static const String networkErrorMessage = 
      'Network error. Please check your internet connection and try again.';
  
  /// Generic server error message
  static const String serverErrorMessage = 
      'Server error. Please try again later.';
  
  /// No articles found message
  static const String noArticlesMessage = 
      'No articles found. Please try again later.';
  
  /// API key missing message
  static const String apiKeyMissingMessage = 
      'API key is missing. Please configure your NewsAPI key.';

  // ==================== App Information ====================
  
  /// Application name
  static const String appName = 'News Reader';
  
  /// Application version
  static const String appVersion = '1.0.0';
  
  /// Developer information
  static const String developerName = 'Flutter Developer';
  
  /// Application description
  static const String appDescription = 
      'A professional news reader application built with Flutter';

  // ==================== Date Formats ====================
  
  /// Date format for displaying article publication date
  static const String articleDateFormat = 'MMM dd, yyyy';
  
  /// Time format for displaying article publication time
  static const String articleTimeFormat = 'HH:mm';
  
  /// Full date-time format
  static const String fullDateTimeFormat = 'MMM dd, yyyy HH:mm';

  // ==================== Cache Configuration ====================
  
  /// Cache duration for images
  static const Duration imageCacheDuration = Duration(days: 7);
  
  /// Cache duration for API responses
  static const Duration apiCacheDuration = Duration(minutes: 30);
}
