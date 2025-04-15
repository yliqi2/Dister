import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/pages/tablet/home/homeTablet.dart

//Clases que llama el Home para cargar las diferentes UI's del Home
import 'Pages/chats_tab_page.dart';
import 'Pages/home_tab_page.dart';
import 'Pages/notificationas_tab_page.dart';
import 'Pages/profile_tab_page.dart';
import 'Pages/settings_tab_page.dart';
import 'Pages/shop_tab_page.dart';
import 'Pages/sidebar_menu.dart';
=======
>>>>>>> Liqi:lib/pages/tablet/home/home_tablet.dart

class HomeTablet extends StatefulWidget {
  const HomeTablet({super.key});

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD:lib/pages/tablet/home/homeTablet.dart

=======
>>>>>>> Liqi:lib/pages/tablet/home/home_tablet.dart
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //calcular una tercera parte de la pantalla
    double tamanoCuadrante = width / 3;

    double sizedLateralBar = tamanoCuadrante;
    double sizedHome = tamanoCuadrante * 2;

    List<Widget> pages = [];

    return Scaffold(
<<<<<<< HEAD:lib/pages/tablet/home/homeTablet.dart
      body: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
=======
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
>>>>>>> Liqi:lib/pages/tablet/home/home_tablet.dart
          children: [
            Expanded(
              flex: 2,
              child: Container(
<<<<<<< HEAD:lib/pages/tablet/home/homeTablet.dart
                //width: SizedLateralBar,
                decoration: BoxDecoration(
                  color : Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                   
                  children: [
                     
                  ],
 
=======
                width: sizedLateralBar,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 108, 101, 209),
>>>>>>> Liqi:lib/pages/tablet/home/home_tablet.dart
                ),
              ),
            ),
            Expanded(
              flex:6,
              child: Container(
<<<<<<< HEAD:lib/pages/tablet/home/homeTablet.dart
                decoration: BoxDecoration(
                  color : Theme.of(context).scaffoldBackgroundColor,
                ),
                //width: SizedHome,
                child: Navigator(onGenerateRoute: (settings){
                    
                    Widget page = HomeTabPage();

                    switch(settings.name)
                    {
                      case '/home':
                       page = HomeTabPage();
                       break;
                      case '/shop':
                       page = HomeTabPage();
                       break;
                      case '/profile':
                       page = HomeTabPage();
                       break;
                    }
                }
                
                
                ),
=======
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                width: sizedHome,
>>>>>>> Liqi:lib/pages/tablet/home/home_tablet.dart
              ),
            ),
          ],
        ),
<<<<<<< HEAD:lib/pages/tablet/home/homeTablet.dart
=======
      ),
>>>>>>> Liqi:lib/pages/tablet/home/home_tablet.dart
    );
  }
}
