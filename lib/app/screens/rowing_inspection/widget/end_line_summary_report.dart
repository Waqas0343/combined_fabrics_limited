import 'package:combined_fabrics_limited/app/app_widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/spacing.dart';
import '../../../../app_assets/styles/my_colors.dart';
import '../../../routes/app_routes.dart';
import '../../fabric_inspection/shimmer/rolls_shimmer.dart';
import '../models/rowing_quality_dhu_model.dart';

class EndLineSummaryReport extends StatelessWidget {
  final List<dynamic> dhuSummaryList;
  final bool isLoading;
  final DateFormat dateFormat;

  EndLineSummaryReport(
      {Key? key,
      required this.dhuSummaryList,
      required this.isLoading,
      required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dhuSummaryList.isNotEmpty && !isLoading) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EndLine Summary',
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                    ),
                  ),
                  otherSpacerVertically(),
                  CustomCard(
                    color: Colors.deepOrange.shade100,
                    child: DataTable(
                      showCheckboxColumn: false,
                      horizontalMargin: 2,
                      columnSpacing: Get.width * 0.015,
                      dataRowHeight: 40,
                      border: TableBorder.all(width: 1.0, color: Colors.black),
                      columns: [
                        DataColumn(
                          label: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "W/O",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyColors.blueAccentColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Prod Pcs",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyColors.blueAccentColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Checked Pcs",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyColors.blueAccentColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Get.width*.2,
                            child: Center(
                              child: Text(
                                "Stitch DHU",
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.blueAccentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Get.width*.2,
                            child: Center(
                              child: Text(
                                "Others",
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.blueAccentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Total Stitch",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyColors.blueAccentColor,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Total Others",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyColors.blueAccentColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        dhuSummaryList.length,
                        (index) {
                          RowingQualityDHUListModel bundleModel =
                              dhuSummaryList[index];
                          var filteredList = dhuSummaryList.where((bundle) => bundle.woNumber == bundleModel.woNumber);
                          double totalStitchDefect = filteredList.fold(0, (sum, bundle) => sum + bundle.elStichfaultpc + bundle.qmStichfaultpc);
                          double totalStitchDHU = filteredList.fold(0, (sum, bundle) => sum + bundle.elStichDhu + bundle.qmStichDhu);
                          double totalOtherDef = filteredList.fold(0, (sum, bundle) => sum + bundle.elOtherfaultpc + bundle.qmOtherfaultpc);
                          double totalOtherDHU = filteredList.fold(0, (sum, bundle) => sum + bundle.elOtherstchDhu + bundle.qmOtherstchDhu);
                          return DataRow(
                            cells: [
                              DataCell(
                                  GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.checkWorkOrderStitchingSummaryReport, arguments: {
                                          'workOrder':  bundleModel.woNumber,
                                          'Line': bundleModel.line,

                                        });
                                      },
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(bundleModel.woNumber, style: Get.textTheme.titleMedium?.copyWith(
                                        fontSize: 12,
                                        color: MyColors.blueColor,
                                        decoration:
                                        TextDecoration.underline))))),
                              DataCell(Align(
                                  alignment: Alignment.center,
                                  child: Text(bundleModel.propcs.toString()))),
                              DataCell(
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'EndLine',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                'QMP',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                bundleModel.elInspGarmentNo
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                bundleModel.qmInspGarmentNo
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'EndLine Defects',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'EndLine DHU',
                                                style: Get.textTheme.titleMedium?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'QMP Defects',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                'QMP DHU',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                bundleModel.elStichfaultpc
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${bundleModel.elStichDhu.toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                bundleModel.qmStichfaultpc
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                '${bundleModel.qmStichDhu.toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'EndLine Defects',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(

                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'EndLine DHU',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'QMP Defects',
                                                style: Get.textTheme.titleMedium?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                'QMP DHU',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                bundleModel.elOtherfaultpc
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${bundleModel.elOtherstchDhu.toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                bundleModel.qmOtherfaultpc
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                '${bundleModel.qmOtherstchDhu.toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Defects',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                'DHU',
                                                style: Get.textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                totalStitchDefect
                                                    .toStringAsFixed(0),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                '${totalStitchDHU.toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Defects',
                                                style: Get.textTheme.titleMedium?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                'DHU',
                                                style: Get.textTheme.titleMedium?.copyWith(
                                                  fontSize: 12,
                                                    color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.black87,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                totalOtherDef.toStringAsFixed(0),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                '${totalOtherDHU.toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )),
        );
      } else if (dhuSummaryList.isEmpty && isLoading) {
        return const ShimmerForRollList();
      }
      return const Center(
        child: Text(
          "No Data Found!",
        ),
      );
    });
  }
}
