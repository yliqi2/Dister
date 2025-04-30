import 'package:flutter/material.dart';
import 'package:dister/models/post_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/controllers/favorite_service/api_favorite_service.dart';

class APIpostScreen extends StatelessWidget {
  final Post product;
  final ApiFavoriteService _favoriteService = ApiFavoriteService();

  APIpostScreen({super.key, required this.product});

  void _launchURL(BuildContext context) async {
    final url = product.link;
    if (url.isNotEmpty) {
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }
      final uri = Uri.parse(formattedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).cannotOpenLink)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final images = product.images;
    final pageController = PageController();

    double percentOff = 0;
    if (product.originalPrice > 0 &&
        product.originalPrice > product.discountPrice) {
      percentOff = ((product.originalPrice - product.discountPrice) /
              product.originalPrice) *
          100;
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.storeName.isNotEmpty ? product.storeName : 'Producto',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<bool>(
            stream: _favoriteService.watchFavoriteStatus(product.id),
            builder: (context, snapshot) {
              final bool isFavorite = snapshot.data ?? false;
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: colorScheme.error,
                ),
                onPressed: () => _favoriteService.toggleFavorite(product),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: pageController,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 100),
                            );
                          },
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmoothPageIndicator(
                                  controller: pageController,
                                  count: images.length,
                                  effect: WormEffect(
                                    dotHeight: 16,
                                    dotWidth: 16,
                                    dotColor: Colors.grey,
                                    activeDotColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (percentOff > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? colorScheme.surfaceContainerHighest
                                      : colorScheme.primary.withAlpha(26),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '-${percentOff.round()}%',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? colorScheme.onSurfaceVariant
                                        : colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${product.discountPrice.toStringAsFixed(2)}€',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.error,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.originalPrice > product.discountPrice)
                              Text(
                                '${product.originalPrice.toStringAsFixed(2)}€',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: colorScheme.outline,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          S.of(context).productDetails,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.desc,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant.withAlpha(128),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          S.of(context).shoppingDetails,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.storeName.isNotEmpty)
                              Text(
                                S.of(context).storePrefix(product.storeName),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant
                                      .withAlpha(200),
                                ),
                              ),
                            Row(
                              children: [
                                const Text('• ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  S
                                      .of(context)
                                      .likesText(product.likes.toString()),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha(200),
                                  ),
                                ),
                              ],
                            ),
                            if (product.rating != null)
                              Text(
                                S.of(context).ratingWithStars(
                                    product.rating!.toStringAsFixed(1)),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant
                                      .withAlpha(200),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.error,
        child: InkWell(
          onTap: () => _launchURL(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              S.of(context).goForDiscount,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
