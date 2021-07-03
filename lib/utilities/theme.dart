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
        color: AppColors.primiaryWhite,
      ),
      headline2: base.headline2.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.secondWhite,
      ),
      subtitle2:base.subtitle2.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.secondWhite,
      ),
      bodyText1:base.bodyText1.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.secondWhite,
      ),
    );
  }
  final ThemeData base = ThemeData(
    //primaryColor: ZiteColors.purple,
      fontFamily: 'Nunito',
      // appBarTheme: AppBarTheme(
      //   color: Colors.transparent,
      //   brightness: Brightness.light,
      //   iconTheme: IconThemeData(
      //     color: AppColors.grey, //change your color here
      //   ),
      // )
  );

  return base.copyWith(
    textTheme: _textTheme(base.textTheme),
  );
}