import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/user.dart';
import 'package:dister/pages/mobile/auth/login.dart';
import 'package:dister/pages/mobile/profile/user_list_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String? userId; // ID del usuario cuyo perfil se desea visualizar

  const Profile({super.key, this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();

    return FutureBuilder<Users?>(
      future: widget.userId != null
          ? firebaseServices.getCredentialsUser(widget.userId!)
          : firebaseServices
              .getCredentialsUser(firebaseServices.getCurrentUser()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        } else {
          Users user = snapshot.data!;
          bool isCurrentUser = widget.userId == null ||
              widget.userId == firebaseServices.getCurrentUser();

          return FutureBuilder<bool>(
            future: Future.wait([
              firebaseServices.isFollowing(
                firebaseServices.getCurrentUser(),
                user.uid,
              ),
              firebaseServices.hasUnfollowed(
                firebaseServices.getCurrentUser(),
                user.uid,
              ),
            ]).then((results) => results[0] && !results[1]),
            builder: (context, followSnapshot) {
              if (followSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              bool isFollowing = followSnapshot.data ?? false;

              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading:
                      widget.userId != null, // True if accessed via post
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      '@${user.username}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  actions: isCurrentUser
                      ? [
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  FirebaseServices firebaseServices =
                                      FirebaseServices();
                                  await firebaseServices.signOut();
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
                                        content:
                                            Text('Error during logout: $e')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.logout),
                            ),
                          ),
                        ]
                      : null, // No logout button for other users' profiles
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26.0, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.095,
                                child: Image.asset(
                                  user.photo,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(
                                  user.listings,
                                  'Listing',
                                  context,
                                ),
                                const SizedBox(width: 20),
                                _buildStatColumn(
                                    user.followers.length, 'Followers', context,
                                    onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UserListPage(
                                        title: 'Followers',
                                        userIds: user.followers,
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(width: 20),
                                _buildStatColumn(
                                    user.following.length, 'Following', context,
                                    onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UserListPage(
                                        title: 'Following',
                                        userIds: user.following,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: user.desc != null &&
                                                user.desc!.isNotEmpty
                                            ? (_isExpanded
                                                ? user.desc!
                                                : user.desc!.length > 50
                                                    ? '${user.desc!.substring(0, 50)}...'
                                                    : user.desc!)
                                            : 'No se ha añadido ninguna descripción.',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (user.desc != null &&
                                          user.desc!.isNotEmpty &&
                                          user.desc!.length > 50)
                                        TextSpan(
                                          text: _isExpanded
                                              ? ' Read Less'
                                              : ' Read More',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                _isExpanded = !_isExpanded;
                                              });
                                            },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: isCurrentUser
                                ? [_buildButton('Edit Profile', context)]
                                : [
                                    GestureDetector(
                                      onTap: () async {
                                        if (isFollowing) {
                                          await firebaseServices.unfollowUser(
                                            firebaseServices.getCurrentUser(),
                                            user.uid,
                                          );
                                        } else {
                                          bool hasUnfollowed =
                                              await firebaseServices
                                                  .hasUnfollowed(
                                            firebaseServices.getCurrentUser(),
                                            user.uid,
                                          );

                                          if (!hasUnfollowed) {
                                            await firebaseServices.followUser(
                                              firebaseServices.getCurrentUser(),
                                              user.uid,
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'No puedes volver a seguir a este usuario.'),
                                              ),
                                            );
                                          }
                                        }
                                        setState(() {});
                                      },
                                      child: _buildButton(
                                        isFollowing ? 'Unfollow' : 'Follow',
                                        context,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    _buildButton('Send Message', context),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildStatColumn(int count, String label, BuildContext context,
      {VoidCallback? onTap}) {
    TextStyle style = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.w800,
    );
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(count.toString(), style: style),
          Text(label, style: style),
        ],
      ),
    );
  }

  Widget _buildButton(String text, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
