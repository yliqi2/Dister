import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO( 255, 254, 234, 1),  // Dark ( 33, 32, 32, 1) light ( 255, 254, 234, 1)
      appBar: AppBar(
        backgroundColor: Color.fromRGBO( 255, 254, 234, 1),  // Dark ( 33, 32, 32, 1) light ( 255, 254, 234, 1)
        automaticallyImplyLeading: false,

        title: Image.asset( 'assets/images/branding.png',
            width: 80,
            height: 90,
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(

          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome back, Log int to your deals.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text('Enter your details to start saving and shopping smarter!',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    //textAlign: TextAlign.right,
                  ),

                ],
              ),
            ),

            TextField(
              cursorColor: Colors.black,

              obscureText: true,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Enter your email address',
              ),
            ),



          ],
        ),
        ),

      ),

    );
  }

}

class Login extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context)
          .colorScheme
          .surface, //fromRGBO(255, 254, 234, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Image.asset(
          'assets/images/branding.png',
          width: 80,
          height: 80,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            'Welcome back, Log in to your deals.',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            'Enter your details to start saving and shopping smarter!',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Email TextField
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),

                  //Password TextField
                  Padding(
                    padding: EdgeInsets.only(bottom: 12, top: 14),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Manrope',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      obscureText: true,
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        'Forgot your password? ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Reset Password');
                        },
                        child: Text(
                          'Reset your password',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: (TextDecoration.underline),
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () { },
                      child: Container(
                        width: 540,
                        height: 50,
                        alignment: Alignment.center,
                        //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            color: Theme.of(context).colorScheme.secondary,
                            //fontWeight: FontWeight.w800,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          'Or',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            child: Image.asset(
                              'assets/images/others-logins/google.png',
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            child: Image.asset(
                              'assets/images/others-logins/meta.png',
                              //width: 20,
                              //height: 20,
                              alignment: Alignment.center,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            child: Image.asset(
                              'assets/images/others-logins/light_apple.png',
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don´t have an account? ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('join');
                        },
                        child: Text(
                          'Join',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

