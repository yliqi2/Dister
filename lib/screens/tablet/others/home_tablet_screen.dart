import 'package:dister/generated/l10n.dart';
import 'package:dister/models/categorie_model.dart';
import 'package:dister/models/category_icons_model.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/screens/tablet/posts/post_tablet_screen.dart';
import 'package:dister/widgets/post_container.dart';
import 'package:dister/widgets/custom_filter_dropdown.dart';
import 'package:dister/screens/tablet/chat/chat_list_tablet_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/screens/tablet/posts/new_post_tablet_screen.dart';
import 'package:dister/screens/tablet/posts/favorite_posts_tablet_screen.dart';
import 'package:dister/screens/tablet/posts/api_posts_tablet_screen.dart';
import 'package:dister/screens/tablet/profile/profile_tablet_screen.dart';
import 'package:dister/widgets/sidebar_tablet.dart';

class HomeTabletScreen extends StatefulWidget {
  final int initialIndex;
  const HomeTabletScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeTabletScreen> createState() => _HomeTabletScreenState();
}

class _HomeTabletScreenState extends State<HomeTabletScreen> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    const HomeTabletContent(),
    const ApiPostsTabletScreen(),
    const NewPostTabletScreen(),
    const FavoritePostsTabletScreen(),
    const ProfileTabletScreen(),
  ];

  void _onSidebarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarTablet(
              selectedIndex: _selectedIndex,
              onTap: _onSidebarTap,
            ),
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTabletContent extends StatefulWidget {
  const HomeTabletContent({super.key});
  @override
  State<HomeTabletContent> createState() => _HomeTabletContentState();
}

class _HomeTabletContentState extends State<HomeTabletContent> {
  Future<List<Post>> _listingsFuture = Future.value([]);
  String _selectedCategory = '';
  String _selectedSubcategory = '';
  String? categoryId;
  List<String> _subcategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listingsFuture = _fetchListings();
  }

  Future<List<Post>> _fetchListings() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('listings').get();
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  List<Post> _filterListings(List<Post> listings) {
    return listings.where((listing) {
      final matchesCategory = _selectedCategory.isEmpty ||
          _selectedCategory == S.of(context).allCategoriesFilter;
      final categoryMatch = matchesCategory ||
          ProductCategories.getCategories().any((category) {
            if (category.getName(Localizations.localeOf(context).toString()) ==
                    _selectedCategory &&
                category.id == listing.categories) {
              return true;
            }
            if (category.getName(Localizations.localeOf(context).toString()) ==
                    _selectedCategory &&
                category.getName(Localizations.localeOf(context).toString()) ==
                    listing.categories) {
              return true;
            }
            if (category.getName(Localizations.localeOf(context).toString()) ==
                    _selectedCategory &&
                category.names.values.contains(listing.categories)) {
              return true;
            }
            return false;
          });
      final matchesSubcategory = _selectedSubcategory.isEmpty ||
          listing.subcategories == _selectedSubcategory ||
          _selectedSubcategory == S.of(context).allSubcategoriesFilter;
      final matchesSearch = _searchController.text.isEmpty ||
          listing.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return categoryMatch && matchesSubcategory && matchesSearch;
    }).toList();
  }

  void _updateSubcategories(String categoryId) {
    final category = ProductCategories.getCategoryById(categoryId);
    setState(() {
      _subcategories =
          category.getSubcategories(Localizations.localeOf(context).toString());
      _selectedSubcategory = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 32;
    const double gridSpacing = 24;
    const int crossAxisCount = 4;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: AnimatedTextField(
                  controller: _searchController,
                  animationType: Animationtype.typer,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  hintTexts: [
                    S.of(context).searchHint,
                    S.of(context).searchHint2,
                    S.of(context).searchHint3,
                  ],
                  animationDuration: const Duration(seconds: 3),
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_rounded,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChatListTabletScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: CustomFilterDropdown(
                  value: _selectedCategory.isEmpty ? null : _selectedCategory,
                  hint: S.of(context).selectCategoryFilter,
                  icon: Icons.category_rounded,
                  items: [
                    DropdownItem(
                      value: S.of(context).allCategoriesFilter,
                      label: S.of(context).allCategoriesFilter,
                      icon: Icons.all_inbox,
                    ),
                    ...ProductCategories.getCategories().map(
                      (category) {
                        final categoryName = category.getName(
                            Localizations.localeOf(context).toString());
                        return DropdownItem(
                          value: categoryName,
                          label: categoryName,
                          icon: CategoryIcons.getIconForCategory(category.id),
                        );
                      },
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? '';
                      final selected =
                          ProductCategories.getCategories().firstWhere(
                        (cat) =>
                            cat.getName(
                                Localizations.localeOf(context).toString()) ==
                            value,
                        orElse: () => ProductCategories.getCategories().first,
                      );
                      categoryId = selected.id;
                      _updateSubcategories(categoryId!);
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFilterDropdown(
                  value: _selectedSubcategory.isEmpty
                      ? null
                      : _selectedSubcategory,
                  hint: S.of(context).selectSubcategoryFilter,
                  icon: Icons.filter_alt_rounded,
                  items: [
                    DropdownItem(
                      value: S.of(context).allSubcategoriesFilter,
                      label: S.of(context).allSubcategoriesFilter,
                      icon: Icons.all_inbox,
                    ),
                    ..._subcategories.map(
                      (subcat) => DropdownItem(
                        value: subcat,
                        label: subcat,
                        icon: Icons.label_outline,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSubcategory = value ?? '';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<Post>>(
            future: _listingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child:
                        Text(S.of(context).error(snapshot.error.toString())));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(S.of(context).noListingsAvailable));
              } else {
                final filteredListings = _filterListings(snapshot.data!);
                if (filteredListings.isEmpty) {
                  return Center(child: Text(S.of(context).noListingsAvailable));
                }
                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: horizontalPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: gridSpacing,
                    mainAxisSpacing: gridSpacing,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredListings.length,
                  itemBuilder: (context, index) {
                    final listing = filteredListings[index];
                    return PostContainer(
                      listing: listing,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PostTabletScreen(listing: listing),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
