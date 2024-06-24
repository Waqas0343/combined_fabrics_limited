import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../home/home_controller.dart';

class VerifyDocumentHomePageToolsWidget extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  const VerifyDocumentHomePageToolsWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;
        final iconSize = cardHeight * 0.3;
        final fontSize = cardHeight * 0.085;

        return CustomCard(
          margin: const EdgeInsets.only(bottom: 8.0),
          onPressed: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.greenLight,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        icon,
                        height: iconSize * 0.6,
                        width: iconSize * 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Obx(() {
                return Positioned(
                  bottom: 3,
                  right: 4,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orangeAccent,
                    child: Text(
                      "${controller.documentCount.value}",
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
