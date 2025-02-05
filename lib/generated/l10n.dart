// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Find what\nyou need and more`
  String get title_onboarding {
    return Intl.message(
      'Find what\nyou need and more',
      name: 'title_onboarding',
      desc: '',
      args: [],
    );
  }

  /// `Discover treasures and great deals.\nConnect today!`
  String get subtitle_onboarding {
    return Intl.message(
      'Discover treasures and great deals.\nConnect today!',
      name: 'subtitle_onboarding',
      desc: '',
      args: [],
    );
  }

  /// `Get More,\nSpend Less`
  String get title_onboarding2 {
    return Intl.message(
      'Get More,\nSpend Less',
      name: 'title_onboarding2',
      desc: '',
      args: [],
    );
  }

  /// `Compare prices and get the best deals \nwith a tap!`
  String get subtitle_onboarding2 {
    return Intl.message(
      'Compare prices and get the best deals \nwith a tap!',
      name: 'subtitle_onboarding2',
      desc: '',
      args: [],
    );
  }

  /// `Never\nMiss Out Again`
  String get title_onboarding3 {
    return Intl.message(
      'Never\nMiss Out Again',
      name: 'title_onboarding3',
      desc: '',
      args: [],
    );
  }

  /// `Your next great deal is just\na notification away.`
  String get subtitle_onboarding3 {
    return Intl.message(
      'Your next great deal is just\na notification away.',
      name: 'subtitle_onboarding3',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
