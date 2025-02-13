import 'package:shared_preferences/shared_preferences.dart';

class Welcome {
  Future<bool> seenBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    final boarding = prefs.getBool("onboarding") ?? false;
    return boarding;
  }

  Future<void> saveBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarding", true);
  }
}

