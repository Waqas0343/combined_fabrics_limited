import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app_assets/styles/my_images.dart';
import 'spash_screen_controller.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    MyImages.logo,
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  const SizedBox(height: 16.0),
                  if (!controller.connectivityError.value)
                    const CircularProgressIndicator(),
                  if (controller.connectivityError.value)
                    Column(
                      children: [
                        const Icon(
                          Icons.signal_wifi_off_outlined,
                          size: 60,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Internet Not available.",
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () => controller.checkLogin(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                          ),
                          child: const Text(
                            "Retry",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
