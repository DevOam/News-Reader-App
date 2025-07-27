import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/news_provider.dart';
import 'presentation/screens/article_list_screen.dart';
import 'presentation/screens/article_detail_screen.dart';
import 'core/constants/app_constants.dart';

/// Main entry point of the News Reader application
/// 
/// This is a professional Flutter news reader app built for a technical test.
/// The app demonstrates clean architecture, proper state management,
/// and modern Flutter development practices.
void main() {
  runApp(const NewsReaderApp());
}

/// Root widget of the News Reader application
/// 
/// This widget sets up the app's theme, routing, and global providers.
class NewsReaderApp extends StatelessWidget {
  const NewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsProvider(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const ArticleListScreen(),
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  /// Builds the app's theme using Material 3 design
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.smallPadding,
          ),
        ),
      ),
    );
  }

  /// Generates routes for navigation
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const ArticleListScreen(),
        );
      case '/article-detail':
        final articleUrl = settings.arguments as String?;
        if (articleUrl != null) {
          return MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(articleUrl: articleUrl),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  /// Returns an error route for unknown routes
  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
