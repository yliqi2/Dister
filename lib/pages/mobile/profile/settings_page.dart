import 'package:flutter/material.dart';
import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/generated/l10n.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _changeLanguage(BuildContext context, Locale locale) {
    S.load(locale); // Load the selected locale
    Navigator.pop(context); // Close the dialog
    (context as Element).markNeedsBuild(); // Rebuild the widget tree
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(S.of(context).darkTheme),
            secondary: const Icon(Icons.dark_mode),
            value: true,
            onChanged: (bool value) {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(S.of(context).changeLanguage),
            onTap: () {
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
                          S.of(context).selectLanguage,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('English'),
                          onTap: () {
                            _changeLanguage(context, const Locale('en'));
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Español'),
                          onTap: () {
                            _changeLanguage(context, const Locale('es'));
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
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
                      MaterialPageRoute(builder: (context) => const Login()),
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
        ],
      ),
    );
  }
}
