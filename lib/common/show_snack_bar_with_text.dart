import 'package:flutter/material.dart';

showSnackBarWithText(BuildContext context, String snackBarText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        snackBarText,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    ),
  );
}
