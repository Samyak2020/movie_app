import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  
  
 @override
  void initState() {
    super.initState();
  } 
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Color(0xff0056E0).withOpacity(0.25),
              Color(0xffFC54FF).withOpacity(0.25),
            ],
          ),
        ),
       // color: AppColors.black.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(
                image: Svg(
                    "assets/app_icon.svg",
                    size: Size(
                      MediaQuery.of(context).size.width * 0.4,
                        MediaQuery.of(context).size.height * 0.2,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
              child: SpinKitWave(
                color: AppColors.red,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
