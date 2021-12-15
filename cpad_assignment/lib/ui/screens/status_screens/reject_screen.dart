import 'package:cpad_assignment/ui/styles.dart';
import 'package:flutter/material.dart';

class RejectScreen extends StatelessWidget {
  const RejectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Text(
          'Your application is rejected.',
          style: TextStyle(
            color: Colors.white,
            fontSize: kLargeText,
            fontWeight: kBold,
          ),
        ),
      ),
    );
  }
}
