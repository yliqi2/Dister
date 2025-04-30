import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/sidebar_tablet.dart';

class ApiPostTabletScreen extends StatelessWidget {
  final Post product;

  const ApiPostTabletScreen({super.key, required this.product});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(product.link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch ${product.link}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarTablet(
              selectedIndex: 0,
              onTap: (index) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.images.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.images[0],
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        product.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.desc,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            '${product.discountPrice}€',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          if (product.originalPrice >
                              product.discountPrice) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${product.originalPrice}€',
                              style: const TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${S.of(context).tiendalabel}: ${product.storeName}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _launchUrl,
                          child: Text(S.of(context).goForDiscount),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
