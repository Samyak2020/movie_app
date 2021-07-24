import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';

ThemeData appTheme(){
  TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: AppColors.primiaryWhite,
      ),
      subtitle1:base.subtitle1.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.secondWhite,
      ),
      headline2: base.headline2.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.secondWhite,
      ),
      subtitle2:base.subtitle2.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.grey,
      ),
      bodyText1:base.bodyText1.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),
    );
  }
  final ThemeData base = ThemeData(
      fontFamily: 'Nunito',
      appBarTheme: AppBarTheme(
        color: AppColors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: AppColors.white, //change your color here
        ),
      ),
  );

  return base.copyWith(
    textTheme: _textTheme(base.textTheme),
  );
}