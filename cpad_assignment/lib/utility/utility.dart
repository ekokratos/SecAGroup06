import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utility {
  static showSnackBar(
      {String message = '', String title = '', bool isError = true}) {
    Get.snackbar(
      isError ? 'Error' : title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(15),
      icon: isError
          ? Icon(
              Icons.error_outline,
              color: Colors.red,
            )
          : Icon(
              Icons.info_outline,
              color: Colors.green,
            ),
    );
  }

  static showToast(String message) {
    BotToast.showText(
      text: message,
      duration: Duration(milliseconds: 3000),
      crossPage: true,
      textStyle: TextStyle(color: Colors.white),
    );
  }
}
