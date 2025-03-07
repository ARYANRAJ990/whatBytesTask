import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

import '../Resources/colors.dart';
class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void flushBarSuccessMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        messageColor: Appcolors.white,
        borderRadius: BorderRadius.circular(8),
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Appcolors.green,
        flushbarPosition: FlushbarPosition.TOP,
        message: message,
        duration: const Duration(seconds: 5),
      )..show(context),
    );
  }
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        messageColor: Appcolors.white,
        borderRadius: BorderRadius.circular(8),
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Appcolors.darkred_red,
        flushbarPosition: FlushbarPosition.TOP,
        message: message,
        duration: const Duration(seconds: 5),
      )..show(context),
    );
  }

  static snackBar(String message, BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Appcolors.lightblue,
            content: Text(message))
    );
  }
}