import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_dhu_model.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_in_line_status_report_model.dart';
import 'package:get/get.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';
import '../models/rowing_quality_round_detail_model.dart';

class InLineLiveStatusFlagController extends GetxController {
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectedOperator = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final RxList<RowingQualityRoundDetailListModel> roundDetailList =RxList<RowingQualityRoundDetailListModel>();
  final RxList<InLineStatusReportListModel> inLineStatusList = RxList<InLineStatusReportListModel>();
  final RxList<RowingQualityDHUListModel> dhuList =RxList<RowingQualityDHUListModel>();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final TextEditingController selectedMachineController = TextEditingController();
  final RxList<FlagColorListModel> flagColorList = RxList<FlagColorListModel>();
  final TextEditingController selectedEMPController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  Rx<FlagColorListModel?> selectedFlag = Rx<FlagColorListModel?>(null);
  RowingQualityInlineInspectionFormListModel? selected;
  final RxBool isLoading = RxBool(true);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx <DateTime> dateTime = DateTime.now().obs;
  final RxBool hasSearchText = RxBool(false);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final RxString selectedLinSection = 'L15'.obs;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  Timer? timer;
  RxInt countOperators = 0.obs;
  RxInt countMachines = 0.obs;
  RxInt userDashBoardValue = 0.obs;
  RxBool autoFilterEnabled = false.obs;

  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime.value);
    userDashBoardValue.value = Get.find<Preferences>().getInt(Keys.flagDashBoardTime) ?? 15;
     autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    Debug.log("----------------------------------------------${userDashBoardValue.value}--------------------------------------------------");
    Debug.log("----------------------------------------------$autoFilterEnabled--------------------------------------------------");
    getRowingQualityMachineWithFlag();
    getRowingQualityFlag();
    getRowingQualityDHUList();
    getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    startTimer();
    super.onInit();
  }

  Future<void> getRowingQualityDHUList({
    String? date,
  }) async {
    isLoading(true);
    date ??= dateController.text;
    int selectedLine = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "Fromdate=$date&Todate=$date&lineno=$selectedLine";
    try {
      dhuList.clear();
      List<RowingQualityDHUListModel>? responseList = await ApiFetch.getRowingQualityDHUDetail(data);
      isLoading(false);
      if (responseList != null) {
        dhuList.assignAll(responseList);
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

  Future<void> getRowingQualityMachineWithFlag({
    int? linSection,
    List<String>? flags,
    String? date,
    String? machine,
    String? workOrder,
    int? empCode,
  }) async {
    isLoading(true);
    linSection ??= 0;
    flags ??= [];
    machine ??= '';
    workOrder ??= '';
    empCode ??= 0;
    date ??= dateController.text;
    String flagsString = flags.join(',');
    int selectedLine = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data = "machinecode=$machine&transdate=$date&Opcode=$empCode&Flag=$flagsString&workorder=$workOrder&lineno=$selectedLine";
    inLineStatusList.clear();
    List<InLineStatusReportListModel>? responseList = await ApiFetch.getRowingQualityInLineStatusReport(data);
    isLoading(false);
    if (responseList != null) {
      Set<String> distinctWorkerIds = responseList.map((item) => item.empOperatorCode).toSet();
      Set<String> distinctMachineIds = responseList.map((item) => item.machineCode).toSet();
      countOperators.value = distinctWorkerIds.length;
      countMachines.value = distinctMachineIds.length;
      Debug.log("Number of Operators: ${countOperators.value}");
      Debug.log("Number of Machines: ${countMachines.value}");
      inLineStatusList.assignAll(responseList);
    }
  }

  Future<void> getRowingQualityFlag() async {
    isLoading(true);
    List<FlagColorListModel>? responseList = await ApiFetch.getRowingQualityFlagColor();
    isLoading(false);
    if (responseList != null) {
      flagColorList.assignAll(responseList);
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
        refreshListData();
      },
    );
  }

  void refreshListData() async {
    await getRowingQualityMachineWithFlag();
    await getRowingQualityDHUList();
  }
  Future<void> applyFilter() async {
    inLineStatusList.clear();
    getRowingQualityMachineWithFlag();
  }
  Future<Uint8List> generatePdf(PdfPageFormat format, List<RowingQualityRoundDetailListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 35;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityRoundDetailListModel> sublist = data.sublist(start, end.clamp(0, data.length));
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
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
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
                            dateFormat.format(DateTime.parse(sublist[i].transactionDate.toString())),
                            sublist[i].flag,
                            sublist[i].empOperatorCode,
                            sublist[i].woOrders,
                            sublist[i].operationname,
                            sublist[i].roundNo,
                            sublist[i].inspGarmentNo,
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
  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.sharePdf(bytes: pdfData, filename: 'your_pdf_filename.pdf');
  }
  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }
  Future<void> autoFilter() async {
    List<String> flags = [];
    if (selectedFlag.value != null) {
      flags = selectedFlag.value!.colorHexCode.split('&');
      flags = flags.map((flag) => flag.trim()).toList();
      // Remove spaces from the flags list
      flags = flags.map((flag) => flag.replaceAll(' ', '')).toList();
      // Replace commas with hyphens
      flags = flags.map((flag) => flag.replaceAll(',', '-')).toList();
    }
    if (autoFilterEnabled.value) {
      await getRowingQualityMachineWithFlag(
        linSection: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
        flags: flags,
        date: dateController.text,
        machine: selectedMachineController.text.isNotEmpty ? selectedMachineController.text : null,
        workOrder: selectedWorkOrderController.text.isNotEmpty ? selectedWorkOrderController.text : null,
        empCode: selectedEMPController.text.isNotEmpty ? int.tryParse(selectedEMPController.text) : null,
      );
      getRowingQualityDHUList(date: dateController.text);
    } else {
      dateController.clear();
      selectedMachineController.clear();
      selectedWorkOrderController.clear();
      selectedEMPController.clear();
    }
  }


  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

