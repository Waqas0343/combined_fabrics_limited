import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintPortalCard extends StatelessWidget {
  const ComplaintPortalCard({
    Key? key,
    required this.titleText,
    required this.subTitleText,
    this.color,
    this.icon,
  }) : super(key: key);

  final String titleText;
  final String subTitleText;
  final Color? color;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CustomCard(
      color: color ?? Colors.white,
      child: SizedBox(
        height: screenSize.width < 500 ? 70 : 130,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width < 600 ? 8.0 : 16.0,
            vertical: screenSize.width < 600 ? 10 : 30,
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width < 600 ? 12 : 12, // Adjust font size
                        color: MyColors.shimmerHighlightColor,
                      ),
                    ),
                    Text(
                      subTitleText,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.width < 600 ? 12 : 12, // Adjust font size
                        color: MyColors.shimmerHighlightColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
