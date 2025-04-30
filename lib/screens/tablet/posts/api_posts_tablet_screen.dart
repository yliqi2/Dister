import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dister/models/post_model.dart';
import 'package:dister/screens/mobile/posts/api_post_screen.dart';
import 'package:dister/generated/l10n.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:dister/screens/mobile/chat/chat_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPostsTabletScreen extends StatefulWidget {
  const ApiPostsTabletScreen({super.key});

  @override
  State<ApiPostsTabletScreen> createState() => _ApiPostsTabletScreenState();
}

class _ApiPostsTabletScreenState extends State<ApiPostsTabletScreen> {
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

        return Post(
          id: json['id'] ?? '',
          title: json['title'] ?? '',
          desc: json['description'] ?? '',
          images: [json['image'] ?? ''],
          owner: '',
          categories: '',
          subcategories: '',
          link: json['url'] ?? '',
          originalPrice: parsePrice(json['originalPrice']),
          discountPrice: parsePrice(json['price']),
          storeName: json['storeName'] ?? '',
          publishedAt: DateTime.now(),
          likes: 0,
          highlights: [],
        );
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            S.of(context).onlinePosts,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: AnimatedTextField(
                  controller: _searchController,
                  animationType: Animationtype.typer,
                  onChanged: (value) {
                    setState(() {
                      _productsFuture = fetchProducts(value);
                    });
                  },
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
              const SizedBox(width: 16),
              IconButton(
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
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(S.of(context).error(snapshot.error.toString())),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(S.of(context).noListingsAvailable));
              } else {
                final products = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                APIpostScreen(product: product),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.images.isNotEmpty
                                    ? product.images[0]
                                    : 'assets/images/default.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.discountPrice}€',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
