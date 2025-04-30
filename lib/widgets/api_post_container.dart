import 'package:flutter/material.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/controllers/favorite_service/api_favorite_service.dart';

class APIpostContainer extends StatelessWidget {
  final Post listing;
  final VoidCallback? onTap;
  final bool colorChange;
  final ApiFavoriteService _favoriteService = ApiFavoriteService();

  APIpostContainer({
    super.key,
    required this.listing,
    this.onTap,
    this.colorChange = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sellerName = listing.storeName.isNotEmpty
        ? listing.storeName
        : S.of(context).tiendalabel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.45,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? colorChange
                  ? colorScheme.surface
                  : colorScheme.surfaceContainer
              : colorScheme.surfaceContainer.withAlpha(242),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.outline.withAlpha(50)
                : colorScheme.outline.withAlpha(77),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      sellerName,
                      maxLines: 1,
                      style: theme.textTheme.bodySmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          S.of(context).likesText(listing.likes.toString()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (listing.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Image.network(
                    listing.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              listing.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${listing.discountPrice.toStringAsFixed(0)}€",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${listing.originalPrice.toStringAsFixed(0)}€",
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                StreamBuilder<bool>(
                  stream: _favoriteService.watchFavoriteStatus(listing.id),
                  builder: (context, snapshot) {
                    final bool isFavorite = snapshot.data ?? false;
                    return InkWell(
                      onTap: () => _favoriteService.toggleFavorite(listing),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : colorScheme.outline,
                        size: 25,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
