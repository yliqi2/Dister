import 'package:dister/generated/l10n.dart';
import 'package:dister/models/user_model.dart';
import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:dister/screens/tablet/others/login_tablet_screen.dart';
import 'package:flutter/material.dart';

class SidebarTablet extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const SidebarTablet({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseServices = FirebaseServices();
    final String uid = firebaseServices.getCurrentUser();
    return Container(
      width: 245,
      color: const Color(0xFF232323),
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
            onTap: () => onTap(0),
          ),
          _SidebarItem(
            icon: Icons.travel_explore,
            label: S.of(context).onlinePosts,
            selected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _SidebarItem(
            icon: Icons.add,
            label: S.of(context).newPost,
            selected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _SidebarItem(
            icon: Icons.favorite,
            label: S.of(context).favorites,
            selected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          _SidebarItem(
            icon: Icons.person,
            label: S.of(context).profile,
            selected: selectedIndex == 4,
            onTap: () => onTap(4),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white24, thickness: 1),
          ),
          // Usuario real y logout
          FutureBuilder<Users?>(
            future: firebaseServices.getCredentialsUser(uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      const CircleAvatar(
                          radius: 20, backgroundColor: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 12, width: 60, color: Colors.grey[700]),
                            const SizedBox(height: 4),
                            Container(
                                height: 10, width: 80, color: Colors.grey[800]),
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
                                  : AssetImage(user.photo) as ImageProvider)
                              : const AssetImage('assets/images/default.png'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('@${user.username}',
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final navigator =
                            Navigator.of(context, rootNavigator: true);
                        await firebaseServices.signOut();
                        if (!context.mounted) return;
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginTabletScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(S.of(context).logout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
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
    return Material(
      color: selected ? Colors.red.withAlpha(38) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: selected ? Colors.red : Colors.white),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.red : Colors.white,
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
