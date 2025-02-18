import 'package:flutter/material.dart';

class LoginTab extends StatefulWidget{

 @override
  State<LoginTab> createState() => _LoginTabState();

}

class _LoginTabState extends State<LoginTab>{

@override
  Widget build(BuildContext context) {
   
    return Scaffold(
    body: Expanded(
        child: Column(
          children: [
            Column(
              children: [
                  Image.asset("assets/images/intropage/background1.png",  ),
              ], 
            ),
            Column(

              children: [
                Image.asset("assets/images/intropage/background1.png"),
              ],

            ),
          ],
        ),
    ),

    );
  }

}