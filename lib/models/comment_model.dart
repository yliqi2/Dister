import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String listingId;
  final String userId;
  final String text;
  final DateTime createdAt;
  String? userPhoto;
  String? username;

  Comment({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.userPhoto,
    this.username,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      listingId: data['listingId'] ?? '',
      userId: data['userId'] ?? '',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userPhoto: data['userPhoto'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listingId': listingId,
      'userId': userId,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'userPhoto': userPhoto,
      'username': username,
    };
  }
}
