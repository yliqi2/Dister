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

  String getCurrentUser() {
    User? user = _auth.currentUser;
    return user?.uid ?? 'error';
  }

  Future<Users?> getCredentialsUser(String uid) async {
    DocumentSnapshot dn = await _fs.collection('users').doc(uid).get();

    if (dn.exists) {
      return Users.fromMap(dn.data() as Map<String, dynamic>);
    }
    return null;
  }

  DateTime? convertStringToDateTime(String dateStr,
      {String format = "yyyy-mm-dd"}) {
    try {
      final DateFormat formatter = DateFormat(format);
      return formatter.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  Future<bool> uploadListing({
    required String title,
    required String desc,
    required String expiresAtStr,
    required String link,
    required double originalPrice,
    required double discountPrice,
    required String storeName,
    required String userId,
    required String categories,
    required String subcategories,
    required List<String> highlights,
    required List<XFile?> selectedImages,
  }) async {
    try {
      DateTime? expiresAt = convertStringToDateTime(expiresAtStr);

      if (expiresAt == null) {
        return false;
      }

      final categoryId = _getCategoryIdFromName(categories);

      Listing listing = Listing(
        title: title,
        desc: desc,
        publishedAt: DateTime.now(),
        expiresAt: expiresAt,
        link: link,
        originalPrice: originalPrice,
        discountPrice: discountPrice,
        storeName: storeName,
        categories: categoryId,
        subcategories: subcategories,
        likes: 0,
        images: [],
        highlights: highlights.isNotEmpty ? highlights : [],
        owner: userId,
      );

      List<String> imageUrls = [];
      if (selectedImages.isNotEmpty) {
        imageUrls = await uploadImages(selectedImages);
        listing.images = imageUrls;
      }

      await _fs.collection('listings').add(listing.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  String _getCategoryIdFromName(String categoryName) {
    final categories = ProductCategories.getCategories();
    for (var category in categories) {
      if (category.names.values.any((name) => name == categoryName)) {
        return category.id;
      }
    }
    return "";
  }

  Future<List<String>> uploadImages(List<XFile?> images) async {
    List<String> imageUrls = [];
    try {
      for (var image in images) {
        if (image != null) {
          String fileName = image.name;
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('listings/images/$fileName');
          firebase_storage.UploadTask uploadTask =
              ref.putFile(File(image.path));

          await uploadTask.whenComplete(() async {
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
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error during sign out: $e");
    }
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    final currentUserDoc = _fs.collection('users').doc(currentUserId);
    final targetUserDoc = _fs.collection('users').doc(targetUserId);

    await _fs.runTransaction((transaction) async {
      final currentUserSnapshot = await transaction.get(currentUserDoc);
      final targetUserSnapshot = await transaction.get(targetUserDoc);

      if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
        throw Exception('Uno de los usuarios no existe.');
      }

      transaction.update(currentUserDoc, {
        'following': FieldValue.arrayUnion([targetUserId]),
      });

      transaction.update(targetUserDoc, {
        'followers': FieldValue.arrayUnion([currentUserId]),
      });
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserDoc = _fs.collection('users').doc(currentUserId);
    final targetUserDoc = _fs.collection('users').doc(targetUserId);

    await _fs.runTransaction((transaction) async {
      final currentUserSnapshot = await transaction.get(currentUserDoc);
      final targetUserSnapshot = await transaction.get(targetUserDoc);

      if (!currentUserSnapshot.exists || !targetUserSnapshot.exists) {
        throw Exception('Uno de los usuarios no existe.');
      }

      transaction.update(currentUserDoc, {
        'following': FieldValue.arrayRemove([targetUserId]),
      });

      transaction.update(targetUserDoc, {
        'followers': FieldValue.arrayRemove([currentUserId]),
      });
    });
  }

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

  Future<String> uploadProfilePicture(String userId, File image) async {
    try {
      String fileName =
          'profile_pictures/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      firebase_storage.UploadTask uploadTask = ref.putFile(image);

      await uploadTask.whenComplete(() {});

      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading profile picture: $e");
      throw Exception("Error uploading profile picture");
    }
  }

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

      await _fs.collection('users').doc(userId).delete();

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
