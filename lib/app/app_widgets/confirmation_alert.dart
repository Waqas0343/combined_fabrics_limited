import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationAlert{

  static showDialog({
    required String title,
    required String description,
    VoidCallback? onConfirm,
    bool? barrierDismissible,
  }) =>
      Get.defaultDialog(
        title: title,
        middleText: description,
        onConfirm: onConfirm,
        textConfirm: "Yes",
        textCancel: "No",
        barrierDismissible: barrierDismissible??true,
      );
}