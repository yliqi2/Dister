import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dister/model/post.dart';
import 'package:dister/pages/mobile/posts_details/api_posts_details.dart';
import 'package:dister/widgets/api_post_container.dart';
import 'package:dister/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:dister/pages/mobile/screens/chat_list_screen.dart';

class ApiProduct {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double? rating;
  final String? seller;

  ApiProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.rating,
    this.seller,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['product_id']?.toString() ?? '',
      title: json['product_title'] ?? '',
      imageUrl: (json['product_photos'] != null &&
              json['product_photos'] is List &&
              json['product_photos'].isNotEmpty)
          ? json['product_photos'][0]
          : '',
      price: (json['product_min_price'] is num)
          ? (json['product_min_price'] as num).toDouble()
          : 0.0,
      originalPrice: (json['product_max_price'] is num)
          ? (json['product_max_price'] as num).toDouble()
          : null,
      rating: (json['product_rating'] is num)
          ? (json['product_rating'] as num).toDouble()
          : null,
      seller: json['product_seller'] ?? null,
    );
  }
}

class APIposts extends StatefulWidget {
  const APIposts({super.key});

  @override
  State<APIposts> createState() => _APIpostsState();
}

class _APIpostsState extends State<APIposts> {
  late Future<List<Post>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _productsFuture = fetchProducts('tecnologia');
      _initialized = true;
    }
  }

  Future<List<Post>> fetchProducts(String query) async {
    final url = Uri.parse(
        'https://real-time-product-search.p.rapidapi.com/search?q=${query.isEmpty ? "tecnologia" : query}&country=es&language=${Localizations.localeOf(context).languageCode}&page=1&limit=1&sort_by=BEST_MATCH&product_condition=NEW&on_sale=true&min_rating=3');
    final response = await http.get(url, headers: {
      'x-rapidapi-key': '', //API KEY HERE
      'x-rapidapi-host': 'real-time-product-search.p.rapidapi.com',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] == null || data['data']['products'] == null) {
        return [];
      }
      final List products = data['data']['products'] as List;
      return products.map<Post>((json) {
        double parsePrice(dynamic value) {
          if (value == null) return 1.0;
          if (value is num) return value.toDouble();
          if (value is String) {
            final cleaned =
                value.replaceAll(RegExp(r'[^0-9,\.]'), '').replaceAll(',', '.');
            return double.tryParse(cleaned) ?? 1.0;
          }
          return 1.0;
        }

        final offer = json['offer'] ?? {};
        double discountPrice = 1.0;
        double originalPrice = 1.0;
        if (offer['price'] != null) {
          discountPrice = parsePrice(offer['price']);
        } else if (json['typical_price_range'] != null &&
            json['typical_price_range'] is List &&
            json['typical_price_range'].isNotEmpty) {
          discountPrice = parsePrice(json['typical_price_range'][0]);
        } else if (json['product_min_price'] != null) {
          discountPrice = parsePrice(json['product_min_price']);
        }
        if (offer['original_price'] != null) {
          originalPrice = parsePrice(offer['original_price']);
        } else if (json['typical_price_range'] != null &&
            json['typical_price_range'] is List &&
            json['typical_price_range'].length > 1) {
          originalPrice = parsePrice(json['typical_price_range'][1]);
        } else if (json['product_max_price'] != null) {
          originalPrice = parsePrice(json['product_max_price']);
        } else {
          originalPrice = discountPrice;
        }
        String storeName = offer['store_name'] ?? '';
        String link = offer['offer_page_url'] ?? json['product_page_url'] ?? '';
        List<String> images = [];
        if (json['product_photos'] != null && json['product_photos'] is List) {
          images = List<String>.from(json['product_photos']);
        }

        return Post(
          id: json['product_id']?.toString() ?? '',
          title: json['product_title'] ?? '',
          desc: json['product_description'] ?? '',
          publishedAt: DateTime.now(),
          expiresAt: null,
          link: link,
          originalPrice: originalPrice,
          discountPrice: discountPrice,
          storeName: storeName,
          categories: '',
          subcategories: '',
          likes: (json['product_num_reviews'] is num)
              ? (json['product_num_reviews'] as num).toInt()
              : 0,
          rating: (json['product_rating'] is num)
              ? (json['product_rating'] as num).toDouble()
              : null,
          images: images,
          highlights: [],
          owner: 'api',
        );
      }).toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  void _performSearch() {
    setState(() {
      _productsFuture = fetchProducts(_searchController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width > 600 ? 4 : 2;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              floating: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/images/dister.png',
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 70,
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 26.0, left: 20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.chat_bubble_rounded,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FollowingListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedTextField(
                          controller: _searchController,
                          animationType: Animationtype.typer,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          hintTexts: [
                            S.of(context).searchHint,
                            S.of(context).searchHint2,
                            S.of(context).searchHint3,
                          ],
                          animationDuration: const Duration(seconds: 3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 48,
                        width: 48,
                        child: ElevatedButton(
                          onPressed: _performSearch,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFFFF4343),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.search,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
              sliver: FutureBuilder<List<Post>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                            S.of(context).error(snapshot.error.toString())),
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.675,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = products[index];
                        return APIpostContainer(
                          listing: post,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ApiPostsDetails(product: post),
                            ),
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiProduct extends StatelessWidget {
  final ApiProduct product;
  const _ApiProduct({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? colorScheme.surface
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
          if (product.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 1.25,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            product.title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                "${product.price.toStringAsFixed(2)}€",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              if (product.originalPrice != null &&
                  product.originalPrice! > product.price) ...[
                const SizedBox(width: 5),
                Text(
                  "${product.originalPrice!.toStringAsFixed(2)}€",
                  style: theme.textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ],
          ),
          if (product.rating != null)
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(product.rating!.toStringAsFixed(1)),
              ],
            ),
          if (product.seller != null)
            Text(
              'Vendedor: ${product.seller}',
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
