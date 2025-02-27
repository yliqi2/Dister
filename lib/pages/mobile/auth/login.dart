import 'package:dister/controller/firebase/auth/form_validator.dart';
import 'package:dister/controller/provider/authnotifier.dart';
import 'package:dister/pages/mobile/nav/navbar.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar provider
import 'package:dister/controller/firebase/auth/auth.dart'; // Importar AuthService

import 'package:dister/pages/mobile/auth/register.dart'; // Pantalla de registro
import 'package:dister/widgets/primarybtn.dart'; // El widget de botón de login
import 'package:dister/widgets/mytextfield.dart'; // El widget de campo de texto personalizado
import 'package:dister/generated/l10n.dart'; // Soporte para internacionalización (localización)

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void login(LoginAuthErrorNotifier errorNotifier) async {
    User? user = await _auth.login(
      _emailController.text.toLowerCase(),
      _passwordController.text,
      errorNotifier,
    );
    if (user != null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const Navbar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<LoginAuthErrorNotifier>(
        builder: (context, errorNotifier, child) {
          if (errorNotifier.error != null) {
            switch (errorNotifier.error) {
              case 'invalid-credential':
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSnack(S.of(context).errorCredential);
                });
                break;
              case 'network-request-failed':
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSnack(S.of(context).errorNetwork);
                });
                break;
              default:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSnack(S.of(context).errorUnknow(errorNotifier.error!));
                });
                break;
            }
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/dister.png'),
                    Text(
                      S.of(context).loginTitle,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      S.of(context).loginSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            isPassword: false,
                            hintText: S.of(context).hintEmail,
                            label: 'Email',
                            validator: (value) {
                              return FormValidator.emailValidator(
                                  value, context);
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: S.of(context).hintPass,
                            label: S.of(context).password,
                            isPassword: true,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).forgotPassword,
                                  style: TextStyle(color: subtext),
                                ),
                                TextSpan(
                                  text: S.of(context).resetPassword,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botón de login
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                login(errorNotifier);
                              } else {
                                showSnack(S.of(context).formError);
                              }
                            },
                            child: primaryBtn(context: context, text: 'Login'),
                          ),
                        ],
                      ),
                    ),

                    // Enlace a la pantalla de registro
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: S.of(context).noAccount,
                                style: TextStyle(color: subtext),
                              ),
                              TextSpan(
                                text: S.of(context).joinUs,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
