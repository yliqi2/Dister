import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/screens/tablet/profile/profile_tablet_screen.dart';
import 'package:dister/widgets/sidebar_tablet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersTabletScreen extends StatefulWidget {
  final String title;
  final List<String> userIds;
  const FollowersTabletScreen({
    super.key,
    required this.title,
    required this.userIds,
  });

  @override
  State<FollowersTabletScreen> createState() => _FollowersTabletScreenState();
}

class _FollowersTabletScreenState extends State<FollowersTabletScreen> {
  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Row(
          children: [
            SidebarTablet(
              selectedIndex: 0,
              onTap: (index) {},
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.userIds.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userIds[index])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(
                                leading: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return ListTile(
                                title: Text(S
                                    .of(context)
                                    .errorGeneric(snapshot.error.toString())),
                              );
                            } else if (!snapshot.hasData ||
                                !snapshot.data!.exists) {
                              return ListTile(
                                title: Text(S.of(context).noUserData),
                              );
                            } else {
                              final user = snapshot.data!;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user['photo']),
                                ),
                                title: Text('@${user['username']}'),
                                subtitle: Text(user['desc']),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileTabletScreen(userId: user.id),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
