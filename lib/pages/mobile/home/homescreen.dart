import 'package:dister/generated/l10n.dart';
import 'package:dister/model/listing.dart';
import 'package:dister/widgets/listingtile.dart';
import 'package:dister/widgets/titletile.dart';
import 'package:flutter/material.dart';

import 'package:animated_hint_textfield/animated_hint_textfield.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // Lista de ofertas (ejemplo)
  final List<Listing> offers = List.generate(
    10,
    (index) => Listing(
      title: "Oferta $index",
      desc: "Descripción de la oferta $index",
      publishedAt: DateTime.now().subtract(Duration(hours: index * 8)),
      link: "https://example.com",
      expiresAt: DateTime.now().add(Duration(days: index)),
      originalPrice: 100.0 + index * 10,
      discountPrice: 80.0 + index * 8,
      storeName: "Tienda $index",
      likes: index * 1200,
      rating: (index % 5) + 1.0,
      images: ["https://via.placeholder.com/150"],
      highlights: ["Envío gratis", "Descuento limitado"],
      owner: "user_$index",
    ),
  );
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
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
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
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.only(right: 26, left: 26, top: 5, bottom: 5),
              sliver: SliverToBoxAdapter(
                child: Titletile(
                  text: S.of(context).categories,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250, // Altura del contenedor
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Scroll horizontal
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Listingtile(listing: offers[index]),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250, // Altura del contenedor
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Scroll horizontal
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Listingtile(listing: offers[index]),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250, // Altura del contenedor
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Scroll horizontal
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Listingtile(listing: offers[index]),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250, // Altura del contenedor
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Scroll horizontal
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Listingtile(listing: offers[index]),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("other profile"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
