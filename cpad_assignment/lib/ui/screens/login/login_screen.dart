import 'package:cpad_assignment/services/firebase_service.dart';
import 'package:cpad_assignment/ui/screens/home_screen/home_screen.dart';
import 'package:cpad_assignment/ui/screens/login/register_screen.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/rounded_text_field.dart';
import 'package:cpad_assignment/ui/widgets/solid_rounded_button.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _login() async {
    BotToast.showLoading();
    await FirebaseService.logInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((_) {
      BotToast.closeAllLoading();
      Get.off(() => HomeScreen());
      print('Logged in');
    }).catchError((e) {
      BotToast.closeAllLoading();
      print('[Error]: $e');
      Utility.showSnackBar(isError: true, message: e.message);
    });
  }

  _resetPassword() async {
    if (_emailController.text.isEmpty) {
      Utility.showSnackBar(
          title: 'Email required', message: 'Please enter an email.');
    } else {
      BotToast.showLoading();

      await FirebaseService.resetPassword(email: _emailController.text)
          .then((_) {
        BotToast.closeAllLoading();
        Utility.showSnackBar(
            isError: false,
            title: 'Password Reset',
            message: 'Password reset link sent to the registered email.');
      }).catchError((e) {
        BotToast.closeAllLoading();
        print('[Error]: $e');
        Utility.showSnackBar(isError: true, message: e.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: kVerticalPadding, horizontal: kHorizontalPadding),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            Text(
              "Sign In to continue",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.05),
            RoundedTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
            RoundedTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _resetPassword();
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: kPrimaryColor, fontSize: kNormalText),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 8),
            Container(
              width: SizeConfig.screenWidth * 0.8,
              child: SolidRoundedButton(
                onPressed: () {
                  _login();
                },
                buttonColor: kButtonColor,
                text: 'SIGN IN',
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Get.to(() => RegisterScreen());
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Text('Or',
                style: TextStyle(color: kPrimaryColor, fontSize: kMediumText)),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
            Container(
              width: SizeConfig.screenWidth * 0.8,
              child: RawMaterialButton(
                visualDensity: VisualDensity.standard,
                fillColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 1.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 2,
                onPressed: () async {
                  BotToast.showLoading();
                  await FirebaseService.signInWithGoogle().then((_) {
                    BotToast.closeAllLoading();
                    Get.off(() => HomeScreen());
                  }).catchError((e) {
                    BotToast.closeAllLoading();
                    print('[Error]: $e');
                    Utility.showSnackBar(isError: true, message: e.message);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 25.0,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: kMediumText,
                        color: kPrimaryColor,
                        fontWeight: kBold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
