import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_watchlist_app/splash/splash_screen.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';
import 'package:movie_watchlist_app/utilities/routes.dart';
import 'package:movie_watchlist_app/utilities/theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme(),
      initialRoute: ScreenName.HomeScreen,
     onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

