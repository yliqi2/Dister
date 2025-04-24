import 'package:dister/controller/firebase/auth/form_validator.dart';
import 'package:dister/controller/provider/authnotifier.dart';
import 'package:dister/controller/provider/app_state_provider.dart';
import 'package:dister/pages/mobile/nav/navbar.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dister/controller/firebase/auth/auth.dart';

import 'package:dister/pages/mobile/auth/register.dart';
import 'package:dister/widgets/primarybtn.dart';
import 'package:dister/widgets/mytextfield.dart';
import 'package:dister/generated/l10n.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      if (appState.saveCredentials &&
          appState.savedEmail != null &&
          appState.savedPassword != null) {
        _emailController.text = appState.savedEmail!;
        _passwordController.text = appState.savedPassword!;
      }
    });
  }

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
    if (user != null && mounted) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      appState.saveUserCredentials(
        _emailController.text.toLowerCase(),
        _passwordController.text,
      );

      Navigator.pushReplacement(
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
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                login(errorNotifier);
                              } else {
                                showSnack(S.of(context).formError);
                              }
                            },
                            child: primaryBtn(
                                context: context, text: S.of(context).loginbtn),
                          ),
                        ],
                      ),
                    ),
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
