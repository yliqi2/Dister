import 'package:dister/controller/firebase/services/firebase_services.dart';
import 'package:dister/model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isExpanded = false; // Controla si se muestra todo el texto o no.

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();

    TextStyle profile = TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w800,
    );

    double width = MediaQuery.of(context).size.width;

    return FutureBuilder<Users?>(
      future: firebaseServices.getCredentialsUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        } else {
          String description = '';
          Users user = snapshot.data!;
          if (user.desc! == '') {
            description = 'No description added...';
          } else {
            description = user.desc!;
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '@${user.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      // Imagen y estadísticas
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: width * 0.095,
                            child: Image.asset(
                              user.photo,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  user.listings.toString(),
                                  style: profile,
                                ),
                                Text(
                                  'Listing',
                                  style: profile,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                  user.followers.toString(),
                                  style: profile,
                                ),
                                Text(
                                  'Followers',
                                  style: profile,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                  user.following.toString(),
                                  style: profile,
                                ),
                                Text(
                                  'Following',
                                  style: profile,
                                ),
                              ],
                            ),
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
                                    text: _isExpanded
                                        ? description
                                        : description.length > 50
                                            ? '${description.substring(0, 50)}...'
                                            : description,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (description.length > 50)
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
                                          setState(
                                            () {
                                              _isExpanded = !_isExpanded;
                                            },
                                          );
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
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              child: Center(child: Text('Change Plan')),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )),
                              child: Center(child: Text('Edit Profile')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
