import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/login/login_screen.dart';
import 'package:movie_watchlist_app/signup/signup_screen.dart';
import 'package:movie_watchlist_app/splash/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'constants.dart';


class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args =  settings.arguments;


    switch (settings.name){
      case ScreenName.SplashScreen:
        return MaterialPageRoute(builder: (_)=> SplashScreen());

      case ScreenName.LoginScreen:
 //       if(args is String){}
        //return MaterialPageRoute(builder: (_)=> LoginScreen()
           return  PageTransition(
            child: LoginScreen(),
    type: PageTransitionType.leftToRightWithFade,
    settings: settings,
    );
     //   );

      case ScreenName.SignUpScreen:
        return  PageTransition(
          child: SignupScreen(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 250),
          settings: settings,
        );

      case ScreenName.HomeScreen:
        return  PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 250),
          settings: settings,
        );

      case ScreenName.WatchlistScreen:
        return MaterialPageRoute(builder: (_)=> SplashScreen());

      case ScreenName.SearchScreen:
        return MaterialPageRoute(builder: (_)=> SplashScreen());

    }
  }
}