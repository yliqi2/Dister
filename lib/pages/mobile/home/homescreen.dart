import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: SizedBox(
            child: Image.asset(
              'assets/images/intropage/intropage.png', // Ajusta la imagen dentro de las dimensiones
              fit: BoxFit.fill,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chat_bubble_rounded),
          )
        ],
      ),
    );
  }
}
