import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String? value, {ToastGravity? gravity, length = Toast.LENGTH_SHORT, Color? bgColor, Color? textColor, bool print = false}) {
  if (value!.isEmpty || (!kIsWeb && Platform.isLinux)) {
    log(value);
  } else {
    Fluttertoast.showToast(
      msg: value.toString(),
      gravity: gravity,
      toastLength: length,
      backgroundColor: bgColor,
      textColor: textColor,
      timeInSecForIosWeb: 2,
    );
    if (print) log(value);
  }
}
