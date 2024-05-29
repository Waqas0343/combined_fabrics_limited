import 'dart:async';
import 'dart:typed_data';
import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_line_production_hourly_model.dart';
import '../models/rowing_quality_employee_stitch_pcs.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';
import '../models/rowing_quality_round_detail_model.dart';

class RowingQualityCheckPersonStitchPieceController extends GetxController {
  final RxList<RowingQualityEmployeeStitchPcsListModel> stitchPcsList = RxList<RowingQualityEmployeeStitchPcsListModel>();
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectedOperator = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final RxList<RowingQualityRoundDetailListModel> roundDetailList = RxList<RowingQualityRoundDetailListModel>();
  final RxList<InLineProductionHourlyReportListModel> inLineProductionHourlyList = RxList<InLineProductionHourlyReportListModel>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController selectedEMPController = TextEditingController();
  final TextEditingController selectedMachineController = TextEditingController();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;
  final RxString selectedLinSection = 'L15'.obs;
  RowingQualityInlineInspectionFormListModel? selected;
  final RxBool isLoading = RxBool(true);
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  RxInt countOperators = 0.obs;
  RxInt countMachines = 0.obs;
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  RxInt userDashBoardValue = 0.obs;
  Timer? timer;
  RxBool autoFilterEnabled = false.obs;

  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime.value);
    autoFilterEnabled.value =
        Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    userDashBoardValue.value =
        Get.find<Preferences>().getInt(Keys.flagDashBoardTime) ?? 15;
    Debug.log(
        "----------------------------------------------${userDashBoardValue.value}--------------------------------------------------");
    getRowingQualityEmployeeStitch();
    getRowingQualityInLineProductionList();
    getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    startTimer();
    super.onInit();
  }

  Future<void> getRowingQualityEmployeeStitch({
    String? line,
    String? date,
    String? machine,
    String? workOrder,
    int? empCode,
  }) async {
    isLoading(true);
    line  ??= selectedLinSection.value;
    machine ??= '';
    workOrder ??= '';
    empCode ??= 0;
    date ??= dateController.text;
    String data = "machinecode=$machine&transdate=$date&Opcode=$empCode&Unit=$line&workOrder=$workOrder";
    stitchPcsList.clear();
    List<RowingQualityEmployeeStitchPcsListModel>? responseList = await ApiFetch.getRowingQualityEmployeeStitchPcs(data);
    isLoading(false);
    if (responseList != null) {
      Set<int> distinctWorkerIds = responseList.map((item) => item.workerId).toSet();
      Set<String> distinctMachineIds = responseList.map((item) => item.machineName).toSet();
      countOperators.value = distinctWorkerIds.length;
      countMachines.value = distinctMachineIds.length;
      Debug.log("Number of Operators: ${countOperators.value}");
      Debug.log("Number of Machines: ${countMachines.value}");
      stitchPcsList.assignAll(responseList);
    }
  }

  Future<void> getRowingQualityInlineInspectionFormList(String selectedValue) async {
    String param = "unit=$selectedValue";
    isLoading(true);
    List<RowingQualityInlineInspectionFormListModel>? responseList = await ApiFetch.getRowingQualityInlineInspectionFormList(param);
    isLoading(false);
    if (responseList != null) {
      workerAndOrderList.assignAll(responseList);
    }
  }

  Future<void> pickFromDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(minutes: 10),
      ),
    );

    if (date != null) {
      dateController.text = dateFormat.format(date);
      dateTime.value = date;
    }
  }

  void startTimer() {
    timer = Timer.periodic(
      Duration(minutes: userDashBoardValue.value),
      (timer) {
        dateTime.value = DateTime.now();
        getRowingQualityEmployeeStitch();
      },
    );
  }

  Future<void> getRowingQualityRoundDetailList(
    String? machine,
    int? round,
  ) async {
    round ??= 0;
    isLoading(true);
    String data = "date=${dateController.text}&machine=$machine&Round=$round";
    try {
      List<RowingQualityRoundDetailListModel>? responseList = await ApiFetch.getRowingQualityRoundDetail(data);
      isLoading(false);
      if (responseList != null) {
        roundDetailList.assignAll(responseList);
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );

      isLoading(false);
    }
  }

  Future<void> getRowingQualityInLineProductionList({
    String? date,
}) async {
    isLoading(true);
    date ??= dateController.text;
    String data = "date=$date&unit=$selectedLinSection";
    inLineProductionHourlyList.clear();
    List<InLineProductionHourlyReportListModel>? responseList = await ApiFetch.getRowingQualityInLineProductionReport(data);
    isLoading(false);
    if (responseList != null) {
      inLineProductionHourlyList.assignAll(responseList);
    } else {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void reverseList() {
    inLineProductionHourlyList
        .assignAll(inLineProductionHourlyList.reversed.toList());
  }

  Future<Uint8List> generatePdf(PdfPageFormat format,
      List<RowingQualityRoundDetailListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 35;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityRoundDetailListModel> sublist =
          data.sublist(start, end.clamp(0, data.length));
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20.0),
                  padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Image(logoImage, width: 60, height: 60),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'Round Information  Report',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(0.9),
                    1: const pw.FlexColumnWidth(0.7),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1.5),
                    4: const pw.FlexColumnWidth(0.9),
                    5: const pw.FlexColumnWidth(1.2),
                    6: const pw.FlexColumnWidth(1),
                    7: const pw.FlexColumnWidth(2),
                    8: const pw.FlexColumnWidth(1.4),
                    9: const pw.FlexColumnWidth(0.9),
                    10: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    // Table header
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No #",
                          "Line",
                          "M/C #",
                          "Date",
                          "Flag",
                          "Operator",
                          "W/O",
                          "Operation",
                          "Round",
                          "Insp Pcs",
                          "Faults Name"
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 7),
                            ),
                          ),
                      ],
                    ),
                    // Table rows
                    for (var i = 0; i < sublist.length; i++)
                      pw.TableRow(
                        children: [
                          for (var cellData in [
                            (start + i + 1).toString(),
                            sublist[i].lineNo,
                            sublist[i].machineCode,
                            dateFormat.format(DateTime.parse(
                                sublist[i].transactionDate.toString())),
                            sublist[i].flag,
                            sublist[i].empOperatorCode,
                            sublist[i].woOrders,
                            sublist[i].operationname,
                            sublist[i].roundNo,
                            sublist[i].cFaults,
                          ])
                            pw.Container(
                              alignment: pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                cellData.toString(),
                                style: const pw.TextStyle(fontSize: 7),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
    return pdf.save();
  }

  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {
      // Apply the filter if auto-filter is enabled
      await getRowingQualityEmployeeStitch(
        date: dateController.text,
        machine: selectedMachineController.text,
        workOrder: selectedWorkOrderController.text,
        empCode: int.tryParse(selectedEMPController.text),
      );
      getRowingQualityInLineProductionList(
        date: dateController.text,
      );
    } else {
      // Clear the selected field controllers if auto-filter is disabled
      dateController.clear();
      selectedMachineController.clear();
      selectedEMPController.clear();
      selectedWorkOrderController.clear();
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
