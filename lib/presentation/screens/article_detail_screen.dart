import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../providers/news_provider.dart';
import '../../data/models/article.dart';
import '../../core/constants/app_constants.dart';

/// Screen that displays the full details of a news article
/// 
/// This screen shows the article's image, title, content, source information,
/// and provides a button to read the full article on the source website.
class ArticleDetailScreen extends StatelessWidget {
  final String articleUrl;

  const ArticleDetailScreen({
    super.key,
    required this.articleUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final article = newsProvider.getArticleByUrl(articleUrl);
        
        if (article == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Article Not Found'),
            ),
            body: const Center(
              child: Text('Article not found'),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, article),
              SliverToBoxAdapter(
                child: _buildContent(context, article),
              ),
            ],
          ),
          floatingActionButton: _buildReadMoreFab(context, article),
        );
      },
    );
  }

  /// Builds the sliver app bar with the article image
  Widget _buildSliverAppBar(BuildContext context, Article article) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: article.imageUrl != null && article.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: article.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  /// Builds the main content section
  Widget _buildContent(BuildContext context, Article article) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context, article),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildMetadata(context, article),
          const SizedBox(height: AppConstants.largePadding),
          _buildDescription(context, article),
          if (article.content != null && article.content!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.largePadding),
            Text(article.content!),
          ],
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  /// Builds the article title
  Widget _buildTitle(BuildContext context, Article article) {
    return Text(
      article.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }

  /// Builds the metadata section (source, author, date)
  Widget _buildMetadata(BuildContext context, Article article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.source?.name != null)
          Row(
            children: [
              Icon(
                Icons.source_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                article.source!.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        if (article.author != null && article.author!.isNotEmpty) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: Text(
                  'By ${article.author}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (article.publishedAt != null) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                DateFormat(AppConstants.fullDateTimeFormat)
                    .format(article.publishedAt!),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Builds the article description
  Widget _buildDescription(BuildContext context, Article article) {
    if (article.description == null || article.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          article.description!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// Builds the article content section
  Widget _buildContentSection(BuildContext context, Article article) {
    if (article.content == null || article.content!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Clean up the content (NewsAPI sometimes truncates with [+chars])
    String content = article.content!;
    final truncateIndex = content.indexOf('[+');
    if (truncateIndex != -1) {
      content = content.substring(0, truncateIndex).trim();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Content',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
        if (truncateIndex != -1) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Content truncated. Read the full article for more details.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the floating action button for reading the full article
  Widget _buildReadMoreFab(BuildContext context, Article article) {
    return FloatingActionButton.extended(
      onPressed: () => _launchUrl(context, article.url),
      icon: const Icon(Icons.open_in_new),
      label: const Text('Read Full Article'),
    );
  }

  /// Launches the article URL in the browser, shows SnackBar if not possible
  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    debugPrint('Trying to launch URL: ' + url); // Debug print
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid link: missing http/https.'),
        ),
      );
      return;
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No app found to open the link. Please check your browser installation.'),
        ),
      );
    }
  }
}
