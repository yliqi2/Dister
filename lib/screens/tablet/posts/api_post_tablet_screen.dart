import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/sidebar_tablet.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';
import 'package:dister/controllers/favorite_service/api_favorite_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ApiPostTabletScreen extends StatelessWidget {
  final Post product;
  final ApiFavoriteService _favoriteService = ApiFavoriteService();

  ApiPostTabletScreen({super.key, required this.product});

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
    final pageController = PageController();

    double percentOff = 0;
    if (product.originalPrice > 0 &&
        product.originalPrice > product.discountPrice) {
      percentOff = ((product.originalPrice - product.discountPrice) /
              product.originalPrice) *
          100;
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarTablet(
              selectedIndex: 1,
              onTap: (index) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomeTabletScreen(initialIndex: index),
                  ),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: colorScheme.surface,
                    leading: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      product.storeName.isNotEmpty
                          ? product.storeName
                          : S.of(context).tiendalabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      StreamBuilder<bool>(
                        stream:
                            _favoriteService.watchFavoriteStatus(product.id),
                        builder: (context, snapshot) {
                          final bool isFavorite = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: colorScheme.error,
                            ),
                            onPressed: () =>
                                _favoriteService.toggleFavorite(product),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.images.isNotEmpty)
                            SizedBox(
                              height: 400,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: pageController,
                                    itemCount: product.images.length,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        product.images[index],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    size: 100),
                                      );
                                    },
                                  ),
                                  if (product.images.length > 1)
                                    Positioned(
                                      bottom: 16,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SmoothPageIndicator(
                                            controller: pageController,
                                            count: product.images.length,
                                            effect: WormEffect(
                                              dotHeight: 16,
                                              dotWidth: 16,
                                              dotColor: Colors.grey,
                                              activeDotColor:
                                                  colorScheme.primary,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.title,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
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
                                          color: colorScheme.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          S.of(context).percentOff(
                                              percentOff.round().toString()),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      '${product.discountPrice}€',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (product.originalPrice >
                                        product.discountPrice)
                                      Text(
                                        '${product.originalPrice}€',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  S.of(context).productDetails,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.desc,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha(128),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  S.of(context).shoppingDetails,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (product.storeName.isNotEmpty)
                                      Text(
                                        S
                                            .of(context)
                                            .storePrefix(product.storeName),
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: colorScheme.onSurfaceVariant
                                              .withAlpha(200),
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '• ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurfaceVariant
                                                .withAlpha(200),
                                          ),
                                        ),
                                        Text(
                                          S.of(context).likesText(
                                              product.likes.toString()),
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant
                                                .withAlpha(200),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (product.rating != null)
                                      Text(
                                        S.of(context).ratingWithStars(
                                            product.rating!.toStringAsFixed(1)),
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
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
                  if (product.link.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () => _launchURL(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          S.of(context).goForDiscount,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onError,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
