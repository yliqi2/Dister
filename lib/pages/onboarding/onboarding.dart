import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/pages/mobile/onboarding/intropage.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
              children: const [
                Intropage(
                  background: 'assets/images/intropage/background1.png',
                  title: 'Find what\nyou need and more',
                  subtitles:
                      'Discover treasures and great deals.\nConnect today!',
                ),
                Intropage(
                  background: 'assets/images/intropage/background2.png',
                  title: 'Get More\nSpend Less',
                  subtitles:
                      'Compare prices and get the best deals \nwith a tap!',
                ),
                Intropage(
                  background: 'assets/images/intropage/background3.png',
                  title: 'Never\nMiss Out Again',
                  subtitles:
                      'Your next great deal is just\na notification away.',
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
        //navigate to the page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: const Text(
          'Start Hunting',
          style: TextStyle(
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
