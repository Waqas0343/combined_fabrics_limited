import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/services.dart';
import 'app_assets/app_theme_info.dart';
import 'app_assets/styles/my_colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Services().initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: MyColors.greenLight));
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: AppThemeInfo.themeData,
    );
  }
}
