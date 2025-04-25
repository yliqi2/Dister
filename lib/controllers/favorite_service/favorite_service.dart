import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String _likesCollection = 'likes';
  final String _listingsCollection = 'listings';

  Future<bool> hasUserLiked(String listingId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final likeDoc = await _firestore
        .collection(_likesCollection)
        .doc('${listingId}_$userId')
        .get();

    return likeDoc.exists;
  }

  Future<void> toggleLike(String listingId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    final likeDocRef =
        _firestore.collection(_likesCollection).doc('${listingId}_$userId');

    final listingRef =
        _firestore.collection(_listingsCollection).doc(listingId);

    await _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeDocRef);
      final listingDoc = await transaction.get(listingRef);

      if (!listingDoc.exists) {
        throw Exception('Listing no encontrado');
      }

      final currentLikes = listingDoc.data()?['likes'] ?? 0;

      if (likeDoc.exists) {
        transaction.delete(likeDocRef);
        transaction.update(listingRef, {'likes': currentLikes - 1});
      } else {
        transaction.set(likeDocRef, {
          'userId': userId,
          'listingId': listingId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.update(listingRef, {'likes': currentLikes + 1});
      }
    });
  }

  Stream<bool> watchLikeStatus(String listingId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    return _firestore
        .collection(_likesCollection)
        .doc('${listingId}_$userId')
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<int> watchLikesCount(String listingId) {
    return _firestore
        .collection(_listingsCollection)
        .doc(listingId)
        .snapshots()
        .map((doc) => doc.data()?['likes'] ?? 0);
  }
}
