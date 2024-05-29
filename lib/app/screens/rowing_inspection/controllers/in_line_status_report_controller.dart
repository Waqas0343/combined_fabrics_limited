import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_in_line_status_report_model.dart';
import 'package:get/get.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';
import '../models/rowing_quality_round_detail_model.dart';

class InLineStatusReportsController extends GetxController {
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectOperatorAccordingToUnit = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final Rxn<InLineStatusReportListModel?> selectedOperator = Rxn<InLineStatusReportListModel?>();
  final RxList<RowingQualityRoundDetailListModel> roundDetailList = RxList<RowingQualityRoundDetailListModel>();
  final RxList<InLineStatusReportListModel> inLineStatusList = RxList<InLineStatusReportListModel>();
  final RxList<FlagColorListModel> flagColorList = RxList<FlagColorListModel>();
  final TextEditingController operatorController = TextEditingController();
  final TextEditingController machineController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  Rx<FlagColorListModel?> selectedFlag = Rx<FlagColorListModel?>(null);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  InLineStatusReportListModel? selected;
  RowingQualityInlineInspectionFormListModel? selectedOperatorAccordingToUnit;
  final RxBool isLoading = RxBool(true);
  DateTime dateTime = DateTime.now();
  final RxString selectedLinSection = 'L15'.obs;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  RxBool autoFilterEnabled = false.obs;

  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    getRowingQualityFlag();
    getRowingQualityMachineWithFlag();
    super.onInit();
  }

  Future<void> getRowingQualityMachineWithFlag({
    int? linSection,
    String? date,
    List<String>? flags,
    String? machine,
    String? empCode,
  }) async {
    isLoading(true);
    linSection ??= 0;
    machine ??= '';
    flags ??= [];
    empCode ??= '';
    date ??= dateController.text;
    String flagsString = flags.join(',');
    inLineStatusList.clear();
    var line =
        int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    String data =
        "lineno=$line&transdate=$date&machinecode=$machine&Opcode=$empCode&Flag=$flagsString";
    List<InLineStatusReportListModel>? responseList =
        await ApiFetch.getRowingQualityInLineStatusReport(data);
    isLoading(false);
    if (responseList != null) {
      inLineStatusList.assignAll(responseList);
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
      List<RowingQualityRoundDetailListModel>? responseList =
          await ApiFetch.getRowingQualityRoundDetail(data);
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
      dateTime = date;
    }
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, List<InLineStatusReportListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 25;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<InLineStatusReportListModel> sublist =
          data.sublist(start, end.clamp(0, data.length));
      pdf.addPage(
        pw.Page(
          pageFormat: format.copyWith(
            marginLeft: 10,
            marginRight: 10,
            marginBottom: 10,
            marginTop: 10,
          ).landscape,
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
                        'Daily 7.0 Rounds & Flag Reports',
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
                  children: [
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No #",
                          "Date",
                          "W/O",
                          "Line",
                          "Machine",
                          "Operation",
                          "Operator",
                          "Op Seq",
                          "Round 1",
                          "Round 2",
                          "Round 3",
                          "Round 4",
                          "EndLine DHU%"
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
                            dateFormat.format(DateTime.parse(sublist[i].transactionDate)),
                            sublist[i].woOrders,
                            sublist[i].lineNo.toString(),
                            sublist[i].machineCode,
                            sublist[i].operationname,
                            sublist[i].empOperatorCode.toString(),
                            sublist[i].opsequence.toString(),
                            sublist[i].r1Hlfclr.isNotEmpty ?  'Red & Yellow' : sublist[i].r1FlagName ,
                            sublist[i].r2Hlfclr.isNotEmpty ?  'Red & Yellow': sublist[i].r2FlagName.toString(),
                            sublist[i].r3Hlfclr.isNotEmpty ?  'Red & Yellow':  sublist[i].r3FlagName.toString(),
                            sublist[i].r4Hlfclr.isNotEmpty ?  'Red & Yellow' :sublist[i].r4FlagName.toString(),
                           '${ sublist[i].dhuRoundwise.toString()}%',
                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].operationname ? pw.Alignment.centerLeft : pw.Alignment.center,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                cellData,
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

  /// Todo: Preview File Into PDF Format

  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.sharePdf(bytes: pdfData, filename: 'your_pdf_filename.pdf',);
  }

  /// Todo: Preview File Into PDF Format

  Future<void> exportToExcel(List<InLineStatusReportListModel> data, String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Date'),
      const TextCellValue('W/O'),
      const TextCellValue('Line'),
      const TextCellValue('Machine'),
      const TextCellValue('Operation'),
      const TextCellValue('Operator'),
      const TextCellValue('Op Sequence'),
      const TextCellValue('Flag Time'),
      const TextCellValue('Round 1'),
      const TextCellValue('Round 2'),
      const TextCellValue('Round 3'),
      const TextCellValue('Round 4'),
    ]);

    for (var item in data) {
      var date =
          dateFormat.format(DateTime.parse(item.transactionDate.toString()));
      var workOrder = item.woOrders.toString();
      var line = item.lineNo.toString();
      var machine = item.machineCode.toString();
      var operation = item.operationname.toString();
      var operator =
          item.empOperatorCode.toString(); // Treat null values as zero
      var opSequence = item.opsequence.toString();
      var flagTime =
          timeFormat.format(DateTime.parse(item.flagDate.toString()));
      var round1Flag = item.r1FlagName.toString();
      var round2Flag = item.r2FlagName.toString();
      var round3Flag = item.r3FlagName.toString();
      var round4Flag = item.r4FlagName.toString();

      Debug.log(
          ' date: $date   workOrder: $workOrder  line: $line  machine: $machine   operation: $operation operator: $operator, opSequence: $opSequence, flagTime: $flagTime  round1Flag: $round1Flag   round2Flag: $round2Flag  round3Flag: $round3Flag  round4Flag: $round4Flag');

      sheet.appendRow([
        TextCellValue(date),
        TextCellValue(workOrder),
        TextCellValue(line),
        TextCellValue(machine),
        TextCellValue(operation),
        TextCellValue(operator),
        TextCellValue(opSequence),
        TextCellValue(flagTime.toString()),
        TextCellValue(round1Flag.toString()),
        TextCellValue(round2Flag.toString()),
        TextCellValue(round3Flag.toString()),
        TextCellValue(round4Flag.toString()),
      ]);
    }
    try {
      var bytes = excel.encode();

      var directory = await getApplicationDocumentsDirectory();
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var fileName =
          '${reportName.replaceAll(' ', '_')}_$timestamp.xlsx'; // Use report name in the file name
      var file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes!);
      Get.snackbar(
        "Message",
        "Excel file successfully saved. with name of $fileName Check Your Document",
        snackPosition: SnackPosition.BOTTOM,
      );
      Debug.log('Excel file successfully saved.');
    } catch (e, s) {
      Debug.log('Error occurred while saving the Excel file: $e');
      Debug.log('Error occurred while saving the Excel file: $s');
    }
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
        date: dateController.text,
        flags: flags,
        machine: machineController.text.isNotEmpty ? machineController.text : null,
        empCode: operatorController.text.isNotEmpty ? operatorController.text : null,
      );
    } else {
      dateController.clear();
      machineController.clear();
      operatorController.clear();
    }
  }

  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    inLineStatusList.sort((a, b) {
      switch (property) {
        case 'transaction':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'work_order':
          return ascending
              ? a.woOrders.compareTo(b.woOrders)
              : b.woOrders.compareTo(a.woOrders);
        case 'sequence':
          return ascending
              ? a.opsequence.compareTo(b.opsequence)
              : b.opsequence.compareTo(a.opsequence);
        case 'operation':
          return ascending
              ? a.operationname.compareTo(b.operationname)
              : b.operationname.compareTo(a.operationname);
        case 'machine-code':
          return ascending
              ? a.machineCode.compareTo(b.machineCode)
              : b.machineCode.compareTo(a.machineCode);
        case 'employeoperatorcode':
          return ascending
              ? a.empOperatorCode.compareTo(b.empOperatorCode)
              : b.empOperatorCode.compareTo(a.empOperatorCode);
        case 'line':
          return ascending
              ? a.lineNo.compareTo(b.lineNo)
              : b.lineNo.compareTo(a.lineNo);
        case 'flag-date':
          return ascending
              ? a.flagDate.compareTo(b.flagDate )
              : b.flagDate.compareTo(a.flagDate );
        default:
          return 0;
      }
    });
  }

}
