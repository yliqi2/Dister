import 'package:dister/pages/mobile/auth/primarybtn.dart';
import 'package:dister/pages/mobile/auth/register.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:dister/pages/mobile/auth/mytextfield.dart';
import 'package:dister/generated/l10n.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //logo
                  Image.asset('assets/images/dister.png'),

                  //eslogan welcome
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
                          controller: _emailController,
                          isPassword: false,
                          hintText: 'Enter your email address',
                          label: 'Email',
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.contains(' ')) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Enter your password',
                          label: 'Password',
                          isPassword: true,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.contains(' ')) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
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
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.primary,
                                ), // Color rojo
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        primaryBtn(context: context, text: 'Login'),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      //or
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
                              style: TextStyle(color: subtext, fontSize: 14),
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
                                  builder: (context) => const Register()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).noAccount,
                                  style:
                                      TextStyle(color: subtext), // Color normal
                                ),
                                TextSpan(
                                  text: S.of(context).joinUs,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ), // Color rojo
                                ),
                              ],
                            ),
                          ),
                        ),
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
      //TODO IMPLEMENTS LOGIN WITH G F A
      onTap: () {},
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
