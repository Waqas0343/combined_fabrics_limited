import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/text_formatter.dart';
import 'controllers/keys_issuance_return_controller.dart';

class KeysIssuanceReturnForm extends StatelessWidget {
  const KeysIssuanceReturnForm({super.key});

  @override
  Widget build(BuildContext context) {
    final KeysIssuanceReturnController controller = Get.put(KeysIssuanceReturnController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keys Issuance Form"),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          children: <Widget>[
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              maxLength: 8,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: controller.keysCodeController,
              enabled: false,
              decoration: const InputDecoration(
                hintText: "e.g (10)",
                labelText: 'Key No',
                filled: true,
                fillColor: Colors.white,
                counterText: "",
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndTextWithDot.pattern,
                )) {
                  return "Key ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              maxLength: 8,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: controller.employeeCodeController,
              decoration: const InputDecoration(
                hintText: "e.g (10)",
                labelText: 'Employee CardNo',
                filled: true,
                fillColor: Colors.white,
                counterText: "",
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndTextWithDot.pattern,
                )) {
                  return "Employee CardNo ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller.remarksController,
              decoration: const InputDecoration(
                hintText: "e.g",
                labelText: 'Remarks',
                filled: true,
                counterText: "",
                fillColor: Colors.white,
              ),
              // validator: (text) {
              //   if (text!.isEmpty) {
              //     return "Can't be empty";
              //   } else if (!GetUtils.hasMatch(
              //     text,
              //     TextInputFormatterHelper.numberAndTextWithDot.pattern,
              //   )) {
              //     return "Remarks ${Keys.bothTextNumber}";
              //   }
              //   return null;
              // },
            ),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              height: 47,
              child: ElevatedButton(
                onPressed: () {
                  controller.issueKeyToPerson();
                },
                child: const Text(
                  "Press to Issue Key",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
