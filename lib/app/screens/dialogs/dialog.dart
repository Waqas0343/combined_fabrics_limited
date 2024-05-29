import 'package:flutter/material.dart';
import '../../../app_assets/custom_fonts.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 16,
          ),
          Text(
            "Please Wait...",
            style: TextStyle(
              fontSize: 14,
              fontFamily: CustomFonts.roboto,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
