import 'package:flutter/material.dart';
import '../../../../app_assets/styles/my_colors.dart';

class CustomLeadingIcon extends StatelessWidget {
  final String title;
  final Color? color;

  const CustomLeadingIcon({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double avatarSize = constraints.maxWidth * 0.12;
        return SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: CircleAvatar(
            backgroundColor: color ?? MyColors.primaryColor,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: Text(
                  title
                      .split(" - ")[0]
                      .split(" ")
                      .map((word) => word.isNotEmpty ? word[0] : '')
                      .join(),
                  style: TextStyle(
                    fontSize: avatarSize * 0.4,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),

                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
