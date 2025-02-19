import 'package:dister/generated/l10n.dart';
import 'package:dister/pages/mobile/onboarding/intropage.dart';
import 'package:flutter/material.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: height,
                child: Intropage(
                  background: 'assets/images/intropage/background1.png',
                  title: S.of(context).title_onboarding,
                  subtitles: S.of(context).subtitle_onboarding,
                ),
              ),
            ]),
      ),
    );
  }
}
