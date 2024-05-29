import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_colors.dart';
import 'controllers/key_history_controller.dart';
import 'models/kyes_model.dart';

class CheckKeyHistory extends StatelessWidget {
  const CheckKeyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final KeyHistoryController controller = Get.put(KeyHistoryController());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Check Key History"),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Check Last 20 Transaction",
                    style: Get.textTheme.titleLarge!
                        .copyWith(color: MyColors.yellow),
                  )),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: DataTable(
                showCheckboxColumn: false,
                columns: [
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "#.",
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Entry Date",
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Return Date",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Issue to Card",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Issue To",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Return By Card",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Return By",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Status",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Remarks",
                        textAlign: TextAlign.left,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  controller.keysDetails.length,
                  (index) {
                    KeysDetail lotDetailModel = controller.keysDetails[index];
                    List<Color> rowColors = [
                      const Color(0xffe5f7f1),
                      Colors.white
                    ];
                    Color rowColor = rowColors[index % rowColors.length];
                    return DataRow(
                      color:
                          MaterialStateColor.resolveWith((states) => rowColor),
                      cells: [
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (index + 1).toString(),
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lotDetailModel.entryDate,
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lotDetailModel.keyReturnDate.toString(),
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lotDetailModel.keyIssueCardNo.toString(),
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lotDetailModel.keyIssueTo,
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lotDetailModel.keyReturnCardNo.toString(),
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              lotDetailModel.keyReturnBy ?? "",
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            lotDetailModel.status.toString(),
                          ),
                        ),
                        DataCell(
                          Text(
                            lotDetailModel.remarks,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
