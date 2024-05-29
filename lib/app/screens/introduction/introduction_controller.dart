import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../app_assets/styles/my_images.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';

class IntroController extends GetxController {
  final List<PageViewModel> _pages = [
    PageViewModel(
      titleWidget: Text(
        'Fabric Inspection Method',
        style: Get.theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      bodyWidget: Text(
        'Careful examination for flaws,defects,irregularities in weave, texture,color,or print before production.',
        style: Get.theme.textTheme.titleSmall!.copyWith(
          // fontFamily: CustomFonts.roboto,
          fontWeight: FontWeight.w400,
          // fontSize: 14.sp,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(
        MyImages.liveConsultation,
      ),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.all(24),
      ),
    ),
    PageViewModel(
        titleWidget: Text(
          'Giving Penalty Points',
          style: Get.theme.textTheme.titleMedium!.copyWith(
            // fontFamily: CustomFonts.roboto,
            fontWeight: FontWeight.w700,
            // fontSize: 16.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          'Penalty points assigned for deviations from specified standards,like quality defects,based on predetermined criteria.',
          style: Get.theme.textTheme.titleSmall!.copyWith(
            // fontFamily: CustomFonts.roboto,
            fontWeight: FontWeight.w400,
            // fontSize: 14.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        image: Image.asset(MyImages.labTest),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.all(24),
        )),
    PageViewModel(
        titleWidget: Text(
          'Calculate Total Points Per Yard',
          style: Get.theme.textTheme.titleMedium!.copyWith(
            // fontFamily: CustomFonts.roboto,
            fontWeight: FontWeight.w700,
            // fontSize: 16.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        bodyWidget: Text(
          'Total points per yard calculated by assigning numerical values or scores to specific defects found during fabric inspection.',
          style: Get.theme.textTheme.titleSmall!.copyWith(
            // fontFamily: CustomFonts.roboto,
            fontWeight: FontWeight.w400,
            // fontSize: 14.sp,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        image: Image.asset(
          MyImages.medicines,
        ),
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.all(24),
        )),
    PageViewModel(
      titleWidget: Text(
        'Format for Recording Data',
        style: Get.theme.textTheme.titleMedium!.copyWith(
          // fontFamily: CustomFonts.roboto,
          fontWeight: FontWeight.w700,
          // fontSize: 16.sp,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      bodyWidget: Text(
        'A check sheet or format for recording data is a structured document or template that provides a systematic way to collect.',
        style: Get.theme.textTheme.titleSmall!.copyWith(
          // fontFamily: CustomFonts.roboto,
          fontWeight: FontWeight.w400,
          // fontSize: 14.sp,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(
        MyImages.lastScreen,
      ),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.all(24),
      ),
    ),
  ];

  List<PageViewModel> get pages => _pages;

  void moveToHome() async {
    Get.find<Preferences>().setBool(Keys.isFirstTime, false);
    bool status = Get.find<Preferences>().getBool(Keys.status) ?? false;
    if (status) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
