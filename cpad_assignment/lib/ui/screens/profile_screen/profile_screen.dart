import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/rounded_text_field.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final AppUser user;

  const ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobNoController;
  late TextEditingController _flatNoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _mobNoController =
        TextEditingController(text: widget.user.mobileNumber ?? '');
    _flatNoController =
        TextEditingController(text: widget.user.flatNumber ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(
            fontSize: kLargeText, fontWeight: kBold, color: Colors.white),
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: kVerticalPadding, horizontal: kHorizontalPadding),
        child: Column(
          children: [
            TextFieldWithLabel(
              controller: _nameController,
              label: 'Name',
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
            TextFieldWithLabel(
              controller: _emailController,
              label: 'Email',
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
            TextFieldWithLabel(
              controller: _mobNoController,
              label: 'Mobile No.',
            ),
            SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
            if (!AppData.isAdmin())
              TextFieldWithLabel(
                controller: _flatNoController,
                label: 'Flat No.',
              ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  TextFieldWithLabel({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
            child: Text(
              label,
              style: TextStyle(color: kPrimaryColor, fontSize: kMediumText),
            ),
          ),
        ),
        SizedBox(height: 3),
        RoundedTextField(
          controller: controller,
          isReadOnly: true,
        ),
      ],
    );
  }
}
