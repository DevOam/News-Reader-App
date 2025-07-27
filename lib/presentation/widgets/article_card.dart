import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../data/models/article.dart';
import '../../core/constants/app_constants.dart';

/// A card widget that displays an article's information
/// 
/// This widget shows the article's image, title, description, source,
/// and publication date in a Material Design card format.
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  /// Builds the article image section
  Widget _buildImage(BuildContext context) {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return _buildPlaceholderImage(context);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppConstants.defaultBorderRadius),
        topRight: Radius.circular(AppConstants.defaultBorderRadius),
      ),
      child: AspectRatio(
        aspectRatio: AppConstants.imageAspectRatio,
        child: CachedNetworkImage(
          imageUrl: article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(),
          errorWidget: (context, url, error) => _buildPlaceholderImage(context),
          fadeInDuration: AppConstants.fastAnimationDuration,
          fadeOutDuration: AppConstants.fastAnimationDuration,
        ),
      ),
    );
  }

  /// Builds a placeholder when image is not available
  Widget _buildPlaceholderImage(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppConstants.defaultBorderRadius),
        topRight: Radius.circular(AppConstants.defaultBorderRadius),
      ),
      child: AspectRatio(
        aspectRatio: AppConstants.imageAspectRatio,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Icon(
            Icons.article_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// Builds the loading placeholder for images
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds the content section with title, description, and metadata
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: AppConstants.smallPadding),
          if (article.description != null && article.description!.isNotEmpty)
            _buildDescription(context),
          const SizedBox(height: AppConstants.smallPadding),
          _buildMetadata(context),
        ],
      ),
    );
  }

  /// Builds the article title
  Widget _buildTitle(BuildContext context) {
    return Text(
      article.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      maxLines: AppConstants.titleMaxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the article description
  Widget _buildDescription(BuildContext context) {
    return Text(
      article.description!,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      maxLines: AppConstants.descriptionMaxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the metadata section (source and date)
  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        // Source information
        if (article.source?.name != null)
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.source_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    article.source!.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        
        // Publication date
        if (article.publishedAt != null)
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(article.publishedAt!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
      ],
    );
  }

  /// Formats the publication date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat(AppConstants.articleDateFormat).format(date);
    }
  }
}
