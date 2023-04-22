import 'package:flutter/material.dart';

showSnackBarWithText(final BuildContext context, final String snackBarText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      duration: const Duration(milliseconds: 1500),
      content: Text(snackBarText),
    ),
  );
}
