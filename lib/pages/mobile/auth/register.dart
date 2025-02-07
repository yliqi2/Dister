import 'package:dister/controller/firebase/form_validator.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/pages/mobile/auth/mytextfield.dart';
import 'package:dister/pages/mobile/auth/primarybtn.dart';
import 'package:dister/pages/mobile/home/homescreen.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:dister/controller/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();
  User? users;

  void register() async {
    User? user = await _auth.register(
      _emailController.text.toLowerCase(),
      _passwordController.text,
      context,
    );
    setState(() {
      users = user;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/dister.png',
                  ),
                  Text(
                    'Sign up, to unlock deals!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Let\'s get started & create your account.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                            controller: _usernameController,
                            isPassword: false,
                            hintText: 'Enter your username',
                            label: 'Username',
                            validator: (value) {
                              return FormValidator.usernameValidator(
                                value,
                                context,
                              );
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          isPassword: false,
                          hintText: 'Enter your email address',
                          label: 'Email',
                          validator: (value) {
                            return FormValidator.emailValidator(value, context);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          isPassword: true,
                          hintText: 'Enter your password',
                          label: 'Password',
                          validator: (value) {
                            return FormValidator.passwordValidator(
                                value, context);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          isPassword: true,
                          hintText: 'Confirm your password',
                          label: 'Confirm Password',
                          validator: (value) {
                            return FormValidator.confirmPassValidator(
                                value, _passwordController.text, context);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'By signing up, you agree to our ',
                                style: TextStyle(color: subtext),
                              ),
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              TextSpan(
                                text: ' & ',
                                style: TextStyle(color: subtext),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (users != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Homescreen(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please fix the errors in the form'),
                                ),
                              );
                            }
                          },
                          child: primaryBtn(context: context, text: 'Register'),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Or',
                              style: TextStyle(
                                  color: subtext,
                                  fontFamily: 'Manrope',
                                  fontSize: 14),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          socialbtn(
                              asset: 'assets/images/form_logos/google.png',
                              isApple: false),
                          socialbtn(
                              asset: 'assets/images/form_logos/meta.png',
                              isApple: false),
                          socialbtn(
                              asset: 'assets/images/form_logos/apple.png',
                              isApple: true),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(color: subtext),
                                ),
                                TextSpan(
                                  text: 'Log in',
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
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector socialbtn({
    required String asset,
    required bool isApple,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement social login logic
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isApple
              ? Image.asset(
                  asset,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : Image.asset(asset),
        ),
      ),
    );
  }
}
