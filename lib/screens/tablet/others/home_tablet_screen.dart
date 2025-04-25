import 'package:flutter/material.dart';

class HomeTabletScreen extends StatefulWidget {
  const HomeTabletScreen({super.key});

  @override
  State<HomeTabletScreen> createState() => _HomeTabletScreenState();
}

class _HomeTabletScreenState extends State<HomeTabletScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double tamanoCuadrante = width / 3;

    double sizedLateralBar = tamanoCuadrante;
    double sizedHome = tamanoCuadrante * 2;

    return Scaffold(
      body: SizedBox(),
    );
  }
}
