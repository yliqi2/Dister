import 'package:dister/model/post.dart';
import 'package:dister/pages/mobile/screens/profile_screen.dart';
import 'package:dister/controller/like_service/like_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/generated/l10n.dart';

class PostContainer extends StatefulWidget {
  final Post listing;
  final VoidCallback? onTap;
  final bool colorChange;

  const PostContainer(
      {super.key, required this.listing, this.onTap, this.colorChange = false});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
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
      debugPrint('Error fetching owner details: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isApi = widget.listing.owner == 'api';
    final sellerName = widget.listing.storeName.isNotEmpty
        ? widget.listing.storeName
        : 'Tienda';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: size.width * 0.45,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? widget.colorChange
                  ? colorScheme.surface
                  : colorScheme.surfaceContainer
              : colorScheme.surfaceContainer.withAlpha(242),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.outline.withAlpha(50)
                : colorScheme.outline.withAlpha(77),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: isApi
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: colorScheme.primary,
                              child: const Icon(Icons.store,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '@$sellerName',
                                maxLines: 1,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
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
                                  ownerName != null
                                      ? '@$ownerName'
                                      : '@Unknown',
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
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          S
                              .of(context)
                              .likesText(widget.listing.getFormattedLikes()),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.secondary,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isApi
                              ? 'hace 1 min.'
                              : (() {
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

                                  return S
                                      .of(context)
                                      .timeAgo("$timeValue $timeUnit");
                                })(),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.listing.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Image.network(
                    widget.listing.images.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              widget.listing.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
                isApi
                    ? Icon(Icons.favorite_border,
                        color: colorScheme.outline, size: 25)
                    : StreamBuilder<bool>(
                        stream: _likeService.watchLikeStatus(widget.listing.id),
                        builder: (context, snapshot) {
                          final bool isLiked = snapshot.data ?? false;
                          return GestureDetector(
                            onTap: () =>
                                _likeService.toggleLike(widget.listing.id),
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : colorScheme.outline,
                              size: 25,
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
