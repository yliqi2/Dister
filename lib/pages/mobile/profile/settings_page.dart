import 'package:dister/pages/mobile/nav/navbar.dart';
import 'package:dister/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:dister/controller/provider/theme_notifier.dart';
import 'package:dister/controller/provider/language_notifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dister/controller/blocs/app_state_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _toggleDarkTheme(bool value) async {
    // Actualizar el tema
    context.read<AppStateBloc>().add(ThemeChanged(value));

    // Verificar si es necesario desactivar el uso del tema del sistema
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final systemIsDark = brightness == Brightness.dark;

    // Solo desactivar si el valor elegido es diferente al del sistema
    if (value != systemIsDark) {
      context.read<AppStateBloc>().add(UseSystemTheme(false));
    }
  }

  void _toggleUseSystemTheme(bool value) async {
    context.read<AppStateBloc>().add(UseSystemTheme(value));

    // Si habilitamos el uso del tema del sistema, actualizar inmediatamente
    if (value) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      context.read<AppStateBloc>().add(UpdateFromSystem(brightness, locale));
    }
  }

  void _toggleUseSystemLanguage(bool value) async {
    context.read<AppStateBloc>().add(UseSystemLanguage(value));

    // Si habilitamos el uso del idioma del sistema, actualizar inmediatamente
    if (value) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      context.read<AppStateBloc>().add(UpdateFromSystem(brightness, locale));
    }
  }

  void _selectTheme(bool isDarkTheme) {
    // Actualizar el tema
    context.read<AppStateBloc>().add(ThemeChanged(isDarkTheme));

    // Verificar si es necesario desactivar el uso del tema del sistema
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final systemIsDark = brightness == Brightness.dark;

    // Solo desactivar si el valor elegido es diferente al del sistema
    if (isDarkTheme != systemIsDark) {
      context.read<AppStateBloc>().add(UseSystemTheme(false));
    }
  }

  void _changeLanguage(BuildContext context, Locale locale) async {
    // Verificar si es necesario desactivar el uso del idioma del sistema
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Solo desactivar si el idioma elegido es diferente al del sistema
    if (locale.languageCode != systemLocale.languageCode) {
      context.read<AppStateBloc>().add(UseSystemLanguage(false));
    }

    // Actualizar el idioma
    context.read<AppStateBloc>().add(LanguageChanged(locale.languageCode));
    await S.load(locale);
    setState(() {}); // Forzar la reconstrucción de esta pantalla
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: Text(S.of(context).lightTheme),
                trailing: !currentIsDark
                    ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary)
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
                    ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary)
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
    // Usar el BlocBuilder para reconstruir la interfaz cuando cambie el estado
    return BlocBuilder<AppStateBloc, AppState>(
      builder: (context, appState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).settings),
          ),
          body: ListView(
            children: [
              // Sección de tema
              ListTile(
                title: Text(S.of(context).themeOptions,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              SwitchListTile(
                title: Text(S.of(context).useSystemTheme),
                subtitle: Text(S.of(context).systemThemeDescription),
                secondary: const Icon(Icons.sync),
                value: appState.useSystemTheme,
                onChanged: _toggleUseSystemTheme,
              ),
              ListTile(
                // Siempre habilitado
                leading: appState.isDarkTheme
                    ? const Icon(Icons.nightlight_round)
                    : const Icon(Icons.wb_sunny),
                title: Text(S.of(context).selectThemeOption),
                subtitle: Text(appState.isDarkTheme
                    ? S.of(context).darkThemeOption
                    : S.of(context).lightThemeOption),
                onTap: () => _showThemeSelector(context, appState.isDarkTheme),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
              const Divider(),

              // Sección de idioma
              ListTile(
                title: Text(S.of(context).languageOptions,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              SwitchListTile(
                title: Text(S.of(context).useSystemLanguage),
                subtitle: Text(S.of(context).systemLanguageDescription),
                secondary: const Icon(Icons.sync_alt),
                value: appState.useSystemLanguage,
                onChanged: _toggleUseSystemLanguage,
              ),
              ListTile(
                // Siempre habilitado
                leading: const Icon(Icons.language),
                title: Text(S.of(context).changeLanguage),
                subtitle: Text(appState.languageCode == 'en'
                    ? S.of(context).languageEnglish
                    : S.of(context).languageSpanish),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(S.of(context).languageEnglish),
                              trailing: appState.languageCode == 'en'
                                  ? Icon(Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary)
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
                                  ? Icon(Icons.check,
                                      color:
                                          Theme.of(context).colorScheme.primary)
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

              // Otras opciones de la app
              ListTile(
                title: Text(S.of(context).otherOptions,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
              ),
              ListTile(
                leading: const Icon(Icons.save),
                title: Text(S.of(context).saveSessionData),
                onTap: () {
                  // Handle session data saving
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: Text(S.of(context).deleteAccount),
                onTap: () async {
                  bool confirm = await showDialog(
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
                  if (confirm) {
                    try {
                      FirebaseServices firebaseServices = FirebaseServices();
                      await firebaseServices.deleteAccount();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              S.of(context).errorDeletingAccount(e.toString())),
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(S.of(context).logout),
                onTap: () async {
                  try {
                    FirebaseServices firebaseServices = FirebaseServices();
                    await firebaseServices.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(S.of(context).errorDuringLogout(e.toString())),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
