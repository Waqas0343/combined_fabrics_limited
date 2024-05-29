import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../controllers/rowing_quality_check_persong_stitch_piece_controller.dart';
import '../models/rowing_quality_round_detail_model.dart';

class LineProductionRoundSummary extends StatelessWidget {
  const LineProductionRoundSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RowingQualityCheckPersonStitchPieceController roundInfoController = Get.find<RowingQualityCheckPersonStitchPieceController>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth * 0.5,
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Round Information :',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
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
                                'Line No:',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                roundInfoController.roundDetailList.isNotEmpty
                                    ? roundInfoController
                                    .roundDetailList.value.first.lineNo
                                    .toString()
                                    : '',
                                style: Get.textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'M/C #:',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                roundInfoController.roundDetailList.firstWhere((element) =>
                                element.machineCode != null)
                                    .machineCode
                                    .toString(),
                                style: Get.textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Date:',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                roundInfoController.dateFormat.format(DateTime.parse(roundInfoController.roundDetailList.value.first.transactionDate.toString(),
                                ),
                                ),
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
                ],
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (roundInfoController.roundDetailList.isNotEmpty) {
                      final pdfData = await roundInfoController.generatePdf(PdfPageFormat.a4, roundInfoController.roundDetailList);
                      await Printing.layoutPdf(onLayout: (format) => Future.value(pdfData));
                    } else {
                      Get.snackbar(
                        "Message",
                        'Try Again',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }

                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print Report'),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: DataTable(
                  showCheckboxColumn: false,
                  horizontalMargin: 10,
                  columnSpacing: Get.width * 0.010,
                  columns: [
                    DataColumn(
                      label: Text(
                        '#',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Flag',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Operator',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'W/O',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Operation',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                        label: Text(
                          'Round',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    DataColumn(
                      label: Text(
                        'Insp Pcs',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Faults Name',
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    roundInfoController.roundDetailList.length,
                        (index) {
                      RowingQualityRoundDetailListModel rollsModel =
                      roundInfoController.roundDetailList[index];
                      int serialNumber = index + 1;
                      List<Color> rowColors = [
                        const Color(0xffe5f7f1),
                        Colors.white
                      ];
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
                              rollsModel.flag,
                            ),
                          ),
                          DataCell(
                            Text(
                              roundInfoController.dateFormat.format(DateTime.parse(rollsModel.transactionDate.toString(),
                              )),
                            ),
                          ),
                          DataCell(
                            Text(
                              rollsModel.empOperatorCode.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              rollsModel.woOrders.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                                rollsModel.operationname
                            ),
                          ),
                          DataCell(
                            Text(
                              rollsModel.roundNo.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              rollsModel.inspGarmentNo.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              rollsModel.cFaults,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
