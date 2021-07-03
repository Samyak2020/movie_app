import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';

class CustomTextField extends StatelessWidget {

  CustomTextField({this.hintText, this.controller, this.icon});

  final String hintText;
  final IconData icon;
  final TextEditingController controller;


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      style: theme.textTheme.subtitle2,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon ?? Icons.person_outline, color: AppColors.secondWhite,
          size: 22,),
        hintText: hintText ?? 'Hint',
        hintStyle: theme.textTheme.subtitle2,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondWhite),
        ),
      ),
    );
  }
}
