import 'package:dister/controllers/firebase/auth/auth.dart';
import 'package:dister/controllers/firebase/auth/form_validator.dart';
import 'package:dister/controllers/provider/authnotifier.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/intro_page.dart';
import 'package:dister/screens/tablet/others/register_tablet_screen.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:dister/widgets/custom_textfield.dart';
import 'package:dister/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:dister/controllers/provider/app_state_provider.dart';

class LoginTabletScreen extends StatefulWidget {
  const LoginTabletScreen({super.key});

  @override
  State<LoginTabletScreen> createState() => _LoginTabletScreenState();
}

class _LoginTabletScreenState extends State<LoginTabletScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller = PageController();

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
    if (!mounted) return;
    if (user != null) {
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
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SizedBox(
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
                              background:
                                  'assets/images/intropage/background1.png',
                              title: S.of(context).title_onboarding,
                              subtitles: S.of(context).subtitle_onboarding,
                            ),
                            IntroPage(
                              background:
                                  'assets/images/intropage/background2.png',
                              title: S.of(context).title_onboarding2,
                              subtitles: S.of(context).subtitle_onboarding2,
                            ),
                            IntroPage(
                              background:
                                  'assets/images/intropage/background3.png',
                              title: S.of(context).title_onboarding3,
                              subtitles: S.of(context).subtitle_onboarding3,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Image.asset(
                            'assets/images/intropage/intropage.png'),
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
                                  dotColor:
                                      Theme.of(context).colorScheme.secondary,
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
                    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    //child: const Login(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<LoginAuthErrorNotifier>(
                          builder: (context, errorNotifier, child) {
                            if (errorNotifier.error != null) {
                              switch (errorNotifier.error) {
                                case 'invalid-credential':
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showSnack(S.of(context).errorCredential);
                                  });
                                  break;
                                case 'network-request-failed':
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showSnack(S.of(context).errorNetwork);
                                  });
                                  break;
                                default:
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showSnack(S
                                        .of(context)
                                        .errorUnknow(errorNotifier.error!));
                                  });
                                  break;
                              }
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 26.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).loginTitle,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Text(
                                      S.of(context).loginSubtitle,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomTextField(
                                            controller: _emailController,
                                            isPassword: false,
                                            hintText: S.of(context).hintEmail,
                                            label: 'Email',
                                            maxLines: 1,
                                            validator: (value) {
                                              return FormValidator
                                                  .emailValidator(
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
                                                  text: S
                                                      .of(context)
                                                      .forgotPassword,
                                                  style:
                                                      TextStyle(color: subtext),
                                                ),
                                                TextSpan(
                                                  text: S
                                                      .of(context)
                                                      .resetPassword,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          // Botón de login
                                          GestureDetector(
                                            onTap: () {
                                              if (_formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                login(errorNotifier);
                                              } else {
                                                showSnack(
                                                    S.of(context).formError);
                                              }
                                            },
                                            child: primaryButton(
                                                context: context,
                                                text: 'Login'),
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
                                              builder: (context) =>
                                                  const RegisterTabletScreen(),
                                            ),
                                          );
                                        },
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: S.of(context).noAccount,
                                                style:
                                                    TextStyle(color: subtext),
                                              ),
                                              TextSpan(
                                                text: S.of(context).joinUs,
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
