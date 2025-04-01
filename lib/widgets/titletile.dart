import 'package:flutter/material.dart';

class Titletile extends StatefulWidget {
  final String text;

  const Titletile({super.key, required this.text});

  @override
  State<Titletile> createState() => _TitletileState();
}

class _TitletileState extends State<Titletile> {
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
