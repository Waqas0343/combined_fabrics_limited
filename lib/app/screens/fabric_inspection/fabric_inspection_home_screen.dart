import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'controllers/fabric_inspection_home_controller.dart';
import 'models/lot_detail_model.dart';
import 'models/lots_model.dart';

class FabricInspectionHome extends StatelessWidget {
  const FabricInspectionHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FabricInspectionHomeController filterController = Get.put(FabricInspectionHomeController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "Fabric Inspection",
            ),
            const SizedBox(
              width: 50,
            ),
            // Adds flexible space between text and RichText
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: ["M1", "M2", "M3", "M4", "M5","M6","M7","M8"]
                        .contains(filterController.table)
                    ? RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "Inspection On Machine: ",
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: MyColors.shimmerHighlightColor,
                          ),
                          children: [
                            TextSpan(
                              text: "${filterController.table}  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            TextSpan(
                              text: "Shift:  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: MyColors.shimmerHighlightColor,
                              ),
                            ),
                            TextSpan(
                              text: "${filterController.shift}",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: "Inspection On Table: ",
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: MyColors.shimmerHighlightColor,
                          ),
                          children: [
                            TextSpan(
                              text: "${filterController.table}  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.cyanAccent,
                              ),
                            ),
                            TextSpan(
                              text: "Shift:  ",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: MyColors.shimmerHighlightColor,
                              ),
                            ),
                            TextSpan(
                              text: "${filterController.shift}",
                              style: Get.textTheme.titleLarge?.copyWith(
                                color: Colors.cyanAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: filterController.formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TypeAheadFormField<LotsListModel>(
              direction: AxisDirection.down,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                enabled: true,
                focusNode: filterController.lotFocusScope,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: filterController.lotTextController,
                decoration: const InputDecoration(
                  hintText: 'Search Lot No',
                  labelText: "Select Lot No",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                  ),
                ),
              ),
              onSuggestionSelected: (LotsListModel lot) async {
                await filterController.lotDetail(lot.lotNo);
                filterController.selectedLot.value = int.parse(lot.lotNo);
                filterController.lotTextController.text = lot.lotNo.toString();
              },
              itemBuilder: (_, LotsListModel lot) {
                return ListTile(
                  title: Text(
                    lot.lotNo.toString(),
                  ),
                );
              },
              suggestionsCallback: (String query) async {
                await filterController.getLots(query);
                List<LotsListModel> filteredList =
                    filterController.lotList.where((lot) {
                  return lot.lotNo
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }).toList();

                // Sort the filteredList based on the numeric value of lotNo
                filteredList.sort((a, b) {
                  int? lotNoA = int.tryParse(a.lotNo.toString());
                  int? lotNoB = int.tryParse(b.lotNo.toString());
                  return lotNoA?.compareTo(lotNoB ?? 0) ?? 0;
                });

                return filteredList;
              },
              noItemsFoundBuilder: (_) => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Lot No Not Found",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              errorBuilder: (context, error) {
                return const SizedBox();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lot Number is required';
                }
                return null;
              },
              onSaved: (value) {
                filterController.lotsList = value;
              },
              loadingBuilder: (BuildContext context) {
                return Obx(() {
                  if (filterController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (filterController.lotList.isEmpty) {
                    return const Center(
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  } else {
                    // Show the list of suggestions here
                    return ListView.builder(
                      itemCount: filterController.lotList.length,
                      itemBuilder: (_, index) {
                        LotsListModel lot = filterController.lotList[index];
                        return ListTile(
                          title: Text(lot.lotNo.toString()),
                          onTap: () {
                            // Handle the selection here if needed
                          },
                        );
                      },
                    );
                  }
                });
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            Obx(
              () {
                if (filterController.lotDetailList.isNotEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Serial.No.",
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Work Order",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Fabric Color",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "DiaGG",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Fabric",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Total Rolls",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Ecru Kgs",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Finish Kgs",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "RP Status",
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          filterController.lotDetailList.length,
                          (index) {
                            LotDetailModelList lotDetailModel = filterController.lotDetailList[index];
                            int serialNumber = index + 1;

                            // Define a list of colors for each row
                            List<Color> rowColors = [
                              const Color(0xffe5f7f1),
                              Colors.white
                            ];

                            // Get the color for the current row
                            Color rowColor = rowColors[index % rowColors.length];

                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                  (states) => rowColor),
                              cells: [
                                DataCell(
                                  Text(
                                    serialNumber.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.workOrderNo,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.color,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.diaGg,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.fabric,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.rolls.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    "${lotDetailModel.ecruKgs.isNotEmpty ? lotDetailModel.ecruKgs : 0}",
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    lotDetailModel.kgs.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(lotDetailModel.rpStatus),
                                ),
                              ],
                              onSelectChanged: (isSelected) {
                                if (isSelected != null && isSelected) {
                                  Get.toNamed(
                                    AppRoutes.fabricInspectionList,
                                    arguments: {
                                      'lotNo': filterController.selectedLot.toString(),
                                      'color': lotDetailModel.color,
                                      'fabric': lotDetailModel.fabric,
                                      'work order': lotDetailModel.workOrderNo,
                                      'DiaGG': lotDetailModel.diaGg,
                                      'rolls': lotDetailModel.rolls,
                                      'kg': lotDetailModel.kgs,
                                      'EcruKgs': lotDetailModel.ecruKgs,
                                      'rpStatus': lotDetailModel.rpStatus
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(
      //       horizontal: 12.0,
      //       vertical: 4.0,
      //     ),
      //     child: Obx(
      //       () {
      //         if (filterController.selectedLot.value != 0) {
      //           return OutlinedButton(
      //             onPressed: () {
      //               filterController.resetFilter();
      //             },
      //             child: const Text(
      //               "Clear",
      //             ),
      //           );
      //         }
      //         return const SizedBox.shrink();
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
