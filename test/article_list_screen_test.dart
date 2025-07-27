import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:news_reader_app/presentation/screens/article_list_screen.dart';
import 'package:news_reader_app/presentation/providers/news_provider.dart';
import 'package:news_reader_app/data/models/article.dart';

/// Minimal mock NewsProvider for loading state test
class MockLoadingNewsProvider extends ChangeNotifier implements NewsProvider {
  @override
  bool get isLoading => true;
  @override
  bool get hasArticles => false;
  @override
  bool get hasError => false;
  @override
  bool get isEmpty => true;
  @override
  List<Article> get articles => <Article>[];
  @override
  String? get errorMessage => null;
  // Stub required methods
  @override
  void clearArticles() {}
  @override
  void clearError() {}
  @override
  Future<void> fetchTopHeadlines({String category = '', String country = '', bool forceRefresh = false}) async {}
  @override
  Article? getArticleByUrl(String url) => null;
  @override
  Future<void> refreshArticles() async {}
  @override
  Future<void> searchArticles({required String query, String sortBy = ''}) async {}
}

void main() {
  testWidgets('ArticleListScreen shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<NewsProvider>.value(
          value: MockLoadingNewsProvider(),
          child: const ArticleListScreen(),
        ),
      ),
    );

    // Expect to find a loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading latest news...'), findsOneWidget);
  });
}
