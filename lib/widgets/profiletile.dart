import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dister/model/user.dart';

class UserProfileWidget extends StatefulWidget {
  final Users user;
  const UserProfileWidget({super.key, required this.user});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle profile = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.w800,
    );

    double width = MediaQuery.of(context).size.width;
    String description = widget.user.desc!.isEmpty
        ? 'No description added...'
        : widget.user.desc!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
      child: Column(
        children: [
          Row(
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
                    widget.user.photo,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(widget.user.listings, 'Listing', profile),
                  const SizedBox(width: 20),
                  _buildStatColumn(widget.user.followers, 'Followers', profile),
                  const SizedBox(width: 20),
                  _buildStatColumn(widget.user.following, 'Following', profile),
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
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        if (description.length > 50)
                          TextSpan(
                            text: _isExpanded ? ' Read Less' : ' Read More',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
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
              children: [
                _buildButton('Edit Profile', context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(int count, String label, TextStyle style) {
    return Column(
      children: [
        Text(count.toString(), style: style),
        Text(label, style: style),
      ],
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
