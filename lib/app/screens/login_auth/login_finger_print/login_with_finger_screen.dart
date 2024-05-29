import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../helpers/toaster.dart';
import '../../../routes/app_routes.dart';
import '../../dialogs/dialog.dart';
import 'login_with_finger_controller.dart';

class LoginWithFingerPrint extends StatelessWidget {
  const LoginWithFingerPrint({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginWithFingerController());
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                  ),
                  child: Image.asset(
                    MyImages.logo,
                    height: 140.0,
                  ),
                ),
              ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(160.0),
                    child: CachedNetworkImage(
                      imageUrl: controller.imagePath ?? "",
                      placeholder: (_, __) => Image.asset(MyImages.user),
                      height: 170,
                      fit: BoxFit.cover,
                      width: 170,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    controller.name ?? "",
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    if (controller.showFingerprintLogin.value) {
                      return SizedBox(
                        width: Get.size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool isBiometric = await controller
                                .localAuthentication.canCheckBiometrics;
                            if (isBiometric) {
                              bool isAuthenticated = await controller
                                  .localAuthentication
                                  .authenticate(
                                localizedReason:
                                'Please scan your fingerprint for successfully login.',
                                options: const AuthenticationOptions(
                                  useErrorDialogs: true,
                                  stickyAuth: true,
                                  biometricOnly: true,
                                ),
                              );
                              if (isAuthenticated) {
                                Get.dialog(
                                  const LoadingSpinner(),
                                );
                                await controller.loginWithFingerPrint();
                                Get.back();
                                Get.offAllNamed(AppRoutes.home);
                              } else {
                                Toaster.showToast(
                                    'Authentication failed. Please try again.');
                              }
                            }
                          },
                          child: const Text(
                            "Login with FingerPrint",
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: Get.size.width,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      child: const Text(
                        "Login another account",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: " ",
                  style: Get.textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "Create new account",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.toNamed(AppRoutes.login),
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