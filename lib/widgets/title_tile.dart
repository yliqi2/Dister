import 'package:flutter/material.dart';

class TitleTile extends StatefulWidget {
  final String text;

  const TitleTile({super.key, required this.text});

  @override
  State<TitleTile> createState() => _TitleTileState();
}

class _TitleTileState extends State<TitleTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
    );
  }
}
