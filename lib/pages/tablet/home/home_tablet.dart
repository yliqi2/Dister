import 'package:flutter/material.dart';

class HomeTablet extends StatefulWidget {
  const HomeTablet({super.key});

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //calcular una tercera parte de la pantalla
    double tamanoCuadrante = width / 3;

    double sizedLateralBar = tamanoCuadrante;
    double sizedHome = tamanoCuadrante * 2;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: sizedLateralBar,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 108, 101, 209),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                width: sizedHome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
