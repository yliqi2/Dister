import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/pages/mobile/listingdetail/listingdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/post.dart';
import 'package:dister/generated/l10n.dart';

class FavoritePosts extends StatefulWidget {
  const FavoritePosts({super.key});

  @override
  State<FavoritePosts> createState() => _FavoritePostsState();
}

class _FavoritePostsState extends State<FavoritePosts> {
  late Future<List<Post>> _favoriteListingsFuture;
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    final String currentUserId = firebaseServices.getCurrentUser();
    _favoriteListingsFuture = _getFavoriteListings(currentUserId);
  }

  Future<List<Post>> _getFavoriteListings(String userId) async {
    final likesCollection = FirebaseFirestore.instance.collection('likes');
    final querySnapshot =
        await likesCollection.where('userId', isEqualTo: userId).get();

    List<Post> favoriteListings = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final listingId = data['listingId'];

      final listingSnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingId)
          .get();

      if (listingSnapshot.exists) {
        final listing = Post.fromFirestore(listingSnapshot);
        favoriteListings.add(listing);
      }
    }

    return favoriteListings;
  }

  Future<void> _removeLike(String userId, String listingId) async {
    final likesCollection = FirebaseFirestore.instance.collection('likes');
    final querySnapshot = await likesCollection
        .where('userId', isEqualTo: userId)
        .where('listingId', isEqualTo: listingId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  void _removeListingFromFavorites(String userId, Post listing) async {
    await _removeLike(userId, listing.id);
    setState(() {
      _favoriteListingsFuture = _getFavoriteListings(userId);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).removedFromFavorites),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = firebaseServices.getCurrentUser();

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
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Theme.of(context).colorScheme.onError,
                          size: 18,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Listingdetails(
                            listing: listing,
                          ),
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
