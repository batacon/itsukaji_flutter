import 'package:flutter/material.dart';

showSnackBarWithText(final BuildContext context, final String snackBarText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(snackBarText),
    ),
  );
}
