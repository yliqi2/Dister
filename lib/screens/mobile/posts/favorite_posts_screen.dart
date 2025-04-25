import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/screens/mobile/posts/post_screen.dart';
import 'package:dister/screens/mobile/posts/api_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/generated/l10n.dart';

class FavoritePostsScreen extends StatefulWidget {
  const FavoritePostsScreen({super.key});

  @override
  State<FavoritePostsScreen> createState() => _FavoritePostsScreenState();
}

class _FavoritePostsScreenState extends State<FavoritePostsScreen> {
  late Future<List<Post>> _favoriteListingsFuture;
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    final String currentUserId = firebaseServices.getCurrentUser();
    _favoriteListingsFuture = _getAllFavoriteListings(currentUserId);
  }

  Future<List<Post>> _getAllFavoriteListings(String userId) async {
    List<Post> allFavorites = [];

    final likesCollection = FirebaseFirestore.instance.collection('likes');
    final apiFavoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('api_favorites');

    final normalLikesSnapshot =
        await likesCollection.where('userId', isEqualTo: userId).get();
    final apiFavoritesSnapshot = await apiFavoritesCollection.get();

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

    for (var doc in apiFavoritesSnapshot.docs) {
      final data = doc.data();
      final listing = Post(
        id: doc.id,
        title: data['title'] ?? '',
        desc: data['desc'] ?? '',
        link: data['link'] ?? '',
        originalPrice: (data['originalPrice'] ?? 0.0).toDouble(),
        discountPrice: (data['discountPrice'] ?? 0.0).toDouble(),
        storeName: data['storeName'] ?? '',
        images: List<String>.from(data['images'] ?? []),
        rating: data['rating']?.toDouble(),
        categories: '',
        subcategories: '',
        likes: 0,
        highlights: [],
        owner: 'api',
        publishedAt:
            (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
      allFavorites.add(listing);
    }

    allFavorites.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return allFavorites;
  }

  Future<void> _removeFavorite(String userId, Post listing) async {
    if (listing.owner == 'api') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('api_favorites')
          .doc(listing.id)
          .delete();
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
      _favoriteListingsFuture = _getAllFavoriteListings(userId);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).favorites),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Post>>(
        future: _favoriteListingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(S.of(context).error(snapshot.error.toString())));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).noFavoritesYet));
          } else {
            final favoriteListings = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteListings.length,
              itemBuilder: (context, index) {
                final listing = favoriteListings[index];
                final createdAt =
                    DateFormat('dd/MM/yyyy HH:mm').format(listing.publishedAt);

                return Card(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: listing.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              listing.images[0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      listing.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      S.of(context).publishedOn(createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        _removeListingFromFavorites(currentUserId, listing);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: colorScheme.error,
                        size: 22,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => listing.owner == 'api'
                              ? APIpostScreen(product: listing)
                              : PostScreen(listing: listing),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
