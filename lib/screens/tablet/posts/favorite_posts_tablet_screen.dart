import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/screens/mobile/posts/post_screen.dart';
import 'package:dister/screens/mobile/posts/api_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/controllers/favorite_service/api_favorite_service.dart';

class FavoritePostsTabletScreen extends StatefulWidget {
  const FavoritePostsTabletScreen({super.key});

  @override
  State<FavoritePostsTabletScreen> createState() =>
      _FavoritePostsTabletScreenState();
}

class _FavoritePostsTabletScreenState extends State<FavoritePostsTabletScreen> {
  late Future<List<Post>> _favoriteListingsFuture;
  final FirebaseServices firebaseServices = FirebaseServices();
  final ApiFavoriteService _apiFavoriteService = ApiFavoriteService();

  @override
  void initState() {
    super.initState();
    _favoriteListingsFuture = _getAllFavoriteListings();
  }

  Future<List<Post>> _getAllFavoriteListings() async {
    List<Post> allFavorites = [];

    final likesCollection = FirebaseFirestore.instance.collection('likes');
    final String currentUserId = firebaseServices.getCurrentUser();

    final normalLikesSnapshot =
        await likesCollection.where('userId', isEqualTo: currentUserId).get();
    final apiFavorites = await _apiFavoriteService.getFavoritePosts();

    for (var doc in normalLikesSnapshot.docs) {
      final data = doc.data();
      final listingId = data['listingId'];

      final listingSnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingId)
          .get();

      if (listingSnapshot.exists) {
        final listing = Post.fromFirestore(listingSnapshot);
        allFavorites.add(listing);
      }
    }

    allFavorites.addAll(apiFavorites);
    allFavorites.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return allFavorites;
  }

  Future<void> _removeFavorite(String userId, Post listing) async {
    if (listing.owner == 'api') {
      await _apiFavoriteService.toggleFavorite(listing);
    } else {
      final likesCollection = FirebaseFirestore.instance.collection('likes');
      final querySnapshot = await likesCollection
          .where('userId', isEqualTo: userId)
          .where('listingId', isEqualTo: listing.id)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  void _removeListingFromFavorites(String userId, Post listing) async {
    await _removeFavorite(userId, listing);
    setState(() {
      _favoriteListingsFuture = _getAllFavoriteListings();
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).removedFromFavorites)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = firebaseServices.getCurrentUser();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            S.of(context).favorites,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: _favoriteListingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(S.of(context).error(snapshot.error.toString())),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(S.of(context).noFavoritesYet));
              } else {
                final favorites = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final listing = favorites[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => listing.owner == 'api'
                                ? APIpostScreen(product: listing)
                                : PostScreen(listing: listing),
                          ),
                        );
                      },
                      child: Card(
                        color: colorScheme.surfaceContainer,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    listing.images.isNotEmpty
                                        ? listing.images[0]
                                        : 'assets/images/default.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listing.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '${listing.discountPrice}€',
                                            style: TextStyle(
                                              color: colorScheme.error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (listing.originalPrice >
                                              listing.discountPrice) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              '${listing.originalPrice}€',
                                              style: TextStyle(
                                                color: colorScheme.outline,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        S.of(context).publishedOn(
                                            DateFormat('dd/MM/yyyy HH:mm')
                                                .format(listing.publishedAt)),
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  _removeListingFromFavorites(
                                      currentUserId, listing);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: colorScheme.error,
                                    size: 20,
                                  ),
                                ),
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
