import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';

Widget customSnackBarWidget({String text, Color bgColor}){
  final snackBar = SnackBar(
    backgroundColor: bgColor ?? AppColors.black,
    duration: Duration(seconds: 2),
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