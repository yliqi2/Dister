import 'package:dister/theme/dark_mode.dart';
import 'package:flutter/material.dart';

class Intropage extends StatelessWidget {
  final String background;
  final String title;
  final String subtitles;

  const Intropage({
    super.key,
    required this.background,
    required this.title,
    required this.subtitles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo principal
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradiente o decorado en la parte inferior
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                    Colors.black87,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Textos en la parte inferior
          Positioned(
            bottom: 100,
            left: 16,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitles,
                  style: TextStyle(
                    fontSize: 16,
                    color: subtitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
