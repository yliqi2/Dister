import 'package:flutter/material.dart';
import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:dister/controller/provider/app_state_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _toggleUseSystemTheme(bool value) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.toggleUseSystemTheme(value);

    if (value) {
      appState.updateFromSystem();
    }
  }

  void _toggleUseSystemLanguage(bool value) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.toggleUseSystemLanguage(value);

    if (value) {
      appState.updateFromSystem();
    }
  }

  void _selectTheme(bool isDarkTheme) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.toggleTheme(isDarkTheme);

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final systemIsDark = brightness == Brightness.dark;

    if (isDarkTheme != systemIsDark) {
      appState.toggleUseSystemTheme(false);
    }
  }

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    if (locale.languageCode != systemLocale.languageCode) {
      appState.toggleUseSystemLanguage(false);
    }

    appState.changeLanguage(locale);
    await S.load(locale);
    setState(() {});
  }

  void _showThemeSelector(BuildContext context, bool currentIsDark) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).selectTheme,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: Text(S.of(context).lightTheme),
                trailing: !currentIsDark
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  _selectTheme(false);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.nightlight_round),
                title: Text(S.of(context).darkTheme),
                trailing: currentIsDark
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  _selectTheme(true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).settings),
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text(
                  S.of(context).themeOptions,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SwitchListTile(
                title: Text(S.of(context).useSystemTheme),
                subtitle: Text(S.of(context).systemThemeDescription),
                secondary: const Icon(Icons.sync),
                value: appState.useSystemTheme,
                onChanged: _toggleUseSystemTheme,
              ),
              ListTile(
                leading: appState.isDarkTheme
                    ? const Icon(Icons.nightlight_round)
                    : const Icon(Icons.wb_sunny),
                title: Text(S.of(context).selectThemeOption),
                subtitle: Text(appState.isDarkTheme
                    ? S.of(context).darkThemeOption
                    : S.of(context).lightThemeOption),
                onTap: () => _showThemeSelector(context, appState.isDarkTheme),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  S.of(context).languageOptions,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SwitchListTile(
                title: Text(S.of(context).useSystemLanguage),
                subtitle: Text(S.of(context).systemLanguageDescription),
                secondary: const Icon(Icons.sync_alt),
                value: appState.useSystemLanguage,
                onChanged: _toggleUseSystemLanguage,
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(S.of(context).changeLanguage),
                subtitle: Text(appState.languageCode == 'en'
                    ? S.of(context).languageEnglish
                    : S.of(context).languageSpanish),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).selectLanguage,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(S.of(context).languageEnglish),
                              trailing: appState.languageCode == 'en'
                                  ? Icon(
                                      Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                _changeLanguage(context, const Locale('en'));
                                Navigator.pop(context);
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(S.of(context).languageSpanish),
                              trailing: appState.languageCode == 'es'
                                  ? Icon(
                                      Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                _changeLanguage(context, const Locale('es'));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: Text(
                  S.of(context).otherOptions,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SwitchListTile(
                title: Text(S.of(context).saveSessionData),
                secondary: const Icon(Icons.save),
                value: appState.saveCredentials,
                onChanged: (value) {
                  appState.toggleSaveCredentials(value);
                  if (!value) {
                    appState.clearSavedCredentials();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: Text(S.of(context).deleteAccount),
                onTap: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(S.of(context).deleteAccount),
                        content: Text(S.of(context).confirmDeleteAccount),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(S.of(context).cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(S.of(context).confirm),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm == true) {
                    try {
                      final firebaseServices = FirebaseServices();
                      await firebaseServices.deleteAccount();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(S.of(context).errorDeletingAccount(e)),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(S.of(context).logout),
                onTap: () async {
                  final firebaseServices = FirebaseServices();
                  final navigator = Navigator.of(context, rootNavigator: true);

                  await firebaseServices.signOut();
                  if (!mounted) return;
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
