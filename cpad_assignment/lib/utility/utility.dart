import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utility {
  static showSnackBar(
      {String message = '', String title = '', bool isError = false}) {
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

  static String getTimeStamp(
      {required String unformattedDate, bool showTime = true}) {
    DateTime convertedDateTime = DateTime.parse(unformattedDate);
    DateFormat formatter;
    if (showTime)
      formatter = DateFormat('dd/MM/yyyy').add_jm();
    else
      formatter = DateFormat('dd/MM/yyyy');
    String _date = formatter.format(convertedDateTime);
    return _date;
  }
}
