import 'package:flutter/services.dart';

class TextInputFormatterHelper {
  static TextInputFormatter onlyNumberFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9]"));
  }

  static bool weightHasValid(String value) {
    String pattern = r"^[\d]*[.]?([\d]{2}|[\d]{1})$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool heightHasValid(String value) {
    String pattern = r"^[\d]*[.]?([\d]{2}|[\d]{1})$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool numberHasValid(String value) {
    String pattern = r"^((?:00|)92)?(0?3(?:[0-46]\d|55)\d{7})$";
    // String pattern = r"^[0][3][0-5]\d{8}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool numberValidation(String value) {
    String pattern = r"^((?:00|)92)?(0?3(?:[0-46]\d|55)\d{7})$";
    // String pattern = r"^[0][3][0-5]\d{8}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static TextInputFormatter onlyTextFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"));
  }

  static TextInputFormatter bothFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]"));
  }

  static TextInputFormatter bothFormatWithCharacter() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9,. ]"));
  }

  static TextInputFormatter textFormatWithCharacter() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z, ]"));
  }

  static String dateFormat = "MM/dd/yyyy";

  static TextInputFormatter numberWithDot() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
  }

  static final numberAndText = RegExp(r'^[a-zA-Z0-9 ]+$');
  static final phonePattern = RegExp(r"^(92|0)[3][0-5]\d{8}$");
  static final numberAndTextWithDot = RegExp(r'^[a-zA-Z0-9., ]+$');
  static final validNumber = RegExp(r'^[0-9]+$');
  static final validCNIC = RegExp(r'^[0-9-]+$');
  static final validNumberWithDot = RegExp(r'^[0-9.]+$');
  static final validText = RegExp(r'^[a-zA-Z ]+$');
  static final validServiceName = RegExp(r'^[a-zA-Z0-9 -]+$');
  static final validEmail = RegExp(r'^[a-zA-Z0-9.@]+$');
  static final validTextWithDot = RegExp(r'^[a-zA-Z. ]+$');
  static final validPassword = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  static final mixedPattern = RegExp(r'^[a-zA-Z0-9\s.,\-_!@#$%^&*()+=<>?]+$');


  static bool phoneHasValid(String value) {
    String pattern = r"^(92|0)[3][0-5]\d{8}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
