import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String title;
  String desc;
  DateTime publishedAt;
  DateTime? expiresAt;
  String link;
  double originalPrice;
  double discountPrice;
  String storeName;
  String categories; // Category as a string (ID of the category)
  String subcategories; // Subcategory as a string (name of the subcategory)
  int likes;
  double? rating;
  List<String> images;
  List<String>? highlights;
  String owner;

  Post({
    this.id = '',
    required this.title,
    required this.desc,
    required this.publishedAt,
    this.expiresAt,
    required this.link,
    required this.originalPrice,
    required this.discountPrice,
    required this.storeName,
    required this.categories,
    required this.subcategories,
    required this.likes,
    this.rating,
    required this.images,
    required this.highlights,
    required this.owner,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'link': link,
      'originalPrice': originalPrice,
      'discountPrice': discountPrice,
      'storeName': storeName,
      'categories': categories,
      'subcategories': subcategories,
      'likes': likes,
      'rating': rating,
      'images': images,
      'highlights': highlights,
      'owner': owner,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map, String documentId) {
    return Post(
      id: documentId,
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      publishedAt: (map['publishedAt'] as Timestamp).toDate(),
      expiresAt: map['expiresAt'] != null
          ? (map['expiresAt'] as Timestamp).toDate()
          : null,
      link: map['link'] ?? '',
      originalPrice: (map['originalPrice'] as num).toDouble(),
      discountPrice: (map['discountPrice'] as num).toDouble(),
      storeName: map['storeName'] ?? '',
      categories: map['categories'] ?? '',
      subcategories: map['subcategories'] ?? '',
      likes: (map['likes'] as num).toInt(),
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      images: List<String>.from(map['images'] ?? []),
      highlights:
          map['highlights'] != null ? List<String>.from(map['highlights']) : [],
      owner: map['owner'] ?? '',
    );
  }

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Post.fromMap(map, doc.id);
  }

  static Future<List<Post>> getListings() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('listings').get();
    return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  Map<String, dynamic> getTimeData() {
    Duration difference = DateTime.now().difference(publishedAt);
    if (difference.inMinutes == 0) {
      return {"value": "1", "unit": "timeMinute"};
    }
    if (difference.inDays > 0) {
      return {"value": difference.inDays.toString(), "unit": "timeDay"};
    }
    if (difference.inHours > 0) {
      return {"value": difference.inHours.toString(), "unit": "timeHour"};
    }
    return {"value": difference.inMinutes.toString(), "unit": "timeMinute"};
  }

  String getTimeAgo() {
    final timeData = getTimeData();
    return "${timeData["value"]} ${timeData["unit"]}";
  }

  String? getFormattedExpiry() {
    if (expiresAt == null) return null;
    return "${expiresAt!.day}/${expiresAt!.month}/${expiresAt!.year}";
  }

  String getFormattedLikes() {
    if (likes >= 1000000) {
      double m = likes / 1000000;
      return m >= 10 ? "${m.toStringAsFixed(0)}M" : "${m.toStringAsFixed(1)}M";
    } else if (likes >= 1000) {
      double k = likes / 1000;
      return k >= 10 ? "${k.toStringAsFixed(0)}K" : "${k.toStringAsFixed(1)}K";
    } else {
      return likes.toString();
    }
  }
}
