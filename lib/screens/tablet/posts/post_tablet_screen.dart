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
import 'package:dister/models/categorie_model.dart';
import 'package:dister/models/highlight_model.dart';

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
    final bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.of(context).deleteConfirmation),
            content: Text(S.of(context).deleteListingWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  S.of(context).delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance
            .collection('listings')
            .doc(widget.listing.id)
            .delete();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).listingDeleted)),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorGeneric(e.toString()))),
        );
      }
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

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isPostingComment = true;
    });

    await _commentService.addComment(
      widget.listing.id,
      _commentController.text.trim(),
    );

    setState(() {
      _isPostingComment = false;
      _commentController.clear();
    });
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await _commentService.deleteComment(commentId);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorGeneric(e.toString()))),
        );
      }
    }
  }

  String translateText(String text, String locale) {
    String translatedText = text;

    for (var category in ProductCategories.getCategories()) {
      if (text == category.id ||
          text == category.names["en"] ||
          text == category.names["es"]) {
        translatedText = category.getName(locale);
        break;
      }

      for (var subcat in category.subcategories) {
        if (text == subcat["en"] || text == subcat["es"]) {
          final lang = locale.split('_')[0];
          translatedText = subcat[lang] ?? subcat["en"] ?? text;
          break;
        }
      }
    }

    for (var highlightKey in HighlightOptions.options.keys) {
      if (text == highlightKey ||
          text == HighlightOptions.options[highlightKey]!["en"] ||
          text == HighlightOptions.options[highlightKey]!["es"]) {
        final lang = locale.split('_')[0];
        translatedText = HighlightOptions.options[highlightKey]![lang] ??
            HighlightOptions.options[highlightKey]!["en"] ??
            text;
        break;
      }
    }

    return translatedText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  AppBar(
                    backgroundColor: colorScheme.surface,
                    leading: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: colorScheme.onSurface),
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
                        stream: _likeService.watchLikeStatus(widget.listing.id),
                        builder: (context, snapshot) {
                          final bool isLiked = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: colorScheme.error,
                            ),
                            onPressed: () =>
                                _likeService.toggleLike(widget.listing.id),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      width: double.infinity,
                                    );
                                  },
                                ),
                                if (widget.listing.images.length > 1)
                                  Positioned(
                                    bottom: 16,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SmoothPageIndicator(
                                          controller: _pageController,
                                          count: widget.listing.images.length,
                                          effect: WormEffect(
                                            dotHeight: 16,
                                            dotWidth: 16,
                                            dotColor: Colors.grey,
                                            activeDotColor: colorScheme.primary,
                                          ),
                                        ),
                                      ],
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.listing.title,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (widget.listing.originalPrice >
                                        widget.listing.discountPrice)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          S.of(context).percentOff((((widget
                                                              .listing
                                                              .originalPrice -
                                                          widget.listing
                                                              .discountPrice) /
                                                      widget.listing
                                                          .originalPrice) *
                                                  100)
                                              .round()),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      '${widget.listing.discountPrice.toStringAsFixed(2)}€',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (widget.listing.originalPrice >
                                        widget.listing.discountPrice)
                                      Text(
                                        '${widget.listing.originalPrice.toStringAsFixed(2)}€',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  S.of(context).productDetails,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.listing.desc,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha(128),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  S.of(context).shoppingDetails,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S
                                      .of(context)
                                      .storePrefix(widget.listing.storeName),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha(128),
                                  ),
                                ),
                                if (widget.listing.rating != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    S.of(context).ratingWithStars(widget
                                        .listing.rating!
                                        .toStringAsFixed(1)),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant
                                          .withAlpha(128),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 4),
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
                                const SizedBox(height: 4),
                                Text(
                                  (() {
                                    final timeData =
                                        widget.listing.getTimeData();
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
                                        .postedTimeAgo("$timeValue $timeUnit");
                                  })(),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha(128),
                                  ),
                                ),
                                if (widget.listing.expiresAt != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    S.of(context).expiresOn(
                                        widget.listing.getFormattedExpiry() ??
                                            ''),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant
                                          .withAlpha(128),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    ...ProductCategories.getCategories()
                                        .where((category) =>
                                            category.id ==
                                                widget.listing.categories ||
                                            category.names["en"] ==
                                                widget.listing.categories ||
                                            category.names["es"] ==
                                                widget.listing.categories ||
                                            category.subcategories.any(
                                                (subcat) =>
                                                    subcat["en"] ==
                                                        widget.listing
                                                            .categories ||
                                                    subcat["es"] ==
                                                        widget.listing
                                                            .categories))
                                        .map((category) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme
                                                    .surfaceContainer,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                translateText(
                                                    category.getName(
                                                        Localizations.localeOf(
                                                                context)
                                                            .toString()),
                                                    Localizations.localeOf(
                                                            context)
                                                        .toString()),
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            )),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        translateText(
                                            widget.listing.subcategories,
                                            Localizations.localeOf(context)
                                                .toString()),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    ...(widget.listing.highlights ?? [])
                                        .map((highlight) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme
                                                    .surfaceContainer,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                translateText(
                                                    highlight,
                                                    Localizations.localeOf(
                                                            context)
                                                        .toString()),
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            )),
                                  ],
                                ),
                                const SizedBox(height: 16),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).comments,
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: StreamBuilder<List<Comment>>(
                                        stream:
                                            _commentService.getCommentsStream(
                                                widget.listing.id),
                                        builder: (context, snapshot) {
                                          return Text(
                                            '${snapshot.data?.length ?? 0}',
                                            style: TextStyle(
                                              color: colorScheme.onPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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

                                    if (comments.isEmpty) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              color: colorScheme
                                                  .onSurfaceVariant
                                                  .withAlpha(128),
                                            ),
                                            Text(S.of(context).noComments),
                                          ],
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: comments
                                          .map((comment) => CommentCard(
                                                comment: comment,
                                                commentService: _commentService,
                                                onDeleted: () =>
                                                    _deleteComment(comment.id),
                                              ))
                                          .toList(),
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
                  if (_currentUser != null)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: colorScheme.surface,
                      child: Row(
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(_currentUser.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final photoUrl =
                                  snapshot.data?.get('photo') as String?;
                              return CircleAvatar(
                                backgroundImage: photoUrl != null &&
                                        !photoUrl.startsWith('assets/')
                                    ? NetworkImage(photoUrl)
                                    : const AssetImage(
                                            'assets/images/default.png')
                                        as ImageProvider,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: S.of(context).enterComment,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.send, color: colorScheme.primary),
                            onPressed: _isPostingComment ? null : _addComment,
                          ),
                        ],
                      ),
                    ),
                  if (widget.listing.link.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _launchURL,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          S.of(context).goForDiscount,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onError,
                            fontWeight: FontWeight.bold,
                          ),
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
