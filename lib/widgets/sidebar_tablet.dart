import 'package:dister/generated/l10n.dart';
import 'package:dister/models/user_model.dart';
import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/screens/tablet/others/login_tablet_screen.dart';
import 'package:flutter/material.dart';

class SidebarTablet extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  const SidebarTablet({
    super.key,
    required this.selectedIndex,
    this.onTap,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (onTap != null) onTap!(index);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseServices = FirebaseServices();
    final String uid = firebaseServices.getCurrentUser();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: 245,
      color: colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('assets/images/dister.png'),
                  ),
                ),
                _SidebarItem(
                  icon: Icons.home,
                  label: S.of(context).home,
                  selected: selectedIndex == 0,
                  onTap: () => _handleNavigation(context, 0),
                ),
                _SidebarItem(
                  icon: Icons.travel_explore,
                  label: S.of(context).onlinePosts,
                  selected: selectedIndex == 1,
                  onTap: () => _handleNavigation(context, 1),
                ),
                _SidebarItem(
                  icon: Icons.add,
                  label: S.of(context).newPost,
                  selected: selectedIndex == 2,
                  onTap: () => _handleNavigation(context, 2),
                ),
                _SidebarItem(
                  icon: Icons.favorite,
                  label: S.of(context).favorites,
                  selected: selectedIndex == 3,
                  onTap: () => _handleNavigation(context, 3),
                ),
                _SidebarItem(
                  icon: Icons.person,
                  label: S.of(context).profile,
                  selected: selectedIndex == 4,
                  onTap: () => _handleNavigation(context, 4),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: theme.dividerColor, thickness: 1),
                ),
                // Usuario real y logout
                FutureBuilder<Users?>(
                  future: firebaseServices.getCredentialsUser(uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    theme.colorScheme.surfaceVariant),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 12,
                                      width: 60,
                                      color: theme.colorScheme.surfaceVariant),
                                  const SizedBox(height: 4),
                                  Container(
                                      height: 10,
                                      width: 80,
                                      color: theme.colorScheme.surfaceVariant),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final user = snapshot.data!;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: user.photo.isNotEmpty
                                    ? (user.photo.startsWith('http')
                                        ? NetworkImage(user.photo)
                                        : AssetImage(user.photo)
                                            as ImageProvider)
                                    : const AssetImage(
                                        'assets/images/default.png'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('@${user.username}',
                                        style: TextStyle(
                                            color: colorScheme.onSurface
                                                .withOpacity(0.87))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, left: 16, right: 16),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final navigator =
                                  Navigator.of(context, rootNavigator: true);
                              await firebaseServices.signOut();
                              if (!context.mounted) return;
                              navigator.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginTabletScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.logout),
                            label: Text(S.of(context).logout),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              minimumSize: const Size(double.infinity, 40),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: double.infinity,
            color: colorScheme.outline.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color:
          selected ? colorScheme.primary.withOpacity(0.12) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.87)),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.87),
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
