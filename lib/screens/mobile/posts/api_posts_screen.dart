import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dister/models/post_model.dart';
import 'package:dister/screens/mobile/posts/api_post_screen.dart';
import 'package:dister/widgets/api_post_container.dart';
import 'package:dister/generated/l10n.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:dister/screens/mobile/chat/chat_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPostsScreen extends StatefulWidget {
  const ApiPostsScreen({super.key});

  @override
  State<ApiPostsScreen> createState() => _ApiPostsState();
}

class _ApiPostsState extends State<ApiPostsScreen> {
  late Future<List<Post>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;

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
      'x-rapidapi-key': dotenv.env['RAPIDAPI_KEY'] ?? '',
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
                Padding(
                  padding: const EdgeInsets.only(right: 26, left: 20),
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
                      SizedBox(
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
                      childAspectRatio: 0.85,
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
                                  APIpostScreen(product: post),
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
