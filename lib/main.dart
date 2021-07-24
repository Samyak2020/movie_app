import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_watchlist_app/data/repo/authservices/auth_servies.dart';
import 'package:movie_watchlist_app/utilities/connectivity.dart';
import 'package:movie_watchlist_app/utilities/routes.dart';
import 'package:movie_watchlist_app/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{

  Future.delayed(Duration(milliseconds: 1)).then(
          (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
         //statusBarIconBrightness: Brightness.light,
      )));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userID');
  prefs.getString('email');
  prefs.getInt('uId');

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
      home: authServices.handleAuth(),
     onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

