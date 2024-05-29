import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import '../../../../../../app_assets/styles/my_images.dart';
import '../../../../../server/api_fetch.dart';
import '../rowing_quality_check_stitching_producntion_models/check_work_order_rate_list_models.dart';

class CheckWorkOrderRateListController extends GetxController {
  final RxList<CheckWorkOrderRateListModel> inLineProductionRateList =
      RxList<CheckWorkOrderRateListModel>();
  final RxBool isLoading = RxBool(true);

  late String workOrder;

  @override
  void onInit() {
    workOrder = Get.arguments['workOrder'];
    getRowingQualityRateList(WorkOrder: workOrder);
    super.onInit();
  }

  Future<void> getRowingQualityRateList({String? WorkOrder}) async {
    isLoading(true);
    String data = "WorkOrder=$WorkOrder";
    inLineProductionRateList.clear();
    List<CheckWorkOrderRateListModel>? responseList =
        await ApiFetch.getRowingQualityWorkOrderRateList(data);
    isLoading(false);
    if (responseList != null) {
      inLineProductionRateList.assignAll(responseList);
    } else {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  Future<Uint8List> generatePdf(PdfPageFormat format, List<CheckWorkOrderRateListModel> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final Uint8List logoBytes = await MyImages.getImageBytes(MyImages.logo);
    final logoImage = pw.MemoryImage(logoBytes);
    const int itemsPerPage = 40;
    final int totalPages = (data.length / itemsPerPage).ceil();

    for (int page = 1; page <= totalPages; page++) {
      final int start = (page - 1) * itemsPerPage;
      final int end = start + itemsPerPage;
      final List<CheckWorkOrderRateListModel> sublist =
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
                        'Work Order Rate List',
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
                          "W/O",
                          "Operation",
                          "Rate",
                          "G-Rate",
                          "Head Name",
                          "Department",
                          "Remarks",
                          "Status",
                          "OP Type"
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
                            sublist[i].woDetails,
                            sublist[i].operationname,
                            sublist[i].rate,
                            sublist[i].gRate.toString(),
                            sublist[i].headname.toString(),
                            sublist[i].department,
                            sublist[i].remarks,
                            sublist[i].status,
                            sublist[i].operationType
                          ])
                            pw.Container(
                              alignment: cellData == sublist[i].operationname ? pw.Alignment.centerLeft : pw.Alignment.center,
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

  String currentSortedProperty = '';
  bool currentAscending = true;
  void sortData(String property, bool ascending) {
    if (currentSortedProperty == property && currentAscending == ascending) {
      ascending = !ascending;
    }
    currentSortedProperty = property;
    currentAscending = ascending;
    inLineProductionRateList.sort((a, b) {
      switch (property) {
        case 'woDetails':
          return ascending
              ? a.woDetails.compareTo(b.woDetails)
              : b.woDetails.compareTo(a.woDetails);
        case 'operationname':
          return ascending
              ? a.operationname.compareTo(b.operationname)
              : b.operationname.compareTo(a.operationname);
        case 'rate':
          return ascending
              ? a.rate.compareTo(b.rate)
              : b.rate.compareTo(a.rate);
        case 'gRate':
          return ascending
              ? a.gRate.compareTo(b.gRate)
              : b.gRate.compareTo(a.gRate);
        case 'headname':
          return ascending
              ? a.headname.compareTo(b.headname)
              : b.headname.compareTo(a.headname);
        case 'department':
          return ascending
              ? a.department.compareTo(b.department)
              : b.department.compareTo(a.department);
        case 'remarks':
          return ascending
              ? a.remarks.compareTo(b.remarks)
              : b.remarks.compareTo(a.remarks);
        case 'status':
          return ascending
              ? a.status.compareTo(b.status)
              : b.status.compareTo(a.status);
        case 'operationType':
          return ascending
              ? a.operationType.compareTo(b.operationType)
              : b.operationType.compareTo(a.operationType);
        default:
          return 0;
      }
    });
  }

}
