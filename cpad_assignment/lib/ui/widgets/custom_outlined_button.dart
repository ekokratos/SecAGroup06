import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final Color outlineColor;
  final VoidCallback? onPressed;
  final String text;

  const CustomOutlineButton(
      {Key? key,
      this.outlineColor = kPrimaryColor,
      this.onPressed,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((states) => Colors.white),
        side: MaterialStateProperty.resolveWith(
            (states) => BorderSide(color: outlineColor, width: 1)),
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 8,
            vertical: SizeConfig.blockSizeVertical * 1.6,
          ),
        ),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: kMediumText,
            color: kPrimaryColor,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
