import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:combined_fabrics_limited/app_assets/styles/strings/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../helpers/text_formatter.dart';
import 'login_screen_controller.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => Get.focusScope?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Image.asset(
                    MyImages.logo,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 60.0),
                AutofillGroup(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofillHints: const [AutofillHints.username],
                          controller: controller.loginIDController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Login ID",
                          ),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Can't be empty";
                            } else if (!GetUtils.hasMatch(
                              text,
                              TextInputFormatterHelper.numberAndTextWithDot.pattern,
                            )) {
                              return "Login ID ${Keys.bothTextNumber}";
                            }
                            return null;
                          },
                          onSaved: (text) => controller.loginId = text,
                          onChanged: controller.saveLoginCredentials,
                        ),
                        const SizedBox(height: 12.0),
                        Obx(
                          () => TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            autofillHints: const [AutofillHints.password],
                            controller: controller.passwordController,
                            obscureText: !controller.isPasswordVisible.value,
                            validator: (text) {
                              if (text!.isEmpty) return "Can't be empty";
                              return null;
                            },
                            onSaved: (text) => controller.password = text,
                            onChanged: controller.saveLoginCredentials,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  controller.togglePasswordVisibility();
                                },
                                child: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                          horizontalTitleGap: 2,
                          leading: SizedBox(
                            width: 32,
                            child: Obx(
                              () => CheckboxListTile(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.toggleRememberMe(value);
                                  TextInput.finishAutofillContext();
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            'Remember Me',
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return Obx(
                                () {
                                  return ElevatedButton(
                                    onPressed: controller.buttonAction.value
                                        ? () {
                                            TextInput.finishAutofillContext();
                                            controller.login();
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(constraints.maxWidth, 0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    child: Text(
                                      "Login",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: MyColors
                                                  .shimmerHighlightColor),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              child: Text(
                                'Forgot Password?',
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
