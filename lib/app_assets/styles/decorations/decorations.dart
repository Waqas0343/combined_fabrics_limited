import 'package:flutter/material.dart';

import '../my_colors.dart';

class MyDecorations {
  static BoxDecoration dropdownDecoration = BoxDecoration(
    border: Border.all(width: 1.0, color: Colors.grey),
    borderRadius: const BorderRadius.all(
      Radius.circular(
        4,
      ),
    ),
  );

  static BoxDecoration textFieldRadius = BoxDecoration(
    color: MyColors.fillColor,
    borderRadius: BorderRadius.circular(
      30.0,
    ),
  );
}
