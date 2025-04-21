import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/model/listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/model/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:dister/model/categorie.dart';

class FirebaseServices {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el UID del usuario actual
  String getCurrentUser() {
    User? user = _auth.currentUser;
    return user?.uid ?? 'error';
  }

  // Obtener las credenciales del usuario por su UID
  Future<Users?> getCredentialsUser(String uid) async {
    DocumentSnapshot dn = await _fs.collection('users').doc(uid).get();

    if (dn.exists) {
      return Users.fromMap(dn.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Función para convertir el texto de fecha en DateTime
  DateTime? convertStringToDateTime(String dateStr,
      {String format = "yyyy-mm-dd"}) {
    try {
      final DateFormat formatter =
          DateFormat(format); // Define el formato de fecha
      return formatter.parse(dateStr); // Convierte el texto a DateTime
    } catch (e) {
      return null; // Si hay error en la conversión, retorna null
    }
  }

  // Subir un nuevo Listing a Firestore
  Future<bool> uploadListing({
    required String title,
    required String desc,
    required String expiresAtStr, // Recibimos la fecha como un String
    required String link,
    required double originalPrice,
    required double discountPrice,
    required String storeName,
    required String userId,
    required String
        categories, // Ahora recibe el nombre localizado de la categoría
    required String
        subcategories, // Ahora recibe el nombre localizado de la subcategoría
    required List<String> highlights,
    required List<XFile?> selectedImages, // Cambiado a List<XFile?>
  }) async {
    try {
      // Convertir el texto de la fecha a DateTime
      DateTime? expiresAt = convertStringToDateTime(expiresAtStr);

      // Si la fecha no se pudo convertir, podemos retornar un error
      if (expiresAt == null) {
        return false;
      }

      // Obtener el ID de la categoría a partir del nombre localizado
      final categoryId = _getCategoryIdFromName(categories);

      // Crear el objeto Listing
      Listing listing = Listing(
        title: title,
        desc: desc,
        publishedAt: DateTime.now(),
        expiresAt: expiresAt,
        link: link,
        originalPrice: originalPrice,
        discountPrice: discountPrice,
        storeName: storeName,
        categories: categoryId, // Guardar el ID de la categoría
        subcategories:
            subcategories, // Seguimos guardando el nombre de la subcategoría
        likes: 0,
        images: [], // Inicialmente vacío
        highlights: highlights.isNotEmpty ? highlights : [],
        owner: userId,
      );

      // Subir las imágenes a Firebase Storage
      List<String> imageUrls = [];
      if (selectedImages.isNotEmpty) {
        imageUrls = await uploadImages(selectedImages);
        listing.images = imageUrls;
      }

      // Guardar el Listing en Firestore
      await _fs.collection('listings').add(listing.toMap());

      return true; // Retornamos true si todo fue exitoso
    } catch (e) {
      return false; // Retornamos false si ocurrió un error
    }
  }

  // Método para obtener el ID de la categoría a partir del nombre localizado
  String _getCategoryIdFromName(String categoryName) {
    final categories = ProductCategories.getCategories();
    for (var category in categories) {
      if (category.names.values.any((name) => name == categoryName)) {
        return category.id;
      }
    }
    return ""; // Si no encuentra la categoría, retorna un string vacío
  }

  // Subir imágenes a Firebase Storage y obtener las URLs
  Future<List<String>> uploadImages(List<XFile?> images) async {
    List<String> imageUrls = [];
    try {
      for (var image in images) {
        if (image != null) {
          // Comprobar si la imagen no es null
          String fileName = image.name;
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('listings/images/$fileName');
          firebase_storage.UploadTask uploadTask =
              ref.putFile(File(image.path));

          // Esperar a que se complete la carga
          await uploadTask.whenComplete(() async {
            // Obtener la URL de la imagen cargada
            String imageUrl = await ref.getDownloadURL();
            imageUrls.add(imageUrl);
          });
        }
      }
    } catch (e) {
      debugPrint("Error uploading images: $e");
    }
    return imageUrls;
  }

  Future<void> incrementUserListings(String userId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.update({
      'listings': FieldValue.increment(1),
    });
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Cierra la sesión del usuario actual
    } catch (e) {
      debugPrint("Error during sign out: $e"); // Manejo de errores
    }
  }

  // Seguir a un usuario
  Future<void> followUser(String currentUserId, String targetUserId) async {
    final currentUserDoc = _fs.collection('users').doc(currentUserId);
    final targetUserDoc = _fs.collection('users').doc(targetUserId);

    await _fs.runTransaction((transaction) async {
      final currentUserSnapshot = await transaction.get(currentUserDoc);
      final targetUserSnapshot = await transaction.get(targetUserDoc);

      if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
        throw Exception('Uno de los usuarios no existe.');
      }

      // Agregar el targetUserId a la lista de seguidos del usuario actual
      transaction.update(currentUserDoc, {
        'following': FieldValue.arrayUnion([targetUserId]),
      });

      // Agregar el currentUserId a la lista de seguidores del usuario objetivo
      transaction.update(targetUserDoc, {
        'followers': FieldValue.arrayUnion([currentUserId]),
      });
    });
  }

  // Dejar de seguir a un usuario
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserDoc = _fs.collection('users').doc(currentUserId);
    final targetUserDoc = _fs.collection('users').doc(targetUserId);

    await _fs.runTransaction((transaction) async {
      final currentUserSnapshot = await transaction.get(currentUserDoc);
      final targetUserSnapshot = await transaction.get(targetUserDoc);

      if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
        throw Exception('Uno de los usuarios no existe.');
      }

      // Remover el targetUserId de la lista de seguidos del usuario actual
      transaction.update(currentUserDoc, {
        'following': FieldValue.arrayRemove([targetUserId]),
      });

      // Remover el currentUserId de la lista de seguidores del usuario objetivo
      transaction.update(targetUserDoc, {
        'followers': FieldValue.arrayRemove([currentUserId]),
      });
    });
  }

  // Verificar si un usuario ya dejó de seguir a otro
  Future<bool> hasUnfollowed(String currentUserId, String targetUserId) async {
    final currentUserDoc =
        await _fs.collection('users').doc(currentUserId).get();

    if (!currentUserDoc.exists) {
      throw Exception('El usuario actual no existe.');
    }

    final unfollowedList =
        currentUserDoc.data()?['unfollowed'] as List<dynamic>?;
    return unfollowedList != null && unfollowedList.contains(targetUserId);
  }

  // Verificar si un usuario está siguiendo a otro
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final currentUserDoc =
        await _fs.collection('users').doc(currentUserId).get();

    if (!currentUserDoc.exists) {
      throw Exception('El usuario actual no existe.');
    }

    final followingList = currentUserDoc.data()?['following'] as List<dynamic>?;
    return followingList != null && followingList.contains(targetUserId);
  }

  Future<List<Map<String, dynamic>>> getFollowingUsers() async {
    final currentUser = getCurrentUser();
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();

    final followingIds = List<String>.from(userDoc['following'] ?? []);
    final users = await Future.wait(followingIds.map((id) async {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      return {
        'username': userSnapshot['username'],
        'photo': userSnapshot['photo'] ?? 'assets/images/default.png',
        'uid': userSnapshot['uid'],
      };
    }));

    return users;
  }

  // Subir una foto de perfil a Firebase Storage y obtener la URL
  Future<String> uploadProfilePicture(String userId, File image) async {
    try {
      String fileName =
          'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      firebase_storage.UploadTask uploadTask = ref.putFile(image);

      // Esperar a que se complete la carga
      await uploadTask.whenComplete(() {});

      // Obtener la URL de descarga
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading profile picture: $e");
      throw Exception("Error uploading profile picture");
    }
  }

  // Actualizar la foto de perfil del usuario en Firestore
  Future<void> updateUserPhoto(String userId, String photoUrl) async {
    try {
      await _fs.collection('users').doc(userId).update({'photo': photoUrl});
    } catch (e) {
      debugPrint("Error updating user photo: $e");
      throw Exception("Error updating user photo");
    }
  }

  Future<void> deleteAccount() async {
    try {
      String userId = getCurrentUser();

      // Delete user data from Firestore
      await _fs.collection('users').doc(userId).delete();

      // Delete user authentication account
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      debugPrint("Error deleting account: $e");
      throw Exception("Error deleting account");
    }
  }
}
