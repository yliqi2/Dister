import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/model/post.dart';

class ApiFavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _apiFavoritesCollection = 'api_favorites';

  // Comprobar si un post de la API está en favoritos
  Future<bool> isPostFavorite(String postId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection(_apiFavoritesCollection)
        .doc(postId);

    final doc = await docRef.get();
    return doc.exists;
  }

  // Añadir/quitar de favoritos un post de la API
  Future<void> toggleFavorite(Post post) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection(_apiFavoritesCollection)
        .doc(post.id);

    final doc = await docRef.get();

    if (doc.exists) {
      // Si ya existe en favoritos, lo quitamos
      await docRef.delete();
    } else {
      // Si no existe en favoritos, lo añadimos
      await docRef.set({
        'title': post.title,
        'desc': post.desc,
        'link': post.link,
        'originalPrice': post.originalPrice,
        'discountPrice': post.discountPrice,
        'storeName': post.storeName,
        'images': post.images,
        'rating': post.rating,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Stream para observar cambios en el estado de favorito
  Stream<bool> watchFavoriteStatus(String postId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection(_apiFavoritesCollection)
        .doc(postId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Obtener todos los posts favoritos de la API
  Future<List<Post>> getFavoritePosts() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection(_apiFavoritesCollection)
        .orderBy('savedAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Post(
        id: doc.id,
        title: data['title'] ?? '',
        desc: data['desc'] ?? '',
        link: data['link'] ?? '',
        originalPrice: (data['originalPrice'] ?? 0.0).toDouble(),
        discountPrice: (data['discountPrice'] ?? 0.0).toDouble(),
        storeName: data['storeName'] ?? '',
        images: List<String>.from(data['images'] ?? []),
        rating: data['rating']?.toDouble(),
        categories: '', // Valor por defecto para posts de API
        subcategories: '', // Valor por defecto para posts de API
        likes: 0, // Valor por defecto para posts de API
        highlights: [], // Valor por defecto para posts de API
        owner: 'api', // Identificador especial para posts de API
        publishedAt:
            (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }
}
