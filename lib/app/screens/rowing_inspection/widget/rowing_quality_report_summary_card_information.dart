import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/in_line_status_report_controller.dart';
import '../models/rowing_quality_round_detail_model.dart';

class LiveReportInfoCard extends StatelessWidget {
  const LiveReportInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InLineStatusReportsController roundInfoController = Get.find<InLineStatusReportsController>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth * 0.4,
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Round Information',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                            'Fault',
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
                                  roundInfoController.dateFormat
                                      .format(DateTime.parse(
                                    rollsModel.transactionDate.toString(),
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
                                  rollsModel.operationname.toString(),
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
