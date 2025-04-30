import 'package:dister/controllers/shared_prefs/welcome.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/screens/mobile/others/login_screen.dart';
import 'package:dister/widgets/intro_page.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:flutter/material.dart';

class IntroPagesScreen extends StatefulWidget {
  const IntroPagesScreen({super.key});

  @override
  State<IntroPagesScreen> createState() => _IntroPagesScreenState();
}

class _IntroPagesScreenState extends State<IntroPagesScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset('assets/images/intropage/intropage.png'),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 26, right: 26, bottom: 48),
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
                        activeDotColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onLastPage ? loginBtn(context) : rightarrow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Welcome().saveBoarding();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          S.of(context).continues,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget rightarrow() {
    return GestureDetector(
      onTap: () {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      },
      child: Image.asset('assets/images/intropage/arrow-right-circle.png'),
    );
  }
}
