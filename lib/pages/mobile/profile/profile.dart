import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/listing.dart';
import 'package:dister/model/user.dart';
import 'package:dister/pages/mobile/listingdetail/listingdetails.dart';
import 'package:dister/pages/mobile/profile/settings_page.dart';
import 'package:dister/pages/mobile/profile/user_list_page.dart';
import 'package:dister/widgets/listingtile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dister/generated/l10n.dart';
import 'package:dister/pages/mobile/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/pages/mobile/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  final String? userId; // ID del usuario cuyo perfil se desea visualizar

  const Profile({super.key, this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isExpanded = false;
  File? _selectedImage;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      try {
        FirebaseServices firebaseServices = FirebaseServices();
        String downloadUrl = await firebaseServices.uploadProfilePicture(
          firebaseServices.getCurrentUser(),
          _selectedImage!,
        );

        await firebaseServices.updateUserPhoto(
            firebaseServices.getCurrentUser(), downloadUrl);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).profileUpdated)),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(S.of(context).errorUploadingImage(e.toString()))),
        );
      }
    }
  }

  Future<List<Listing>> _getUserListings(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('listings')
          .where('owner', isEqualTo: userId) // Filtra por el campo 'owner'
          .get();

      // Convierte los documentos en objetos del modelo Listing
      return querySnapshot.docs
          .map((doc) => Listing.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar las publicaciones: $e');
    }
  }

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
          return Center(
              child:
                  Text(S.of(context).errorGeneric(snapshot.error.toString())));
        } else if (!snapshot.hasData) {
          return Center(child: Text(S.of(context).noUserData));
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
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                    maintainState: true,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.more_horiz_outlined),
                            ),
                          ),
                        ]
                      : null, // No logout button for other users' profiles
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      width: 2,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: isCurrentUser
                                        ? _pickAndUploadImage
                                        : null,
                                    child: CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.095,
                                      backgroundImage: _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                          : (user.photo.startsWith('assets/')
                                                  ? AssetImage(user.photo)
                                                  : NetworkImage(user.photo))
                                              as ImageProvider,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStatColumn(
                                        user.listings,
                                        S.of(context).listings,
                                        context,
                                      ),
                                      const SizedBox(width: 10),
                                      _buildStatColumn(
                                          user.followers.length,
                                          S.of(context).followers,
                                          context, onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => UserListPage(
                                              title: S.of(context).followers,
                                              userIds: user.followers,
                                            ),
                                          ),
                                        );
                                      }),
                                      const SizedBox(width: 10),
                                      _buildStatColumn(
                                          user.following.length,
                                          S.of(context).following,
                                          context, onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => UserListPage(
                                              title: S.of(context).following,
                                              userIds: user.following,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
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
                                                : S.of(context).noDescription,
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
                                                  ? S.of(context).readLess
                                                  : S.of(context).readMore,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: isCurrentUser
                                    ? [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              final result =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfilePage(
                                                          userId: user.uid),
                                                ),
                                              );
                                              if (result == true) {
                                                setState(
                                                    () {}); // Fuerza la actualización de la pantalla
                                              }
                                            },
                                            child: _buildButton(
                                                S.of(context).editProfile,
                                                context),
                                          ),
                                        )
                                      ]
                                    : [
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (isFollowing) {
                                                await firebaseServices
                                                    .unfollowUser(
                                                  firebaseServices
                                                      .getCurrentUser(),
                                                  user.uid,
                                                );
                                              } else {
                                                bool hasUnfollowed =
                                                    await firebaseServices
                                                        .hasUnfollowed(
                                                  firebaseServices
                                                      .getCurrentUser(),
                                                  user.uid,
                                                );

                                                if (!hasUnfollowed) {
                                                  await firebaseServices
                                                      .followUser(
                                                    firebaseServices
                                                        .getCurrentUser(),
                                                    user.uid,
                                                  );
                                                } else {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(S
                                                            .of(context)
                                                            .cannotFollowAgain),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                              setState(() {});
                                            },
                                            child: _buildButton(
                                              isFollowing
                                                  ? S.of(context).unfollow
                                                  : S.of(context).follow,
                                              context,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: isFollowing
                                                ? () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                          recipientId: user.uid,
                                                          recipientName:
                                                              user.username,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                : null,
                                            child: _buildButton(
                                              S.of(context).sendMessage,
                                              context,
                                              isDisabled: !isFollowing,
                                            ),
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Listing>>(
                          future: _getUserListings(user
                              .uid), // Llama a la función para obtener los posts
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(S
                                    .of(context)
                                    .error(snapshot.error.toString())),
                              );
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
                                          .withAlpha(100), // Color del borde
                                      width: 1.0, // Ancho del borde
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
                              final userListings = snapshot.data!;
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer
                                      .withAlpha(120),
                                  border: Border(
                                    top: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withAlpha(100), // Color del borde
                                      width: 1.0, // Ancho del borde
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/logoopacidad.png',
                                            width: 150,
                                            height: 150,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GridView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            2, // Muestra dos elementos por fila
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.72,
                                      ),
                                      itemCount: userListings.length,
                                      itemBuilder: (context, index) {
                                        final listing = userListings[index];
                                        return Listingtile(
                                          colorChange: true,
                                          listing: listing,
                                          onTap: () {
                                            // Navegar a la página de detalles de la publicación
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Listingdetails(
                                                  listing: listing,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, BuildContext context,
      {bool isDisabled = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDisabled
              ? Theme.of(context).colorScheme.secondary.withAlpha(77)
              : Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isDisabled
                ? Theme.of(context).colorScheme.secondary.withAlpha(77)
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
