import 'package:flutter/material.dart';

class HomeTabPage extends  StatefulWidget{


State<HomeTabPage> createState() => _HomeTabPageState();
}


class _HomeTabPageState extends State<HomeTabPage>{


  Widget build(BuildContext context){

    return Scaffold(
      body: Center(child: Text('Home'),),
    ); 
  }

}