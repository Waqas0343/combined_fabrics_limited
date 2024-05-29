import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'introduction_controller.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IntroController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: IntroductionScreen(
        // globalBackgroundColor: Get.theme.primaryColor,
        pages: controller.pages,
        onDone: () => controller.moveToHome(),
        done: Text(
          "Get Started",
          style: Get.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: MyColors.primaryColor,
          ),
        ),
        dotsDecorator: const DotsDecorator(
          activeColor: MyColors.primaryColor,
          activeSize: Size.fromRadius(6.5),
        ),
        showNextButton: true,
        next: const Icon(
          Icons.arrow_forward,
          color:MyColors.primaryColor,
        ),
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: Get.theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: MyColors.primaryColor,
          ),
        ),
        skipOrBackFlex: 0,
        nextFlex: 0,
        onSkip: () => controller.moveToHome(),
      ),
    );
  }
}
