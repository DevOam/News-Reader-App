import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../../core/constants/app_constants.dart';

/// Main screen displaying the list of news articles
/// 
/// This screen shows a scrollable list of news articles with pull-to-refresh
/// functionality, error handling, and loading states. It uses the NewsProvider
/// to manage state and fetch data from the API.
class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch articles when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchTopHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          return RefreshIndicator(
            onRefresh: () => newsProvider.refreshArticles(),
            child: _buildBody(newsProvider),
          );
        },
      ),
    );
  }

  /// Builds the app bar with title and optional actions
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        AppConstants.appName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      actions: [
        Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            return IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: newsProvider.isLoading 
                  ? null 
                  : () => newsProvider.refreshArticles(),
              tooltip: 'Refresh articles',
            );
          },
        ),
      ],
    );
  }

  /// Builds the main body content based on the current state
  /// Shows loading, error, empty, or the articles list.
  Widget _buildBody(NewsProvider newsProvider) {
    // Show loading state when fetching articles
    if (newsProvider.isLoading && !newsProvider.hasArticles) {
      return const LoadingWidget(
        message: 'Loading latest news...',
      );
    }

    // Show error state if there is a network or API error and no articles
    if (newsProvider.hasError && !newsProvider.hasArticles) {
      // Show a SnackBar for user feedback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newsProvider.errorMessage ?? 'An error occurred while fetching news.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      });
      return NewsErrorWidget(
        message: newsProvider.errorMessage ?? 'An error occurred',
        onRetry: () => newsProvider.fetchTopHeadlines(forceRefresh: true),
      );
    }

    // Show empty state if there are no articles
    if (newsProvider.isEmpty) {
      return const EmptyStateWidget(
        message: 'No articles available',
        icon: Icons.article_outlined,
      );
    }

    // Show articles list if articles are available
    return _buildArticlesList(newsProvider);
  }

  /// Builds the scrollable list of articles
  Widget _buildArticlesList(NewsProvider newsProvider) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Error banner if there's an error but we still have articles
        if (newsProvider.hasError && newsProvider.hasArticles)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppConstants.defaultPadding),
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      newsProvider.errorMessage ?? 'Something went wrong',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => newsProvider.clearError(),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Articles list
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final article = newsProvider.articles[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.defaultPadding,
                  ),
                  child: ArticleCard(
                    article: article,
                    onTap: () => _navigateToArticleDetail(article.url),
                  ),
                );
              },
              childCount: newsProvider.articles.length,
            ),
          ),
        ),

        // Loading indicator at the bottom if refreshing
        if (newsProvider.isLoading && newsProvider.hasArticles)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: AppConstants.defaultPadding),
        ),
      ],
    );
  }

  /// Navigates to the article detail screen
  void _navigateToArticleDetail(String articleUrl) {
    Navigator.of(context).pushNamed(
      '/article-detail',
      arguments: articleUrl,
    );
  }
}
