import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';

class SolidRoundedButton extends StatelessWidget {
  const SolidRoundedButton({
    required this.buttonColor,
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.visualDensity,
  });

  final Color buttonColor;
  final VoidCallback? onPressed;
  final String text;
  final double? fontSize;
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      visualDensity: visualDensity ?? VisualDensity.standard,
      fillColor: buttonColor,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 1.6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: 0,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? kMediumText,
          color: Colors.white,
          fontWeight: kBold,
        ),
      ),
    );
  }
}
