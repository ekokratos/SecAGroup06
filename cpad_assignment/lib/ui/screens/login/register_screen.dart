import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/services/firebase_service.dart';
import 'package:cpad_assignment/ui/screens/home_screen/home_screen.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/rounded_text_field.dart';
import 'package:cpad_assignment/ui/widgets/solid_rounded_button.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobNoController = TextEditingController();
  TextEditingController _flatNoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _register() async {
    BotToast.showLoading();
    await FirebaseService.signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        appUser: AppUser(
          email: _emailController.text,
          flatNumber: _flatNoController.text,
          mobileNumber: _mobNoController.text,
          name: _nameController.text,
        )).then((value) {
      BotToast.closeAllLoading();
      Get.off(() => HomeScreen());
    }).catchError((e) {
      BotToast.closeAllLoading();
      print('[Error]: $e');
      Utility.showSnackBar(isError: true, message: e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: kVerticalPadding, horizontal: kHorizontalPadding),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Text(
                  "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: kPrimaryColor),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                RoundedTextField(
                  controller: _nameController,
                  hintText: 'Name',
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                RoundedTextField(
                  controller: _mobNoController,
                  hintText: 'Mobile No.',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                RoundedTextField(
                  controller: _flatNoController,
                  hintText: 'Flat No.',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
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
                SizedBox(height: SizeConfig.blockSizeHorizontal * 8),
                Container(
                  width: SizeConfig.screenWidth * 0.8,
                  child: SolidRoundedButton(
                    onPressed: () {
                      _register();
                    },
                    buttonColor: kButtonColor,
                    text: 'SIGN IN',
                  ),
                ),
              ],
            ),
            BackButton(
              color: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
