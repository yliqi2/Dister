import 'package:dister/generated/l10n.dart';
import 'package:dister/model/categorie.dart';
import 'package:dister/model/listing.dart';
import 'package:dister/widgets/listingtile.dart';

import 'package:flutter/material.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Future<List<Listing>> _listingsFuture = Future.value([]);
  String _selectedCategory = '';
  String _selectedSubcategory = '';
  String? categoryId;
  List<String> _subcategories = [];

  @override
  void initState() {
    super.initState();
    _listingsFuture = _fetchListings();
  }

  Future<List<Listing>> _fetchListings() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('listings').get();
    return snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList();
  }

  List<Listing> _filterListings(List<Listing> listings) {
    return listings.where((listing) {
      final matchesCategory = _selectedCategory.isEmpty ||
          listing.categories == _selectedCategory ||
          _selectedCategory == 'Todas las categorías';
      final matchesSubcategory = _selectedSubcategory.isEmpty ||
          listing.subcategories == _selectedSubcategory ||
          _selectedSubcategory == 'Todas las subcategorías';
      return matchesCategory && matchesSubcategory;
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
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 26.0, left: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.chat_bubble_rounded,
                        color: Colors.white),
                    onPressed: () {},
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
                        animationType: Animationtype.typer,
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
                    DropdownButton<String>(
                      isExpanded: true,
                      value:
                          _selectedCategory.isEmpty ? null : _selectedCategory,
                      hint: const Text("Selecciona una categoría"),
                      items: [
                        const DropdownMenuItem(
                          value: 'Todas las categorías',
                          child: Text("Todas las categorías"),
                        ),
                        ...ProductCategories.getCategories().map(
                          (category) {
                            final categoryName = category.getName(
                                Localizations.localeOf(context).toString());
                            return DropdownMenuItem(
                              value: categoryName,
                              child: Text(categoryName),
                            );
                          },
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value ?? '';
                          if (_selectedCategory == 'Todas las categorías') {
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
                          categoryId = selectedCategoryObj
                              .id; // Guardamos el ID de la categoría
                          _updateSubcategories(categoryId!);
                        });
                      },
                    ),
                    if (_subcategories.isNotEmpty)
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedSubcategory.isEmpty
                            ? null
                            : _selectedSubcategory,
                        hint: const Text("Selecciona una subcategoría"),
                        items: [
                          const DropdownMenuItem(
                            value: 'Todas las subcategorías',
                            child: Text("Todas las subcategorías"),
                          ),
                          ..._subcategories.map((subcategory) {
                            return DropdownMenuItem(
                              value: subcategory,
                              child: Text(subcategory),
                            );
                          }),
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
              child: FutureBuilder<List<Listing>>(
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
                          childAspectRatio: 0.710,
                        ),
                        itemCount: filteredListings.length,
                        itemBuilder: (context, index) {
                          return Listingtile(listing: filteredListings[index]);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
