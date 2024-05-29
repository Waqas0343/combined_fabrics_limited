import 'package:flutter/services.dart';

class MyTextFormats {
  static TextInputFormatter onlyNumberFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9]"));
  }

  static TextInputFormatter numberWithDot() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
  }

  static TextInputFormatter onlyTextFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"));
  }

  static TextInputFormatter bothFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]"));
  }

  static TextInputFormatter bothFormatWithoutSpace() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"));
  }

  static TextInputFormatter voucherFormat() {
    return FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-]"));
  }

  static bool validateLoginId(String value) {
    String pattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static final phonePattern = RegExp(r"^(92|0)[3][0-5]\d{8}$");
  static final heightPattern = RegExp(r"^[\d]*[.]?([\d]{2}|[\d]{1})$");

  static final  numberAndText = RegExp(r'^[a-zA-Z0-9 ]+$');
  static final  numberAndTextWithDot = RegExp(r'^[a-zA-Z0-9., ]+$');
  static final  validNumber = RegExp(r'^[0-9]+$');
  static final  validCNIC = RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]$');
  static final  validNumberWithDot = RegExp(r'^[0-9.]+$');
  static final  validText = RegExp(r'^[a-zA-Z ]+$');
  static final  validServiceName = RegExp(r'^[a-zA-Z0-9 -]+$');
  static final  validEmail = RegExp(r'^[a-zA-Z0-9.@]+$');

  static bool phoneHasValid(String value) {
    String pattern = r"^(92|0)[3][0-5]\d{8}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
