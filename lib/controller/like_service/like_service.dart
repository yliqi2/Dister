import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colección para almacenar los likes
  final String _likesCollection = 'likes';
  // Colección de listings
  final String _listingsCollection = 'listings';

  // Comprobar si un usuario ha dado like a un listing
  Future<bool> hasUserLiked(String listingId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final likeDoc = await _firestore
        .collection(_likesCollection)
        .doc('${listingId}_$userId')
        .get();

    return likeDoc.exists;
  }

  // Dar/quitar like a un listing
  Future<void> toggleLike(String listingId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    final likeDocRef =
        _firestore.collection(_likesCollection).doc('${listingId}_$userId');

    final listingRef =
        _firestore.collection(_listingsCollection).doc(listingId);

    // Usar una transacción para asegurar la consistencia de los datos
    await _firestore.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeDocRef);
      final listingDoc = await transaction.get(listingRef);

      if (!listingDoc.exists) {
        throw Exception('Listing no encontrado');
      }

      final currentLikes = listingDoc.data()?['likes'] ?? 0;

      if (likeDoc.exists) {
        // Si ya existe el like, lo quitamos
        transaction.delete(likeDocRef);
        transaction.update(listingRef, {'likes': currentLikes - 1});
      } else {
        // Si no existe el like, lo añadimos
        transaction.set(likeDocRef, {
          'userId': userId,
          'listingId': listingId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.update(listingRef, {'likes': currentLikes + 1});
      }
    });
  }

  // Stream para observar cambios en el estado del like
  Stream<bool> watchLikeStatus(String listingId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    return _firestore
        .collection(_likesCollection)
        .doc('${listingId}_$userId')
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Stream para observar el número de likes
  Stream<int> watchLikesCount(String listingId) {
    return _firestore
        .collection(_listingsCollection)
        .doc(listingId)
        .snapshots()
        .map((doc) => doc.data()?['likes'] ?? 0);
  }
}
