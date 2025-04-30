import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/screens/tablet/profile/edit_profile_tablet_screen.dart';
import 'package:dister/screens/tablet/profile/followers_tablet_screen.dart';
import 'package:dister/screens/tablet/posts/post_tablet_screen.dart';
import 'package:dister/widgets/post_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/models/post_model.dart';
import 'package:dister/screens/tablet/others/settings_tablet_screen.dart';

class ProfileTabletScreen extends StatefulWidget {
  final String? userId;
  const ProfileTabletScreen({super.key, this.userId});

  @override
  State<ProfileTabletScreen> createState() => _ProfileTabletScreenState();
}

class _ProfileTabletScreenState extends State<ProfileTabletScreen> {
  final FirebaseServices firebaseServices = FirebaseServices();
  bool _isExpanded = false;

  Future<List<Post>> _getUserListings(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .where('owner', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al cargar las publicaciones: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId ?? firebaseServices.getCurrentUser())
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text(S.of(context).error(snapshot.error.toString())));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text(S.of(context).userNotFound));
        } else {
          final user = snapshot.data!;
          final isCurrentUser = user.id == firebaseServices.getCurrentUser();
          final username = user['username'] ?? '';
          final desc = user['desc'] ?? '';
          final photo = user['photo'] ?? '';
          final followers = List<String>.from(user['followers'] ?? []);
          final following = List<String>.from(user['following'] ?? []);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                '@$username',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
              actions: isCurrentUser
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SettingsTabletScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.more_horiz_outlined),
                        ),
                      ),
                    ]
                  : null,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<List<Post>>(
                    future: _getUserListings(user.id),
                    builder: (context, snapshot) {
                      int postCount = 0;
                      if (snapshot.hasData) {
                        postCount = snapshot.data!.length;
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onPrimary,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: photo.startsWith('http')
                                  ? NetworkImage(photo)
                                  : AssetImage(photo) as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildStatColumn(
                                  postCount,
                                  S.of(context).listings,
                                  context,
                                ),
                                const SizedBox(width: 32),
                                _buildStatColumn(
                                  followers.length,
                                  S.of(context).followers,
                                  context,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FollowersTabletScreen(
                                          title: S.of(context).followers,
                                          userIds: followers,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 32),
                                _buildStatColumn(
                                  following.length,
                                  S.of(context).following,
                                  context,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FollowersTabletScreen(
                                          title: S.of(context).following,
                                          userIds: following,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          SizedBox(
                            width: 200,
                            child: isCurrentUser
                                ? GestureDetector(
                                    onTap: () async {
                                      final result =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileTabletScreen(
                                                  userId: user.id),
                                        ),
                                      );
                                      if (result == true) {
                                        setState(() {});
                                      }
                                    },
                                    child: _buildButton(
                                        S.of(context).editProfile, context),
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (followers.contains(
                                                firebaseServices
                                                    .getCurrentUser())) {
                                              await firebaseServices
                                                  .unfollowUser(
                                                      firebaseServices
                                                          .getCurrentUser(),
                                                      user.id);
                                            } else {
                                              await firebaseServices.followUser(
                                                  firebaseServices
                                                      .getCurrentUser(),
                                                  user.id);
                                            }
                                            setState(() {});
                                          },
                                          child: _buildButton(
                                            followers.contains(firebaseServices
                                                    .getCurrentUser())
                                                ? S.of(context).unfollow
                                                : S.of(context).follow,
                                            context,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: followers.contains(
                                                  firebaseServices
                                                      .getCurrentUser())
                                              ? () {
                                                  // Aquí puedes abrir el chat si lo tienes en tablet
                                                }
                                              : null,
                                          child: _buildButton(
                                            S.of(context).sendMessage,
                                            context,
                                            isDisabled: !followers.contains(
                                                firebaseServices
                                                    .getCurrentUser()),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: desc.isNotEmpty
                                      ? (_isExpanded
                                          ? desc
                                          : desc.length > 50
                                              ? '${desc.substring(0, 50)}...'
                                              : desc)
                                      : S.of(context).noDescription,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                if (desc.isNotEmpty && desc.length > 50)
                                  TextSpan(
                                    text: _isExpanded
                                        ? S.of(context).readLess
                                        : S.of(context).readMore,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                  Expanded(
                    child: FutureBuilder<List<Post>>(
                      future: _getUserListings(user.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(S
                                  .of(context)
                                  .errorGeneric(snapshot.error.toString())));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              border: Border(
                                top: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withAlpha(100),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logoopacidad.png',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 20),
                                isCurrentUser
                                    ? Text(
                                        S.of(context).shareYourListings,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : Text(
                                        S.of(context).noListingsToShow,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        } else {
                          final posts = snapshot.data!;
                          return GridView.builder(
                            padding: const EdgeInsets.only(top: 16),
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return PostContainer(
                                listing: posts[index],
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PostTabletScreen(
                                          listing: posts[index]),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildStatColumn(int? count, String label, BuildContext context,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count?.toString() ?? '-',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, BuildContext context,
      {bool isDisabled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDisabled
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDisabled
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
