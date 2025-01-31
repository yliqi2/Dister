import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: Text('data'),
              ),
              Container(
                color: Colors.purple,
              ),
              Container(
                color: Colors.white,
              )
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: const WormEffect(),
            ),
          ),
        ],
      ),
    );
  }
}
