import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/sidebar_tablet.dart';
import 'package:dister/controllers/favorite_service/favorite_service.dart';
import 'package:dister/controllers/comment_service/comment_service.dart';
import 'package:dister/widgets/comment_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';

class PostTabletScreen extends StatefulWidget {
  final Post listing;
  const PostTabletScreen({super.key, required this.listing});

  @override
  State<PostTabletScreen> createState() => _PostTabletScreenState();
}

class _PostTabletScreenState extends State<PostTabletScreen> {
  String? ownerPhoto;
  String? ownerName;
  final PageController _pageController = PageController();
  final TextEditingController _commentController = TextEditingController();
  final FavoriteService _likeService = FavoriteService();
  final CommentService _commentService = CommentService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isPostingComment = false;

  @override
  void initState() {
    super.initState();
    _fetchOwnerDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentController.dispose();
    super.dispose();
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
      debugPrint(e.toString());
    }
  }

  bool _isOwner() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == widget.listing.owner;
  }

  Future<void> _deleteListing() async {
    try {
      await FirebaseFirestore.instance
          .collection('listings')
          .doc(widget.listing.id)
          .delete();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error deleting listing: $e');
    }
  }

  Future<void> _launchURL() async {
    final url = widget.listing.link;
    if (url.isNotEmpty) {
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }
      final uri = Uri.parse(formattedUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).cannotOpenLink,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarTablet(
              selectedIndex: 0,
              onTap: (index) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomeTabletScreen(initialIndex: index),
                  ),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
                            backgroundColor: colorScheme.surface,
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: colorScheme.onSurface),
                              onPressed: () => Navigator.pop(context),
                            ),
                            title: Text(
                              ownerName != null ? '@$ownerName' : '@Unknown',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            centerTitle: true,
                            actions: [
                              if (_isOwner())
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: colorScheme.error,
                                  ),
                                  onPressed: _deleteListing,
                                  tooltip: S.of(context).delete,
                                ),
                              StreamBuilder<bool>(
                                stream: _likeService
                                    .watchLikeStatus(widget.listing.id),
                                builder: (context, snapshot) {
                                  final bool isLiked = snapshot.data ?? false;
                                  return IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: colorScheme.error,
                                    ),
                                    onPressed: () => _likeService
                                        .toggleLike(widget.listing.id),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: widget.listing.images.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      widget.listing.images[index],
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                if (widget.listing.images.length > 1)
                                  Positioned(
                                    bottom: 16,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: SmoothPageIndicator(
                                        controller: _pageController,
                                        count: widget.listing.images.length,
                                        effect: WormEffect(
                                          dotHeight: 16,
                                          dotWidth: 16,
                                          dotColor: Colors.grey,
                                          activeDotColor: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.listing.title,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.listing.desc,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).originalprice,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          '${widget.listing.originalPrice}€',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          S.of(context).finalpricelabel,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          '${widget.listing.discountPrice}€',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).categorylabel,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.listing.categories,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (widget.listing.link.isNotEmpty)
                                  GestureDetector(
                                    onTap: _launchURL,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.link,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              widget.listing.link,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: colorScheme.primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                StreamBuilder<int>(
                                  stream: _likeService
                                      .watchLikesCount(widget.listing.id),
                                  builder: (context, snapshot) {
                                    final likes =
                                        snapshot.data ?? widget.listing.likes;
                                    return Text(
                                      S.of(context).likesCount(likes),
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onSurfaceVariant
                                            .withAlpha(128),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.primary.withAlpha(26),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                StreamBuilder<List<Comment>>(
                                  stream: _commentService
                                      .getCommentsStream(widget.listing.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: colorScheme.primary,
                                        ),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Icon(Icons.error_outline,
                                                color: colorScheme.error),
                                            Text(snapshot.error.toString()),
                                          ],
                                        ),
                                      );
                                    }

                                    final comments = snapshot.data ?? [];
                                    return Column(
                                      children: [
                                        ...comments
                                            .map((comment) => CommentCard(
                                                  comment: comment,
                                                  commentService:
                                                      _commentService,
                                                  onDeleted: () {
                                                    setState(() {});
                                                  },
                                                )),
                                        if (_currentUser != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Row(
                                              children: [
                                                StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(_currentUser.uid)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    final photoUrl = snapshot
                                                            .data
                                                            ?.get('photo')
                                                        as String?;
                                                    return CircleAvatar(
                                                      backgroundImage: photoUrl !=
                                                                  null &&
                                                              !photoUrl
                                                                  .startsWith(
                                                                      'assets/')
                                                          ? NetworkImage(
                                                              photoUrl)
                                                          : const AssetImage(
                                                                  'assets/images/default.png')
                                                              as ImageProvider,
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        _commentController,
                                                    decoration: InputDecoration(
                                                      hintText: S
                                                          .of(context)
                                                          .enterComment,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor: colorScheme
                                                          .surfaceContainer,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: colorScheme.primary,
                                                  ),
                                                  onPressed: _isPostingComment
                                                      ? null
                                                      : () async {
                                                          if (_commentController
                                                              .text
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              _isPostingComment =
                                                                  true;
                                                            });
                                                            try {
                                                              await _commentService
                                                                  .addComment(
                                                                widget
                                                                    .listing.id,
                                                                _commentController
                                                                    .text,
                                                              );
                                                              _commentController
                                                                  .clear();
                                                            } catch (e) {
                                                              debugPrint(
                                                                  'Error posting comment: $e');
                                                            } finally {
                                                              setState(() {
                                                                _isPostingComment =
                                                                    false;
                                                              });
                                                            }
                                                          }
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
