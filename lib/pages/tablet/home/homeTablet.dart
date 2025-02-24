import 'package:flutter/material.dart';

//Clases que llama el Home para cargar las diferentes UI's del Home
import 'Pages/chats_tab_page.dart';
import 'Pages/home_tab_page.dart';
import 'Pages/notificationas_tab_page.dart';
import 'Pages/profile_tab_page.dart';
import 'Pages/settings_tab_page.dart';
import 'Pages/shop_tab_page.dart';
import 'Pages/sidebar_menu.dart';

class HomeTablet extends StatefulWidget {
  const HomeTablet({super.key});

  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet>{

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    //calcular una tercera parte de la pantalla
    double tamanoCuadrante = width/3;

    double SizedLateralBar = tamanoCuadrante; 
    double SizedHome = tamanoCuadrante * 2;


    List<Widget> pages = [];

    return Scaffold(
      body: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            Expanded(
              flex: 2,
              child: Container(
                //width: SizedLateralBar,
                decoration: BoxDecoration(
                  color : Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                   
                  children: [
                     
                  ],
 
                ),
              ),
            ),

            Expanded(
              flex:6,
              child: Container(
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
              ),
            ),

          ],
        ),
    );
  }
}