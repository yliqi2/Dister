import 'package:flutter/material.dart';

class RegisterTap extends StatefulWidget{
  const RegisterTap({super.key});

@override
State<RegisterTap> createState() => _RegisterTapState();
}

class _RegisterTapState extends State<RegisterTap> {

  @override
  Widget build(BuildContext context) {
    
    double widht = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: widht,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            
            

          ],
        ),

      ),
    

    );
  }

}