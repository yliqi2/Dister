import 'package:dister/models/post_model.dart';
import 'package:dister/screens/mobile/profile/profile_screen.dart';
import 'package:dister/controllers/favorite_service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/generated/l10n.dart';

class ProfileListingTile extends StatefulWidget {
  final Post listing;
  final VoidCallback? onTap;

  const ProfileListingTile({
    super.key,
    required this.listing,
    this.onTap,
  });

  @override
  State<ProfileListingTile> createState() => _ProfileListingTileState();
}

class _ProfileListingTileState extends State<ProfileListingTile> {
  String? ownerPhoto;
  String? ownerName;
  final FavoriteService _favoriteService = FavoriteService();

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
      if (doc.exists && mounted) {
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.50,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? colorScheme.surface
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userId: widget.listing.owner),
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
                          radius: 10,
                          child: ownerPhoto == null ||
                                  !ownerPhoto!.startsWith('http')
                              ? Image.asset(
                                  'assets/images/default.png',
                                  color: Colors.white,
                                  width: 14,
                                  height: 14,
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
                fontSize: 14,
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
                        fontSize: 16,
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
                StreamBuilder<bool>(
                  stream: _favoriteService.watchLikeStatus(widget.listing.id),
                  builder: (context, snapshot) {
                    final bool isLiked = snapshot.data ?? false;
                    return GestureDetector(
                      onTap: () =>
                          _favoriteService.toggleLike(widget.listing.id),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color:
                            isLiked ? colorScheme.error : colorScheme.outline,
                        size: 22,
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
