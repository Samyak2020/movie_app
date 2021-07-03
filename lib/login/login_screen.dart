import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/utilities/constants.dart';
import 'package:movie_watchlist_app/widgets/custome_textfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.black,
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: Svg(
                    "assets/app_icon.svg",
                    size: Size(
                      MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.height * 0.15,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.025),
                child: Column(
                  children: [
                    Text("Welcome !",
                      style: theme.textTheme.headline1,
                    ),
                    Text("Sign in to continue",
                      style: theme.textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: Text("Sign In!",
                            style: theme.textTheme.headline2.copyWith(color: AppColors.blue),
                          ),
                          onTap: (){},
                        ),
                        SizedBox(height: screenSize.height * 0.005),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.height * 0.02),
                          height: screenSize.height * 0.006,
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.all(
                                Radius.circular(40)
                            ),
                            border: Border.all(
                              width: 3,
                              color: AppColors.blue,
                              style: BorderStyle.solid,
                            ),),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: Text("Sign Up",
                        style: theme.textTheme.headline2.copyWith(color: AppColors.grey),
                      ),
                      onTap: ()=>Navigator.of(context).pushNamed(ScreenName.SignUpScreen),
                    ),
                  ],
                ),
              SizedBox(height: screenSize.height * 0.015),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width * 0.1, right: screenSize.width * 0.1,bottom: screenSize.height * 0.03),
                  child: CustomTextField(hintText: "Name", icon:  Icons.person_outline),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: CustomTextField(hintText: "Password", icon:  Icons.vpn_key_outlined),
              ),
              SizedBox(height: screenSize.height * 0.045),
              RawMaterialButton(
                onPressed: () => ()=>Navigator.of(context).pushNamed(ScreenName.HomeScreen),
                elevation: 2.0,
                fillColor: AppColors.blue,
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              SizedBox(height: screenSize.height * 0.04),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.height * 0.09),
                    height: screenSize.height * 0.0025,
                    color: AppColors.grey,
                  ),
                  Text("OR",
                    style: theme.textTheme.subtitle1.copyWith(fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.height * 0.09),
                    height: screenSize.height * 0.0025,
                    color: AppColors.grey,
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.04),
              InkWell(
                onTap: () {},
                child: Ink(
                  color: AppColors.secondWhite,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image(
                          image: Svg(
                              "assets/google-icon.svg",
                              size: Size(
                                MediaQuery.of(context).size.width * 0.058,
                                MediaQuery.of(context).size.height * 0.024,
                              )),
                        ), // <-- Use 'Image.asset(...)' here
                        SizedBox(width: 15),
                        Text('Sign in with Google', style: theme.textTheme.subtitle2.copyWith(color: AppColors.black),),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
