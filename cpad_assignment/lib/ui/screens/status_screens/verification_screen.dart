import 'package:cpad_assignment/services/user_service.dart';
import 'package:cpad_assignment/ui/screens/home_screen/home_screen.dart';
import 'package:cpad_assignment/ui/screens/status_screens/reject_screen.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Future _fetchUser;

  Future<void> _fetchUserData() async {
    _fetchUser = UserService.getUser();
    _fetchUser.then((user) {
      if (user.isRejected)
        Get.off(() => RejectScreen());
      else if (user.isVerified) Get.off(() => HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _fetchUserData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.06,
                  width: double.infinity,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.grey.shade400,
                    ),
                    Text(
                      'Pull down to refresh.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: kNormalText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.3),
                Icon(
                  Icons.pending_actions,
                  size: 70,
                  color: kPrimaryColor,
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
                Text(
                  'Your application is being processed.\nPlease wait.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: kLargeText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
