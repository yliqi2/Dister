import 'package:dister/generated/l10n.dart';
import 'package:dister/models/categorie_model.dart';
import 'package:dister/models/category_icons_model.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/screens/mobile/posts/post_screen.dart';
import 'package:dister/widgets/post_container.dart';
import 'package:dister/widgets/custom_filter_dropdown.dart';
import 'package:dister/screens/mobile/chat/chat_list_screen.dart';

import 'package:flutter/material.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

      // Intenta hacer coincidir tanto por ID de categoría como por nombre localizado
      final categoryMatch = matchesCategory ||
          ProductCategories.getCategories().any((category) {
            if (category.getName(Localizations.localeOf(context).toString()) ==
                    _selectedCategory &&
                category.id == listing.categories) {
              return true;
            }

            // Coincidencia por nombre localizado (productos antiguos)
            if (category.getName(Localizations.localeOf(context).toString()) ==
                    _selectedCategory &&
                category.getName(Localizations.localeOf(context).toString()) ==
                    listing.categories) {
              return true;
            }

            // Coincidencia por cualquier nombre localizado en otro idioma
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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              floating: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/images/dister.png',
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 90,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 26, left: 20),
                  child: IconButton(
                    icon: Icon(
                      Icons.chat_bubble_rounded,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FollowingListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 8),
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
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.only(right: 26, left: 26, top: 5, bottom: 5),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    CustomFilterDropdown(
                      value:
                          _selectedCategory.isEmpty ? null : _selectedCategory,
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
                              icon:
                                  CategoryIcons.getIconForCategory(category.id),
                            );
                          },
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value ?? '';
                          if (_selectedCategory ==
                              S.of(context).allCategoriesFilter) {
                            _selectedSubcategory = '';
                            _subcategories = [];
                            return;
                          }
                          final selectedCategoryObj =
                              ProductCategories.getCategories().firstWhere(
                            (category) =>
                                category.getName(Localizations.localeOf(context)
                                    .toString()) ==
                                value,
                            orElse: () => ProductCategory(
                                id: '', names: {}, subcategories: []),
                          );
                          categoryId = selectedCategoryObj.id;
                          _updateSubcategories(categoryId!);
                        });
                      },
                    ),
                    if (_subcategories.isNotEmpty)
                      CustomFilterDropdown(
                        value: _selectedSubcategory.isEmpty
                            ? null
                            : _selectedSubcategory,
                        hint: S.of(context).selectSubcategoryFilter,
                        icon: Icons.subdirectory_arrow_right_rounded,
                        items: [
                          DropdownItem(
                            value: S.of(context).allSubcategoriesFilter,
                            label: S.of(context).allSubcategoriesFilter,
                            icon: Icons.all_inbox,
                          ),
                          ..._subcategories.map((subcategory) => DropdownItem(
                                value: subcategory,
                                label: subcategory,
                                icon: CategoryIcons.getIconForSubcategory(
                                    categoryId!, subcategory),
                              )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSubcategory = value ?? '';
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<List<Post>>(
                future: _listingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        S.of(context).errorLoadingListings,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(S.of(context).noListingsAvailable));
                  } else {
                    final filteredListings = _filterListings(snapshot.data!);
                    if (filteredListings.isEmpty) {
                      return Center(
                          child: Text(S.of(context).noListingsAvailable));
                    }
                    final screenWidth = MediaQuery.of(context).size.width;
                    final crossAxisCount = screenWidth < 600 ? 2 : 4;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 5),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.675,
                        ),
                        itemCount: filteredListings.length,
                        itemBuilder: (context, index) {
                          return PostContainer(
                            listing: filteredListings[index],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostScreen(
                                    listing: filteredListings[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 5),
            ),
          ],
        ),
      ),
    );
  }
}
