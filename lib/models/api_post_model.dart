class ApiPost {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double? rating;
  final String? seller;

  ApiPost({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.rating,
    this.seller,
  });

  factory ApiPost.fromJson(Map<String, dynamic> json) {
    return ApiPost(
      id: json['product_id']?.toString() ?? '',
      title: json['product_title'] ?? '',
      imageUrl: (json['product_photos'] != null &&
              json['product_photos'] is List &&
              json['product_photos'].isNotEmpty)
          ? json['product_photos'][0]
          : '',
      price: (json['product_min_price'] is num)
          ? (json['product_min_price'] as num).toDouble()
          : 0.0,
      originalPrice: (json['product_max_price'] is num)
          ? (json['product_max_price'] as num).toDouble()
          : null,
      rating: (json['product_rating'] is num)
          ? (json['product_rating'] as num).toDouble()
          : null,
      seller: json['product_seller'],
    );
  }
}
