import 'package:dister/model/listing.dart';
import 'package:dister/pages/mobile/profile/profile.dart';
import 'package:dister/controller/like_service/like_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/generated/l10n.dart';

class Listingtile extends StatefulWidget {
  final Listing listing;
  final VoidCallback? onTap;

  const Listingtile({super.key, required this.listing, this.onTap});

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: size.width * 0.45,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? colorScheme.surface
              : colorScheme.surface.withAlpha(242),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.outline
                : colorScheme.outline.withAlpha(77),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar, username, likes, and time ago
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Profile(userId: widget.listing.owner),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: ownerPhoto != null &&
                                  ownerPhoto!.startsWith('http')
                              ? NetworkImage(ownerPhoto!)
                              : null,
                          radius: 15,
                          child: ownerPhoto == null ||
                                  !ownerPhoto!.startsWith('http')
                              ? Image.asset(
                                  'assets/images/default.png',
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            ownerName != null ? '@$ownerName' : '@Unknown',
                            maxLines: 1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      S
                          .of(context)
                          .likesText(widget.listing.getFormattedLikes()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    Text(
                      (() {
                        final timeData = widget.listing.getTimeData();
                        final String unitKey = timeData["unit"];
                        final String timeValue = timeData["value"];
                        String timeUnit;

                        if (unitKey == "timeDay") {
                          timeUnit = S.of(context).timeDay;
                        } else if (unitKey == "timeHour") {
                          timeUnit = S.of(context).timeHour;
                        } else {
                          timeUnit = S.of(context).timeMinute;
                        }

                        return S.of(context).timeAgo("$timeValue $timeUnit");
                      })(),
                      style: theme.textTheme.bodySmall,
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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${widget.listing.originalPrice.toStringAsFixed(0)}€",
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.outline,
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
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: colorScheme.onError,
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
      ),
    );
  }
}
