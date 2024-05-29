import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/text_formatter.dart';
import '../../app_widgets/custom_card.dart';
import 'controllers/rowing_quality_end_line_controller.dart';
import 'models/rowing_quality_bundle_detail_model.dart';
import 'models/rowing_quality_inline_inspection_form_model.dart';

class EndLineInspection extends StatelessWidget {
  const EndLineInspection({super.key});

  @override
  Widget build(BuildContext context) {
    final RowingQualityEndLineController controller = Get.put(RowingQualityEndLineController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("End Line Inspection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: controller.formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  controller: controller.dateController,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "Today Date:",
                    hintText: "01/30/2020",
                  ),
                ),
                const SizedBox(height: 14),
                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.inspectionType.map((String value) {
                      if (controller.employeeDepartmentCode == '103') {
                        if (value == 'QMP') {
                          controller.selectedRadioValue.value = 'QMP';
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: CustomCard(
                                onPressed: () {
                                  controller.selectOption(value);
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      focusColor: Colors.white,
                                      groupValue: controller.selectedRadioValue.value,
                                      onChanged: (newValue) {
                                        controller.selectOption(newValue.toString());
                                      },
                                      value: value,
                                    ),
                                    Text(
                                      value,
                                      style: Get.textTheme.bodySmall!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        if (value == 'EndLine') {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: CustomCard(
                                onPressed: () {
                                  controller.selectOption(value);
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      focusColor: Colors.white,
                                      groupValue: controller.selectedRadioValue.value,
                                      onChanged: (newValue) {
                                        controller.selectOption(newValue.toString());
                                      },
                                      value: value,
                                    ),
                                    Text(
                                      value,
                                      style: Get.textTheme.bodySmall!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField(
                  value: controller.selectedLinSection.value,
                  onChanged: (String? newValue) {
                    controller.selectedLinSection.value = newValue!;
                    controller.selectedWorkOrderController.clear();
                    controller.bundleQtyController.clear();
                    controller.bundleNoController.clear();
                    controller.getRowingQualityInlineInspectionFormList(newValue);
                  },
                  hint: const Text("Unit#"),
                  items: controller.lineSectionName.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TypeAheadFormField<RowingQualityInlineInspectionFormListModel>(
                  direction: AxisDirection.down,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    controller: controller.selectedWorkOrderController,
                    decoration: InputDecoration(
                      labelText: 'Select W/O',
                      suffixIcon: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            var results = await Get.toNamed(AppRoutes.rowingQualityScanRFID);
                            if (results != null) {
                              controller.bundleNoController.text = results['bundleID'];
                              controller.bundleQtyController.text = results['quantity'].toString();
                              controller.selectedWorkOrderController.text = results['workOrder'];
                            }
                            controller.isLoading.value = false;
                          },
                          child: const Text("Scan Card"),
                        ),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    Set<int> uniqueOrderIds = Set();
                    final uniqueOrders = controller.workerAndOrderList.where((workOrder) {
                      int orderId = workOrder.orderId;
                      return orderId.toString().toLowerCase().contains(pattern.toLowerCase()) && uniqueOrderIds.add(orderId);
                    }).toList();
                    return uniqueOrders;
                  },
                  itemBuilder: (context, RowingQualityInlineInspectionFormListModel suggestion) {
                    return ListTile(
                      leading: const Icon(Icons.bookmark_border_outlined),
                      title: Text(suggestion.orderDescription),
                    );
                  },
                  onSuggestionSelected: (RowingQualityInlineInspectionFormListModel suggestion) {
                    controller.selected = suggestion;
                    controller.selectedOperator.value = suggestion;
                    controller.selectedWorkOrderController.text = suggestion.orderDescription.toString();
                    controller.getRowingQualityBundleDetailList(controller.selectedWorkOrderController.text);
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TypeAheadFormField<RowingQualityBundleListModel>(
                        direction: AxisDirection.up,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          controller: controller.bundleNoController,
                          decoration: const InputDecoration(
                            labelText: 'Bundle #',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          Set<int> uniqueOrderIds = Set();
                          final uniqueOrders = controller.bundleList.where((workOrder) {
                            int orderId = workOrder.bundlenumber;
                            return orderId.toString().toLowerCase().contains(pattern.toLowerCase()) && uniqueOrderIds.add(orderId);
                          }).toList();
                          return uniqueOrders;
                        },
                        itemBuilder: (context, RowingQualityBundleListModel suggestion) {
                          return ListTile(
                            title: Text(suggestion.bundlenumber.toString()),
                          );
                        },
                        onSuggestionSelected: (RowingQualityBundleListModel suggestion) {
                          controller.selectedB = suggestion;
                          controller.selectedBundle.value = suggestion;
                          controller.bundleNoController.text = suggestion.bundlenumber.toString();
                          controller.bundleQtyController.text = suggestion.bundlePcsOk.toString();
                          controller.getRowingQualityBundleDetailList(controller.selectedWorkOrderController.text);
                          controller.showButton.value = true;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.bundleQtyController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Bundle Qty",
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Can't be empty";
                          } else if (!GetUtils.hasMatch(
                            text,
                            TextInputFormatterHelper.validNumber.pattern,
                          )) {
                            return "Bundle Qty ${Keys.bothTextNumber}";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                SizedBox(
                  width: Get.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!controller.formKey.currentState!.validate()) return;
                      controller.formKey.currentState!.save();
                      controller.saveInspectionFormData();
                    },
                    child: const Text("Check Bundle"),
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
