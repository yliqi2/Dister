import 'package:dister/controllers/firebase/auth/form_validator.dart';
import 'package:dister/controllers/provider/authnotifier.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/screens/mobile/others/login_screen.dart';
import 'package:dister/widgets/custom_textfield.dart';
import 'package:dister/widgets/primary_button.dart';
import 'package:dister/widgets/navigation_bar.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:dister/controllers/firebase/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dister/controllers/provider/app_state_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  User? _user;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  // Esta función muestra el SnackBar si hay un error
  void showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void register(RegisterErrorNotifier errorNotifier) async {
    User? user = await _auth.register(_emailController.text.toLowerCase(),
        _passwordController.text, _usernameController.text, errorNotifier);
    setState(() {
      _user = user;
    });

    if (_user != null && mounted) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      if (appState.saveCredentials) {
        appState.saveUserCredentials(
          _emailController.text.toLowerCase(),
          _passwordController.text,
        );
      }
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
      body: Consumer<RegisterErrorNotifier>(
        builder: (context, errorNotifier, child) {
          if (errorNotifier.error != null) {
            switch (errorNotifier.error) {
              case 'email-already-in-use':
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSnack(S.of(context).emailInUse);
                });
                break;
              case 'username-already-in-use':
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSnack(S.of(context).usernameInUse);
                });
                break;
            }
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/dister.png'),
                      Text(
                        S.of(context).signTitle,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        S.of(context).signSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                  controller: _usernameController,
                                  isPassword: false,
                                  hintText: S.of(context).hintUser,
                                  label: S.of(context).userLabel,
                                  validator: (value) {
                                    return FormValidator.usernameValidator(
                                        value, context);
                                  }),
                              const SizedBox(height: 16),
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
                                isPassword: true,
                                hintText: S.of(context).hintPass,
                                label: S.of(context).password,
                                maxLines: 1,
                                validator: (value) {
                                  return FormValidator.passwordValidator(
                                      value, context);
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                isPassword: true,
                                hintText: S.of(context).hintConfirmPass,
                                label: S.of(context).confirmPassword,
                                maxLines: 1,
                                validator: (value) {
                                  return FormValidator.confirmPassValidator(
                                      value, _passwordController.text, context);
                                },
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    register(errorNotifier);
                                  } else {
                                    showSnack(
                                      S.of(context).formError,
                                    );
                                  }
                                },
                                child: primaryButton(
                                  context: context,
                                  text: S.of(context).registerbtn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).AlreadyAccount,
                                  style: TextStyle(color: subtext),
                                ),
                                TextSpan(
                                  text: S.of(context).login,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
            ),
          );
        },
      ),
    );
  }
}
