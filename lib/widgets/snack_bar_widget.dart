import 'package:flutter/material.dart';

Widget customSnackBarWidget({String text}){
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: "",
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  return snackBar;
}