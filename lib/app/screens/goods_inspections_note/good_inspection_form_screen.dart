import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_colors.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/text_formatter.dart';
import 'goods_inspection_controllers/goods_inspection_form_controller.dart';

class GoodsInspectionForm extends StatelessWidget {
  const GoodsInspectionForm({super.key});

  @override
  Widget build(BuildContext context) {
    final GoodsInspectionController controller = Get.put(GoodsInspectionController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goods Inspection Form"),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: MyColors.greenLight,
                  width: 3.0,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          Text(
                            'IGP No:',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${controller.notificationModel.value?.igpNo}",
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Item Name:',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${controller.notificationModel.value?.itemName}",
                            maxLines: 1,
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Dept Name:',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${controller.notificationModel.value?.deptName}",
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'IGP Qty:',
                            style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${controller.notificationModel.value?.igpQty}",
                            maxLines: 1,
                            style: Get.textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              maxLength: 8,
              // Keep the maximum length as 8
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: controller.acceptQtyController,
              decoration: const InputDecoration(
                hintText: "e.g (10)",
                labelText: 'Accept Quantity',
                filled: true,
                fillColor: Colors.white,
                counterText: "",
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  double enteredValue = double.parse(text);
                  num igpQty = controller.notificationModel.value?.igpQty ??
                      double.infinity;

                  if (enteredValue > igpQty) {
                    controller.acceptQtyController.text = igpQty.toString();
                  }
                }
              },
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndTextWithDot.pattern,
                )) {
                  return "Accept Quantity ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              maxLength: 8,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: controller.rejectQtyController,
              decoration: const InputDecoration(
                hintText: "e.g (10)",
                labelText: 'Reject Quantity',
                filled: true,
                fillColor: Colors.white,
                counterText: "",
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  double enteredValue = double.parse(text);
                  num igpQty = controller.notificationModel.value?.igpQty ??
                      double.infinity;

                  if (enteredValue > igpQty) {
                    controller.rejectQtyController.text = igpQty.toString();
                  }
                }

                // Update the isRejectQtyEmpty variable
                controller.updateRejectQtyField();
              },
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndTextWithDot.pattern,
                )) {
                  return "Reject Quantity ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Obx(() {
              return controller.isRejectQtyEmpty.value
                  ? const SizedBox.shrink()
                  : TextFormField(
                      controller: controller.rejectReasonController,
                      decoration: const InputDecoration(
                        hintText: "e.g (10)",
                        labelText: 'Reject Reason',
                        filled: true,
                        fillColor: Colors.white,
                        counterText: "",
                      ),
                    );
            }),
            const SizedBox(
              height: 8,
            ),
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
              validator: (text) {
                if (text!.isEmpty) {
                  return "Can't be empty";
                } else if (!GetUtils.hasMatch(
                  text,
                  TextInputFormatterHelper.numberAndTextWithDot.pattern,
                )) {
                  return "Remarks ${Keys.bothTextNumber}";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 14,
            ),
            ElevatedButton(
              onPressed: () {
                controller.saveInspectionFormData();
              },
              child: const Text(
                "Save Data",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
