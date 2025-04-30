import 'package:dister/models/post_model.dart';
import 'package:dister/screens/mobile/profile/profile_screen.dart';
import 'package:dister/controllers/favorite_service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabletPostContainer extends StatefulWidget {
  final Post listing;
  final VoidCallback? onTap;
  final bool colorChange;

  const TabletPostContainer(
      {super.key, required this.listing, this.onTap, this.colorChange = false});

  @override
  State<TabletPostContainer> createState() => _TabletPostContainerState();
}

class _TabletPostContainerState extends State<TabletPostContainer> {
  String? ownerPhoto;
  String? ownerName;
  final FavoriteService _likeService = FavoriteService();

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isApi = widget.listing.owner == 'api';
    final sellerName = widget.listing.storeName.isNotEmpty
        ? widget.listing.storeName
        : 'Tienda';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? widget.colorChange
                  ? colorScheme.surface
                  : colorScheme.surfaceContainer
              : colorScheme.surfaceContainer.withAlpha(242),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? colorScheme.outline.withAlpha(50)
                : colorScheme.outline.withAlpha(77),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (!isApi) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              userId: widget.listing.owner,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: ownerPhoto != null
                            ? (ownerPhoto!.startsWith('http')
                                ? NetworkImage(ownerPhoto!)
                                : AssetImage(ownerPhoto!) as ImageProvider)
                            : const AssetImage('assets/images/default.png'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ownerName ?? '',
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@$sellerName',
                            maxLines: 1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        sellerName[0].toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sellerName,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '@$sellerName',
                            maxLines: 1,
                            style: theme.textTheme.bodySmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  StreamBuilder<bool>(
                    stream: _likeService.watchLikeStatus(widget.listing.id),
                    builder: (context, snapshot) {
                      final isLiked = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          _likeService.toggleLike(widget.listing.id);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            if (widget.listing.images.isNotEmpty)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.listing.images.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
