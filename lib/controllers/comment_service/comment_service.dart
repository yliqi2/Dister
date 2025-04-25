import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Comment?> addComment(String listingId, String text) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) return null;

      final commentData = {
        'listingId': listingId,
        'userId': currentUser.uid,
        'text': text,
        'createdAt': Timestamp.now(),
        'userPhoto': userDoc['photo'],
        'username': userDoc['username'],
      };

      final docRef = await _firestore.collection('comments').add(commentData);
      final commentDoc = await docRef.get();

      return Comment.fromFirestore(commentDoc);
    } catch (e) {
      debugPrint('Error adding comment: $e');
      return null;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final commentDoc =
          await _firestore.collection('comments').doc(commentId).get();

      if (!commentDoc.exists) return false;

      final data = commentDoc.data() as Map<String, dynamic>;
      if (data['userId'] != currentUser.uid) return false;

      await _firestore.collection('comments').doc(commentId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      return false;
    }
  }

  Future<List<Comment>> getCommentsForListing(String listingId) async {
    try {
      final querySnapshot = await _firestore
          .collection('comments')
          .where('listingId', isEqualTo: listingId)
          .get();

      final comments =
          querySnapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();

      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return comments;
    } catch (e) {
      debugPrint('Error getting comments: $e');
      return [];
    }
  }

  Stream<List<Comment>> getCommentsStream(String listingId) {
    try {
      return _firestore
          .collection('comments')
          .where('listingId', isEqualTo: listingId)
          .snapshots()
          .map((snapshot) {
        final comments =
            snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();

        comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return comments;
      });
    } catch (e) {
      debugPrint('Error getting comments stream: $e');
      return Stream.value([]);
    }
  }

  bool canDeleteComment(Comment comment) {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    return comment.userId == currentUser.uid;
  }
}
