import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist_app/homescreen/home_screen.dart';
import 'package:movie_watchlist_app/login/login_screen.dart';
import 'package:movie_watchlist_app/utilities/colors.dart';
import 'package:movie_watchlist_app/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices{

  final _auth = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          return snapshot.hasData ?  HomeScreen() :  LoginScreen();
        }
        );
  }


  signUp({String email, String password, BuildContext context}) async{
    try {
      if(email != null && password != null && password.length >= 6){
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password
          );

          if(userCredential != null ){

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userID', userCredential.user.uid);
            prefs.setString('email', userCredential.user.email);

            var userEmail = prefs.getString('email');

            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(isLoggedInAs: userEmail,)));
          }
      }else if(email != null && password != null && password.length < 6){
        ScaffoldMessenger.of(context).showSnackBar( customSnackBarWidget(bgColor: AppColors.red, text: "Password should be above 6 characters"));

      }else{
        ScaffoldMessenger.of(context).showSnackBar( customSnackBarWidget(bgColor: AppColors.red, text: "Check your Credentials"));
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBarWidget(text: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackBarWidget(text: "The account already exists for that email."));
      }
    } catch (e) {
      print(e);
    }
  }

  signIn({String email, String password, BuildContext context}) async{
    try {
      if(email != null && password != null && password.length >= 6){
        try{
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
              email: email,
              password: password
          );
          if(userCredential != null ){

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userID', userCredential.user.uid);
            prefs.setString('email', userCredential.user.email);

            var userId = prefs.getString('userID');

            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

          }
        }catch(e){
         ScaffoldMessenger.of(context).showSnackBar( customSnackBarWidget(bgColor: AppColors.red, text: "An unexpected error occured $e"));
        }
      }else if(email != null && password != null && password.length < 6){
        ScaffoldMessenger.of(context).showSnackBar( customSnackBarWidget(bgColor: AppColors.red, text: "Password should be above 6 characters"));
      }else{
        ScaffoldMessenger.of(context).showSnackBar( customSnackBarWidget(bgColor: AppColors.red, text: "Check your Credentials"));
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackBarWidget(text: "No user found for that email."));

      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackBarWidget(text: "Wrong password provided for that user."));
      }
    }
  }


  signOut({BuildContext context}) async{
    await  _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userID');
    prefs.remove('email');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => LoginScreen()),
            (route) => false);

  }
}

AuthServices authServices = AuthServices();

