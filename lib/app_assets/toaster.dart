import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToaster {
  static void warning(String message) => Get.rawSnackbar(
    title: "Alert",
    message: message,
    backgroundColor: Colors.amberAccent,
  );

  static void info(String message) => Get.rawSnackbar(
    title: "Info",
    message: message,
  );

  static void error(String message) => Get.rawSnackbar(
    title: "Error",
    message: message,
    backgroundColor: Colors.redAccent,
  );
}