import 'package:flutter/material.dart';

import '../../app_assets/app_theme_info.dart';

class CustomCard extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed, onLongPressed;
  final Widget? child;
  final EdgeInsets? margin;
  final double? radius;

  const CustomCard({
    Key? key,
    this.child,
    this.color,
    this.onPressed,
    this.onLongPressed,
    this.margin,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(radius ?? AppThemeInfo.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 2.5,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Material(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? AppThemeInfo.borderRadius),
        type: MaterialType.button,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius ?? AppThemeInfo.borderRadius),
          onTap: onPressed,
          onLongPress: onLongPressed,
          child: child,
        ),
      ),
    );
  }
}
