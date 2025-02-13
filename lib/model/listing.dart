import 'package:flutter/material.dart';

class Listing {
  String title;
  String desc;
  DateTime publishedAt;
  DateTime? expiresAt;
  String link;
  double originalPrice;
  double discountPrice;
  String storeName;
  List<String> categories;
  double likes;
  double? rating;
  List<String> images;
  List<String> highlights;
  String owner; //UID de firebase_auth

  Listing(
      {required this.title,
      required this.desc,
      required this.publishedAt,
      this.expiresAt,
      required this.link,
      required this.originalPrice,
      required this.discountPrice,
      required this.storeName,
      required this.categories,
      required this.likes,
      this.rating,
      required this.images,
      required this.highlights,
      required this.owner});

  String getTimeAgo() {
    Duration difference = DateTime.now().difference(publishedAt);
    if (difference.inDays > 0) return "${difference.inDays} D";
    if (difference.inHours > 0) return "${difference.inHours} H";
    return "${difference.inMinutes} min.";
  }

  String? getFormattedExpiry() {
    if (expiresAt == null) return null;
    return "${expiresAt!.day}/${expiresAt!.month}/${expiresAt!.year}";
  }

  String getFormattedLikes() {
    if (likes >= 1000000) {
      double m = likes / 1000000;
      return m >= 10
          ? "${m.toStringAsFixed(0)}M"
          : "${m.toStringAsFixed(1)}M"; // Redondea a 1 decimales solo si es menos que 10M
    } else if (likes >= 1000) {
      double k = likes / 1000;
      return k >= 10
          ? "${k.toStringAsFixed(0)}k"
          : "${k.toStringAsFixed(1)}k"; // Redondea a 1 decimales solo si es menos que 10k
    } else {
      return likes
          .toStringAsFixed(0); // Muestra el número tal cual si es menor a 1000
    }
  }
}
