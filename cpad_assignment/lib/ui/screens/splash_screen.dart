import 'dart:async';

import 'package:cpad_assignment/ui/screens/home_screen/home_screen.dart';
import 'package:cpad_assignment/ui/screens/login/login_screen.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _checkLogIn() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null)
        Get.off(() => HomeScreen());
      else
        Get.off(() => LoginScreen());
    } catch (e) {
      print('[Error]: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogIn();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: kVerticalPadding, horizontal: kHorizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.blockSizeHorizontal * 10),
            Text(
              "Loading",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeHorizontal * 5.5,
                  letterSpacing: 0.5),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
            SpinKitFadingCircle(
              color: Colors.white,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
