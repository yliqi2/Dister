import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/screens/mobile/posts/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/generated/l10n.dart';

class FavoritePostsTabletScreen extends StatelessWidget {
  const FavoritePostsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            future: _getAllFavoriteListings(context),
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
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final listing = favorites[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostScreen(listing: listing),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text(
                                    '${listing.discountPrice}€',
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

  Future<List<Post>> _getAllFavoriteListings(BuildContext context) async {
    final FirebaseServices firebaseServices = FirebaseServices();
    final String currentUserId = firebaseServices.getCurrentUser();
    List<Post> allFavorites = [];

    final likesCollection = FirebaseFirestore.instance.collection('likes');
    final apiFavoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('api_favorites');

    final normalLikesSnapshot =
        await likesCollection.where('userId', isEqualTo: currentUserId).get();
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
        desc: data['description'] ?? '',
        images: data['images'] ?? [],
        owner: data['owner'] ?? '',
        categories: data['categories'] ?? '',
        subcategories: data['subcategories'] ?? '',
        link: data['link'] ?? '',
        originalPrice: data['originalPrice'] ?? 0.0,
        discountPrice: data['discountPrice'] ?? 0.0,
        storeName: data['storeName'] ?? '',
        publishedAt: DateTime.now(),
        likes: 0,
        highlights: [],
      );
      allFavorites.add(listing);
    }

    return allFavorites;
  }
}
