import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../app_assets/styles/my_images.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_Inspector_Activity_Model.dart';

class InLineInspectorActivityController extends GetxController {
  final RxList<InspectorActivityListModel> inspectorList = RxList<InspectorActivityListModel>();
  final Rxn<InspectorActivityListModel?> selectedOperator = Rxn<InspectorActivityListModel?>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController lineNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final TextEditingController inspectorNameController = TextEditingController();
  TextEditingController typeAheadController = TextEditingController();
  final TextEditingController roundController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final RxBool isLoading = RxBool(true);
  RxBool autoFilterEnabled = false.obs;
  InspectorActivityListModel? selected;
  final RxString selectedLinSection = 'L15'.obs;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  RxString selectedSortOption = 'inspectername,transactionDate'.obs;
  List<String> sortingOptions = [
    'inspectername,transactionDate',
    'woOrders,opsequence',
    'transactionDate,opsequence,inspectername',
  ];
  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getInspectorActivityDetail();
    super.onInit();
  }

  Future<void> getInspectorActivityDetail({
    String? date,
    String? inspector,
    int? Round,
    int? linSection,
  }) async {
    linSection ??= 0;
    inspector ??= '';
    Round ??= 0;
   var line = int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), ''));
    date ??= dateController.text;
    String params = "inspector=$inspector&date=$date&Round=$Round&Lineno=$line";
    isLoading(true);
    inspectorList.clear();
    List<InspectorActivityListModel>? responseList = await ApiFetch.getRowingInspectorActivityDetail(params);
    isLoading(false);
    if (responseList != null) {
      inspectorList.assignAll(responseList);
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
  Future<Uint8List> generatePdf(PdfPageFormat format, List<InspectorActivityListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 25;
    final int totalPages = (data.length / itemsPerPage).ceil();
    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<InspectorActivityListModel> sublist = data.sublist(start, end.clamp(0, data.length));
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
                        'Daily 7.0 InLine Inspector Activity Report',
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
                    // Table header
                    pw.TableRow(
                      children: [
                        for (var header in [
                          "No #",
                          "Time",
                          "M/C",
                          "W/O",
                          "Op Seq",
                          "Operation",
                          "Operator",
                          "Round",
                          "Insp Pcs",
                          "Inspector",
                          "Flag",
                          "Faults"
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
                            timeFormat.format(DateTime.parse(sublist[i].transactionDate.toString())),
                            sublist[i].machineCode.toString(),
                            sublist[i].woOrders.toString(),
                            sublist[i].opsequence.toString(),
                            sublist[i].operationname.toString(),
                            sublist[i].empOperatorCode.toString(),
                            sublist[i].roundNo.toString(),
                            sublist[i].inspGarmentNo.toString(),
                            sublist[i].inspectername.toString(),
                            sublist[i].flag.toString(),
                            sublist[i].cFaults.toString(),
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
  ///todo: preview the PDF report
  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.sharePdf(bytes: pdfData, filename: 'Inspector Activity Report.pdf');
  }

/// Todo: Export File Into Excel

  Future<void> exportToExcel(List<InspectorActivityListModel> data,  String reportName) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([
      const TextCellValue('Time'),
      const TextCellValue('M/C'),
      const TextCellValue('Operation Name'),
      const TextCellValue('Operator'),
      const TextCellValue('Round'),
      const TextCellValue('Insp Pcs'),
      const TextCellValue('Inspector'),
      const TextCellValue('Flag'),
      const TextCellValue('Fault'),
    ]);

    for (var item in data) {
      var time = timeFormat.format(DateTime.parse(item.transactionDate.toString()));
      var machine = item.machineCode.toString();
      var operationName = item.operationname.toString();
      var operator = item.empOperatorCode.toString();
      var round = item.roundNo.toString();
      var inspPcs = item.inspGarmentNo.toString(); // Treat null values as zero
      var inspector = item.inspectername.toString();
      var flag = item.flag.toString();
      var fault = item.cFaults.toString();

      Debug.log(' time: $time   machine: $machine  operationName: $operationName  operator: $operator   round: $round inspPcs: $inspPcs, inspector: $inspector, flag: $flag  fault: $fault');

      sheet.appendRow([
        TextCellValue(time),
        TextCellValue(machine),
        TextCellValue(operationName),
        TextCellValue(operator),
        TextCellValue(round),
        TextCellValue(inspPcs),
        TextCellValue(inspector),
        TextCellValue(flag.toString()),
        TextCellValue(fault.toString()),
      ]);
    }
    try {
      var bytes = excel.encode();

      var directory = await getApplicationDocumentsDirectory();
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var fileName = '${reportName.replaceAll(' ', '_')}_$timestamp.xlsx'; // Use report name in the file name
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
  void autoFilter() {
    if (autoFilterEnabled.value) {
      // If auto-filter is enabled, apply the filter
      getInspectorActivityDetail(
        date: dateController.text,
        inspector: inspectorNameController.text,
        Round: int.tryParse(roundController.text),
        linSection: int.parse(selectedLinSection.value.replaceAll(RegExp(r'[^0-9]'), '')),
      );
    } else {
      // If auto-filter is disabled, clear the selected field controllers
      dateController.clear();
      inspectorNameController.clear();
      roundController.clear();
      lineNoController.clear();
    }
  }

  // void reverseList() {
  //   inspectorList.assignAll(inspectorList.reversed.toList());
  // }

  void onSortOptionChanged(String? selectedOption) {
    if(selectedOption != null) {
      selectedSortOption.value = selectedOption;
      List<String> options = selectedSortOption.value.split(',').map((option) => option.trim()).toList();
      sortingData(options);
    }
  }
  void sortingData(List<String> options) {
    inspectorList.sort((a, b) {
      for (String combinedOption in options) {
        List<String> individualOptions = combinedOption.split(',').map((option) => option.trim()).toList();
        int result;
        for (String property in individualOptions) {
          switch (property) {
            case 'machineCode':
              result = a.machineCode.compareTo(b.machineCode);
              break;
            case 'transactionDate':
              result = a.transactionDate.compareTo(b.transactionDate);
              break;
            case 'woOrders':
              result = a.woOrders.compareTo(b.woOrders);
              break;
            case 'opsequence':
              result = a.opsequence.compareTo(b.opsequence);
              break;
            case 'roundNo':
              result = a.roundNo.compareTo(b.roundNo);
              break;
            case 'operationname':
              result = a.operationname.compareTo(b.operationname);
              break;
            case 'empOperatorCode':
              result = a.empOperatorCode.compareTo(b.empOperatorCode);
              break;
            case 'operationCode':
              result = a.operationCode.compareTo(b.operationCode);
              break;
            case 'inspGarmentNo':
              result = a.inspGarmentNo.compareTo(b.inspGarmentNo);
              break;
            case 'inspectername':
              result = a.inspectername.compareTo(b.inspectername);
              break;
            case 'flag':
              result = a.flag.compareTo(b.flag);
              break;
            case 'cFaults':
              result = a.cFaults.compareTo(b.cFaults);
              break;
            default:
              return 0;
          }
          if (result != 0) {
            return result;
          }
        }
      }
      return 0;
    });
  }






  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    inspectorList.sort((a, b) {
      switch (property) {
        case 'machineCode':
          return ascending
              ? a.machineCode.compareTo(b.machineCode)
              : b.machineCode.compareTo(a.machineCode);
        case 'transactionDate':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'woOrders':
          return ascending
              ? a.transactionDate.compareTo(b.transactionDate)
              : b.transactionDate.compareTo(a.transactionDate);
        case 'opsequence':
          return ascending
              ? a.opsequence.compareTo(b.opsequence)
              : b.opsequence.compareTo(a.opsequence);
        case 'roundNo':
          return ascending
              ? a.roundNo.compareTo(b.roundNo)
              : b.roundNo.compareTo(a.roundNo);
        case 'operationname':
          return ascending
              ? a.operationname.compareTo(b.operationname)
              : b.operationname.compareTo(a.operationname);
        case 'empOperatorCode':
          return ascending
              ? a.empOperatorCode.compareTo(b.empOperatorCode)
              : b.empOperatorCode.compareTo(a.empOperatorCode);
        case 'operationCode':
          return ascending
              ? a.operationCode.compareTo(b.operationCode)
              : b.operationCode.compareTo(a.operationCode);
        case 'inspGarmentNo':
          return ascending
              ? a.inspGarmentNo.compareTo(b.inspGarmentNo)
              : b.inspGarmentNo.compareTo(a.inspGarmentNo);
        case 'inspectername':
          return ascending
              ? a.inspectername.compareTo(b.inspectername )
              : b.inspectername.compareTo(a.inspectername );
        case 'flag':
          return ascending
              ? a.flag.compareTo(b.flag )
              : b.flag.compareTo(a.flag );
        case 'cFaults':
          return ascending
              ? a.cFaults.compareTo(b.cFaults )
              : b.cFaults.compareTo(a.cFaults );
        default:
          return 0;
      }
    });
  }

}
