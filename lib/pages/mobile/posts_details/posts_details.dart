import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/model/post.dart';
import 'package:dister/controller/like_service/like_service.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/model/categorie.dart';
import 'package:dister/model/highlight.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dister/model/comment.dart';
import 'package:dister/controller/comment_service/comment_service.dart';
import 'package:dister/widgets/comment_card.dart';

class PostsDetails extends StatefulWidget {
  final Post listing;
  const PostsDetails({super.key, required this.listing});

  @override
  State<PostsDetails> createState() => _PostsDetailsState();
}

class _PostsDetailsState extends State<PostsDetails> {
  String? ownerPhoto;
  String? ownerName;
  final PageController _pageController = PageController();
  final LikeService _likeService = LikeService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();
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

  bool _isOwner() {
    return _currentUser?.uid == widget.listing.owner;
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

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.listing.images;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
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
                onPressed: () => _likeService.toggleLike(widget.listing.id),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: (index) {},
                          itemBuilder: (context, index) {
                            return Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmoothPageIndicator(
                                  controller: _pageController,
                                  count: images.length,
                                  effect: WormEffect(
                                    dotHeight: 16,
                                    dotWidth: 16,
                                    dotColor: Colors.grey,
                                    activeDotColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.listing.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? colorScheme.surfaceContainerHighest
                                    : colorScheme.primary.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                S.of(context).percentOff((((widget
                                                    .listing.originalPrice -
                                                widget.listing.discountPrice) /
                                            widget.listing.originalPrice) *
                                        100)
                                    .round()),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${widget.listing.discountPrice.toStringAsFixed(0)}€',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.error,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.listing.originalPrice.toStringAsFixed(0)}€',
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          S.of(context).productDetails,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.listing.desc,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant.withAlpha(128),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          S.of(context).shoppingDetails,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).storePrefix(widget.listing.storeName),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant.withAlpha(128),
                          ),
                        ),
                        if (widget.listing.rating != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            S.of(context).ratingWithStars(
                                widget.listing.rating!.toStringAsFixed(1)),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant.withAlpha(128),
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        StreamBuilder<int>(
                          stream:
                              _likeService.watchLikesCount(widget.listing.id),
                          builder: (context, snapshot) {
                            final likes = snapshot.data ?? widget.listing.likes;
                            return Text(
                              S.of(context).likesCount(likes),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color:
                                    colorScheme.onSurfaceVariant.withAlpha(128),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
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

                            return S
                                .of(context)
                                .postedTimeAgo("$timeValue $timeUnit");
                          })(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant.withAlpha(128),
                          ),
                        ),
                        if (widget.listing.expiresAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            S.of(context).expiresOn(
                                widget.listing.getFormattedExpiry() ?? ''),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant.withAlpha(128),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            _categoryTag(widget.listing.categories),
                            _categoryTag(widget.listing.storeName),
                            if (widget.listing.highlights != null)
                              ...widget.listing.highlights!
                                  .map((highlight) => _categoryTag(highlight)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sección de comentarios
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).comments,
                              style: theme.textTheme.titleLarge?.copyWith(
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
                                stream: _commentService
                                    .getCommentsStream(widget.listing.id),
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

                            if (comments.isEmpty) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: colorScheme.onSurfaceVariant
                                          .withAlpha(128),
                                    ),
                                    Text(S.of(context).noComments),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: CommentCard(
                                    comment: comments[index],
                                    commentService: _commentService,
                                    onDeleted: () {},
                                  ),
                                );
                              },
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
                      final photoUrl = snapshot.data?.get('photo') as String?;
                      return CircleAvatar(
                        backgroundImage:
                            photoUrl != null && !photoUrl.startsWith('assets/')
                                ? NetworkImage(photoUrl)
                                : const AssetImage('assets/images/default.png')
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
                  ElevatedButton(
                    onPressed: _isPostingComment ? null : _addComment,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.all(12),
                    ),
                    child: _isPostingComment
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Icon(Icons.send, color: colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.error,
        child: InkWell(
          onTap: _launchURL,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).goForDiscount,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryTag(String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String translatedText = text;
    final locale = Localizations.localeOf(context).toString();

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

    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        translatedText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  isDark ? colorScheme.onSurfaceVariant : colorScheme.primary,
            ),
      ),
    );
  }
}
