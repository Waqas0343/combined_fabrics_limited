import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/background_service.dart';
import 'app/services/services.dart';
import 'app_assets/app_theme_info.dart';
import 'app_assets/styles/my_colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

FlutterBackgroundService service = FlutterBackgroundService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: BackgroundService.onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: BackgroundService.onStart,
      onBackground: (service) => false,
    ),
  );

  await service.startService();
  await Services().initServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: MyColors.greenLight),
    );
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: AppThemeInfo.themeData,
    );
  }
}
