import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/ui/screens/profile_screen/profile_screen.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.appUser,
  }) : super(key: key);

  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProfileScreen(user: appUser));
      },
      child: Card(
        color: kButtonColor,
        child: ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
            size: 40,
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appUser.name ?? '-',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: kMediumText,
                      fontWeight: kBold),
                ),
                Text(
                  appUser.email ?? '-',
                  style: TextStyle(color: Colors.white, fontSize: kNormalText),
                ),
                Text(
                  appUser.mobileNumber ?? '-',
                  style: TextStyle(color: Colors.white, fontSize: kNormalText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
