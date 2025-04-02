import 'package:dister/model/listing.dart';
import 'package:dister/services/like_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Listingtile extends StatefulWidget {
  final Listing listing;

  const Listingtile({super.key, required this.listing});

  @override
  State<Listingtile> createState() => _ListingtileState();
}

class _ListingtileState extends State<Listingtile> {
  String? ownerPhoto;
  String? ownerName;
  final LikeService _likeService = LikeService();

  @override
  void initState() {
    super.initState();
    _fetchOwnerDetails();
  }

  Future<void> _fetchOwnerDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.listing.owner)
          .get();
      if (doc.exists) {
        setState(() {
          ownerPhoto = doc['photo'];
          ownerName = doc['username'];
        });
      }
    } catch (e) {
      // Handle errors if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.45,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar, username, likes, and time ago
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        ownerPhoto != null && ownerPhoto!.startsWith('http')
                            ? NetworkImage(ownerPhoto!)
                            : const AssetImage('assets/images/default.png')
                                as ImageProvider,
                    radius: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    ownerName != null ? '@$ownerName' : '@Unknown',
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 12, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StreamBuilder<int>(
                    stream: _likeService.watchLikesCount(widget.listing.id),
                    builder: (context, snapshot) {
                      final likes = snapshot.data ?? widget.listing.likes;
                      return Text(
                        "$likes Likes",
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                  Text(
                    "${widget.listing.getTimeAgo()} ago",
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Main image
          if (widget.listing.images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 1.25, // Adjusted aspect ratio for smaller image
                child: Image.network(
                  widget.listing.images.first,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 10),

          // Title
          Text(
            widget.listing.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Prices and Favorite button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${widget.listing.discountPrice.toStringAsFixed(0)}€",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${widget.listing.originalPrice.toStringAsFixed(0)}€",
                    style: const TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              // Favorite button with border
              StreamBuilder<bool>(
                stream: _likeService.watchLikeStatus(widget.listing.id),
                builder: (context, snapshot) {
                  final bool isLiked = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: () => _likeService.toggleLike(widget.listing.id),
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
