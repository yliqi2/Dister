import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/pages/mobile/listingdetail/listingdetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dister/controller/firebase/services/firebase_services.dart'; // Importa FirebaseServices
import 'package:dister/model/listing.dart'; // Importa el modelo Listing
import 'package:dister/generated/l10n.dart';

class Savelisting extends StatefulWidget {
  const Savelisting({super.key});

  @override
  State<Savelisting> createState() => _SavelistingState();
}

class _SavelistingState extends State<Savelisting> {
  late Future<List<Listing>> _favoriteListingsFuture;
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    final String currentUserId = firebaseServices.getCurrentUser();
    _favoriteListingsFuture = _getFavoriteListings(currentUserId);
  }

  Future<List<Listing>> _getFavoriteListings(String userId) async {
    final likesCollection = FirebaseFirestore.instance.collection('likes');
    final querySnapshot =
        await likesCollection.where('userId', isEqualTo: userId).get();

    List<Listing> favoriteListings = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final listingId = data['listingId'];

      // Fetch the listing details from the listings collection
      final listingSnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .doc(listingId)
          .get();

      if (listingSnapshot.exists) {
        // Convert the Firestore document into a Listing object
        final listing = Listing.fromFirestore(listingSnapshot);
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
      await doc.reference.delete(); // Elimina el documento del like
    }
  }

  void _removeListingFromFavorites(String userId, Listing listing) async {
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
      body: FutureBuilder<List<Listing>>(
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
                  child: ListTile(
                    leading: listing.images.isNotEmpty
                        ? Image.network(
                            listing.images[0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(listing.title),
                    subtitle: Text(S.of(context).publishedOn(createdAt)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        _removeListingFromFavorites(currentUserId, listing);
                      },
                    ),
                    onTap: () {
                      // Navegar a la página de detalles pasando el objeto listing
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Listingdetails(
                            listing: listing, // Pasar el objeto completo
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
