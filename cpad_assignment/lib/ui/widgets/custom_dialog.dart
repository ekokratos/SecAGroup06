import 'dart:io';

import 'package:cpad_assignment/ui/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomDialog({
  required BuildContext context,
  String? title,
  String? description,
  String? leftButtonText,
  String? rightButtonText,
  VoidCallback? onRightButton,
  Color? leftButtonColor,
  Color? rightButtonColor,
  bool showOneButton = false,
}) {
  return showDialog(
    context: context,
    builder: (context) => CustomDialog(
      title: title,
      onRightButton: onRightButton,
      description: description,
      leftButtonText: leftButtonText,
      rightButtonText: rightButtonText,
      leftButtonColor: leftButtonColor,
      rightButtonColor: rightButtonColor,
      showOneButton: showOneButton,
    ),
  );
}

class CustomDialog extends StatelessWidget {
  // final EdgeInsetsGeometry padding;
  final String? title;
  final String? description;
  final String? rightButtonText;
  final String? leftButtonText;
  final VoidCallback? onRightButton;
  final Color? leftButtonColor;
  final Color? rightButtonColor;
  final bool showOneButton;

  const CustomDialog(
      {
      // this.padding,
      this.title,
      required this.onRightButton,
      this.rightButtonText,
      this.leftButtonText,
      this.description,
      this.leftButtonColor,
      this.rightButtonColor,
      this.showOneButton = false});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? AlertDialog(
            title: Text(title ?? ''),
            content: Text(description ?? ''),
            actions: [
              if (!showOneButton)
                OutlinedButton(
                  child: Text(
                    leftButtonText ?? "Cancel",
                    style: TextStyle(
                      color: leftButtonColor ?? Colors.green,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(color: leftButtonColor ?? kSuccessGreen),
                    ),
                  ),
                ),
              OutlinedButton(
                child: Text(
                  rightButtonText ?? "Yes",
                  style: TextStyle(
                    color: rightButtonColor ?? Colors.red,
                  ),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(color: rightButtonColor ?? kErrorRed),
                  ),
                ),
                onPressed: onRightButton,
              )
            ],
          )
        : CupertinoAlertDialog(
            title: Text(title ?? ''),
            content: Text(description ?? ''),
            actions: [
              if (!showOneButton)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      leftButtonText ?? "Cancel",
                      style: TextStyle(
                        color: leftButtonColor ?? Colors.green,
                      ),
                    )),
              TextButton(
                onPressed: onRightButton,
                child: Text(
                  rightButtonText ?? "Yes",
                  style: TextStyle(
                    color: rightButtonColor ?? Colors.redAccent,
                  ),
                ),
              ),
            ],
          );
  }
}
