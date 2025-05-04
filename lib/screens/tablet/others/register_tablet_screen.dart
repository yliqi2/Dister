import 'package:dister/controllers/firebase/auth/auth.dart';
import 'package:dister/controllers/firebase/auth/form_validator.dart';
import 'package:dister/controllers/provider/authnotifier.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/custom_textfield.dart';
import 'package:dister/widgets/primary_button.dart';
import 'package:dister/widgets/intro_page.dart';
import 'package:dister/screens/tablet/others/login_tablet_screen.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:dister/controllers/provider/app_state_provider.dart';

class RegisterTabletScreen extends StatefulWidget {
  const RegisterTabletScreen({super.key});

  @override
  State<RegisterTabletScreen> createState() => _RegisterTabletScreenState();
}

class _RegisterTabletScreenState extends State<RegisterTabletScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _controller = PageController();

  User? _user;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void register(RegisterErrorNotifier errorNotifier) async {
    User? user = await _auth.register(
      _emailController.text.toLowerCase(),
      _passwordController.text,
      _usernameController.text,
      errorNotifier,
    );
    setState(() {
      _user = user;
    });

    if (!mounted) return;

    if (_user != null) {
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
          builder: (context) => const HomeTabletScreen(),
        ),
      );
    }
  }

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
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    height: height,
                    child: PageView(
                      controller: _controller,
                      children: [
                        IntroPage(
                          background: 'assets/images/intropage/background1.png',
                          title: S.of(context).title_onboarding,
                          subtitles: S.of(context).subtitle_onboarding,
                        ),
                        IntroPage(
                          background: 'assets/images/intropage/background2.png',
                          title: S.of(context).title_onboarding2,
                          subtitles: S.of(context).subtitle_onboarding2,
                        ),
                        IntroPage(
                          background: 'assets/images/intropage/background3.png',
                          title: S.of(context).title_onboarding3,
                          subtitles: S.of(context).subtitle_onboarding3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Image.asset('assets/images/intropage/intropage.png'),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 26, right: 26, bottom: 48),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmoothPageIndicator(
                            controller: _controller,
                            count: 3,
                            effect: WormEffect(
                              dotHeight: 16,
                              dotWidth: 16,
                              dotColor: Theme.of(context).colorScheme.secondary,
                              activeDotColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<RegisterErrorNotifier>(
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
                            default:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showSnack(S
                                    .of(context)
                                    .errorUnknow(errorNotifier.error!));
                              });
                              break;
                          }
                        }

                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).signTitle,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      S.of(context).signSubtitle,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SingleChildScrollView(
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomTextField(
                                                controller: _usernameController,
                                                isPassword: false,
                                                hintText:
                                                    S.of(context).hintUser,
                                                label: S.of(context).userLabel,
                                                validator: (value) {
                                                  return FormValidator
                                                      .usernameValidator(
                                                          value, context);
                                                }),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              controller: _emailController,
                                              isPassword: false,
                                              hintText: S.of(context).hintEmail,
                                              label: 'Email',
                                              validator: (value) {
                                                return FormValidator
                                                    .emailValidator(
                                                        value, context);
                                              },
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              controller: _passwordController,
                                              isPassword: true,
                                              hintText: S.of(context).hintPass,
                                              label: S.of(context).password,
                                              validator: (value) {
                                                return FormValidator
                                                    .passwordValidator(
                                                        value, context);
                                              },
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextField(
                                              controller:
                                                  _confirmPasswordController,
                                              isPassword: true,
                                              hintText:
                                                  S.of(context).hintConfirmPass,
                                              label:
                                                  S.of(context).confirmPassword,
                                              validator: (value) {
                                                return FormValidator
                                                    .confirmPassValidator(
                                                        value,
                                                        _passwordController
                                                            .text,
                                                        context);
                                              },
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 20),
                                            GestureDetector(
                                              onTap: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
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
                                              builder: (context) =>
                                                  const LoginTabletScreen(),
                                            ),
                                          );
                                        },
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: S
                                                    .of(context)
                                                    .AlreadyAccount,
                                                style:
                                                    TextStyle(color: subtext),
                                              ),
                                              TextSpan(
                                                text: S.of(context).login,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
