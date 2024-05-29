import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../../../app_assets/styles/my_images.dart';
import '../../../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../../server/api_fetch.dart';
import '../../../../../services/preferences.dart';
import '../rowing_quality_check_stitching_producntion_models/rowing_quality_check_operator_production_report_model.dart';

class CheckOperatorQuantityReportController extends GetxController{
  final RxList<RowingQualityCheckOperatorProductionReportListModel> operatorProductionList = RxList<RowingQualityCheckOperatorProductionReportListModel>();
  final Rxn<RowingQualityCheckOperatorProductionReportListModel?> selectedOperator = Rxn<RowingQualityCheckOperatorProductionReportListModel?>();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final RxString selectedLinSection = 'L15'.obs;
  RowingQualityCheckOperatorProductionReportListModel? selected;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  final RxBool isLoading = RxBool(true);
  RxBool autoFilterEnabled = false.obs;
  DateTime dateTime = DateTime.now();
  late int operator;
  late String?  date;

  @override
  void onInit() {
    operator = Get.arguments['operator'];
    date =  Get.arguments['date'];
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    dateController.text = dateFormat.format(dateTime);
    getRowingQualityOperatorProductionReport(Operator: operator, date: date ??  dateController.text);
    super.onInit();
  }

  Future<void> getRowingQualityOperatorProductionReport({int? Operator,  String? date,}) async {
    isLoading(true);
    String data = "optr_code=$Operator&Fromdate=$date&Todate=$date&WorkOrder=&lineNo=";
    operatorProductionList.clear();
    List<RowingQualityCheckOperatorProductionReportListModel>? responseList = await ApiFetch.getRowingQualityOperatorProductionReport(data);
    isLoading(false);
    if (responseList != null) {
      operatorProductionList.assignAll(responseList);
    } else {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
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



  void reverseList() {
    operatorProductionList.assignAll(operatorProductionList.reversed.toList());
  }

  Future<Uint8List> generatePdf(PdfPageFormat format, List<RowingQualityCheckOperatorProductionReportListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 35;
    final int totalPages = (data.length / itemsPerPage).ceil();

    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<RowingQualityCheckOperatorProductionReportListModel> sublist =
      data.sublist(start, end.clamp(0, data.length));

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(),
          orientation: PageOrientation.landscape,
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
                        'Operator Quantity Report',
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
                          "Dat",
                          "Line#",
                          "Operator",
                          "W/O#",
                          "Operation",
                          "Produce Pcs",
                          "Produce Mint",
                          "Flag",
                          "EndLine\nDHU",
                          "Flag Reason",
                        ])
                          pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 8),
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
                            dateFormat.format(DateTime.parse(sublist[i].transactionDate.toString())),
                            sublist[i].lineNo,
                            sublist[i].listOperator,
                            sublist[i].woOrders.toString(),
                            sublist[i].operationname.toString(),
                            sublist[i].producepcs,
                            sublist[i].ageInMinutes,
                            sublist[i].flagShortName.toString().split(',').map((word) => word.trim().substring(0, 1)).join('/'),
                            sublist[i].enlineDhu,
                            sublist[i].flagReason,
                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].operationname ? pw.Alignment.center : pw.Alignment.center,
                              child: pw.Text(
                                cellData.toString(), // Explicitly cast to String
                                style: const pw.TextStyle(fontSize: 8),
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
    await Printing.sharePdf(
        bytes: pdfData, filename: 'Work Order Rate List.pdf');
  }

  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }

  Future<void> autoFilter() async {
    if (autoFilterEnabled.value) {
      await getRowingQualityOperatorProductionReport(
        Operator: operator,
        date: dateController.text,
      );
    } else {
      dateController.clear();
      selectedWorkOrderController.clear();
    }
  }
}