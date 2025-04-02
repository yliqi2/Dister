import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/model/listing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Listingdetails extends StatefulWidget {
  final Listing listing;
  const Listingdetails({super.key, required this.listing});
  @override
  State<Listingdetails> createState() => _ListingdetailsState();
}

class _ListingdetailsState extends State<Listingdetails> {
  String? ownerPhoto;
  String? ownerName;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchOwnerDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.listing.images;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 300,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
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
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              title: Text(
                ownerName != null ? '@$ownerName' : '@Unknown',
                style: const TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(((widget.listing.originalPrice - widget.listing.discountPrice) / widget.listing.originalPrice) * 100).round()}% off',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${widget.listing.discountPrice.toStringAsFixed(0)}€',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.listing.originalPrice.toStringAsFixed(0)}€',
                          style: const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Product Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.listing.desc,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Shopping Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• ${widget.listing.storeName}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (widget.listing.rating != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '• Rating: ${widget.listing.rating!.toStringAsFixed(1)} ⭐',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '• ${widget.listing.getFormattedLikes()} Likes',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Posted ${widget.listing.getTimeAgo()} ago',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (widget.listing.expiresAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '• Expires on ${widget.listing.getFormattedExpiry()}',
                        style: const TextStyle(color: Colors.grey),
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
                    if (widget.listing.link.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.link,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.listing.link,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Go for the discount",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _categoryTag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
