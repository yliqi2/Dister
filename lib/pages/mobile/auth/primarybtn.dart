import 'package:flutter/material.dart';

Container primaryBtn({required BuildContext context, required String text}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12.5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).colorScheme.primary,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ),
  );
}
