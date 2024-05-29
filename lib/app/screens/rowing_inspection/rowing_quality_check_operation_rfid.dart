import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_widgets/custom_card.dart';
import '../fabric_inspection/shimmer/rolls_shimmer.dart';
import 'controllers/rowing_quality_check_operation_rfid_controller.dart';
import 'models/rowing_quality_rfid_card_scane_model.dart';

class CheckWorkerOperationAgainstCard extends StatelessWidget {
  const CheckWorkerOperationAgainstCard({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckWorkerOperationAgainstCardController controller = Get.put(CheckWorkerOperationAgainstCardController());
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Card Operation For EndLine"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => Text(
              controller.isNfcAvailable.value
                  ? "RFID Available"
                  : "RFID Not Available",
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final resultValue = controller.result.value;
                if (resultValue.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomCard(
                          color: const Color(0xffe5f7f1),
                          child: ListTile(
                            leading: const ClipOval(
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.greenAccent,
                              ),
                            ),
                            title: Text(
                              controller.blockDataString.value,
                              style: Get.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: ShimmerForRollList(),
                            );
                          } else if (controller.operatorProductionList.isEmpty) {
                            return const Center(
                              child: Text("No Data Found!"),
                            );
                          } else {
                            return Expanded(
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                scrollbarOrientation: ScrollbarOrientation.bottom,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: scrollController,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                          showCheckboxColumn: false,
                                          horizontalMargin: 2,
                                          columnSpacing: Get.width * 0.015,
                                          dataRowHeight: 40,
                                          columns: [
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  "#",
                                                  style: Get.textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("Line#",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("Operator",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("M/C#",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("W/O#",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("Operation",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("BundleID",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text("Bundle QTY",
                                                    style: Get.textTheme.titleSmall
                                                        ?.copyWith(
                                                        fontWeight: FontWeight.w600)),
                                              ),
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(
                                            controller.operatorProductionList.length, (index) {
                                            CardScanListModel reportModel = controller.operatorProductionList[index];
                                            List<Color> rowColors = [const Color(0xffe5f7f1), Colors.white];
                                            Color rowColor = rowColors[index % rowColors.length];
                                            int serialNumber = index + 1;
                                            return DataRow(
                                              color: MaterialStateColor.resolveWith((states) => rowColor),
                                              cells: [
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(serialNumber.toString()))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.lineId))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.opertor))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.machineId))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.orderDescription))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.operationDescription))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.bundleId.toString()))),
                                                DataCell(Align(alignment: Alignment.centerLeft, child: Text(reportModel.quantity.toString()))),
                                              ],
                                            );
                                          },
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  );
                } else {
                  return const Text("Scan Bundle Card");
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
