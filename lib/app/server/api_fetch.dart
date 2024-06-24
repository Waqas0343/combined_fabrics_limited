import 'dart:convert';
import 'package:combined_fabrics_limited/app/screens/verify_documents/verify_models/update_app_level.dart';
import 'package:combined_fabrics_limited/app/server/server_config.dart';
import 'package:combined_fabrics_limited/helpers/toaster.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import '../../app_assets/styles/strings/app_constants.dart';
import '../debug/debug_pointer.dart';
import '../screens/complaint_portal/complaint_models/complaint_assignee_model.dart';
import '../screens/complaint_portal/complaint_models/complaint_button_model.dart';
import '../screens/complaint_portal/complaint_models/complaint_chart_model.dart';
import '../screens/complaint_portal/complaint_models/complaint_dashboard.dart';
import '../screens/complaint_portal/complaint_models/complaint_remark_model.dart';
import '../screens/complaint_portal/complaint_models/complaint_status_model.dart';
import '../screens/complaint_portal/complaint_models/get_complaint_by_department_number.dart';
import '../screens/complaint_portal/complaint_models/get_demand_model.dart';
import '../screens/complaint_portal/complaint_models/get_department_complaint_model.dart';
import '../screens/complaint_portal/complaint_models/get_department_model.dart';
import '../screens/complaint_portal/complaint_models/get_employee_by_department_model.dart';
import '../screens/complaint_portal/complaint_models/get_long_name_model.dart';
import '../screens/complaint_portal/complaint_models/get_short_long_name_model.dart';
import '../screens/complaint_portal/complaint_models/get_short_name_assetcode_model.dart';
import '../screens/complaint_portal/complaint_models/get_to_department_model.dart';
import '../screens/fabric_inspection/models/faults_model.dart';
import '../screens/fabric_inspection/models/get_detail_by_roll_model.dart';
import '../screens/fabric_inspection/models/inspection_table_model.dart';
import '../screens/fabric_inspection/models/lot_detail_model.dart';
import '../screens/fabric_inspection/models/lots_model.dart';
import '../screens/fabric_inspection/models/quality_status_model.dart';
import '../screens/fabric_inspection/models/roll_marking_model.dart';
import '../screens/fabric_inspection/models/rolls_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/goods_inspection_notification_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/goods_inspection_other_department_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/goods_inspection_receive_igps_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/igps_detail_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/inpected_igps_list_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/received_igps_list_model.dart';
import '../screens/goods_inspections_note/goods_inspection_models/requested_igps_list_model.dart';
import '../screens/home/model/get_menu_model.dart';
import '../screens/home/model/get_sub_menu_model.dart';
import '../screens/keys_issuance/models/get_master_keys_model.dart';
import '../screens/keys_issuance/models/key_report_model.dart';
import '../screens/keys_issuance/models/key_sub_department_model.dart';
import '../screens/keys_issuance/models/keys_concerned_person_model.dart';
import '../screens/keys_issuance/models/kyes_model.dart';
import '../screens/login_auth/login/login_model.dart';
import '../screens/medical_issuance/medical_issuance_model/medcine_patient_card_model.dart';
import '../screens/medical_issuance/medical_issuance_model/medical_disease_model.dart';
import '../screens/medical_issuance/medical_issuance_model/medicine_first_aid_box_issuance.dart';
import '../screens/medical_issuance/medical_issuance_model/medicine_first_aid_box_model.dart';
import '../screens/medical_issuance/medical_issuance_model/medicine_list_model.dart';
import '../screens/medical_issuance/medical_issuance_model/medicine_stock_model.dart';
import '../screens/medical_issuance/medical_issuance_model/medicines_patient_issuance_model.dart';
import '../screens/rowing_inspection/models/get_rowing_quality_work_order_stitching_dhu_model.dart';
import '../screens/rowing_inspection/models/rowing_end_line_inspector_hourly_report_model.dart';
import '../screens/rowing_inspection/models/rowing_line_production_hourly_model.dart';
import '../screens/rowing_inspection/models/rowing_operator_monthly_flag_detail_report_model.dart';
import '../screens/rowing_inspection/models/rowing_operator_monthly_flag_report_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_Inspector_Activity_Model.dart';
import '../screens/rowing_inspection/models/rowing_quality_Top_fault_without_operation_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_all_faults_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_bundle_detail_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_change_flag_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_dhu_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_employee_stitch_pcs.dart';
import '../screens/rowing_inspection/models/rowing_quality_end_line_bundle_reports.dart';
import '../screens/rowing_inspection/models/rowing_quality_end_line_report_detail_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_end_line_total_pcs_inspect_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_endline_qa_stitching_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_flag_color_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_in_line_flag_with_dhu_report.dart';
import '../screens/rowing_inspection/models/rowing_quality_in_line_status_report_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_fault_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_inline_inspection_form_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_machine_dashboard_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_operation_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_operator_operation_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_rfid_card_scane_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_round_detail_model.dart';
import '../screens/rowing_inspection/models/rowing_quality_top_operation_model.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_producntion_models/check_work_order_rate_list_models.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_producntion_models/rowing_quality_check_operator_production_report_model.dart';
import '../screens/rowing_inspection/rowing_quality_in_line_reports/rowing_quality_check_stitching_production/rowing_quality_check_stitching_producntion_models/rowing_quality_work_order_summary_report_model.dart';
import '../screens/splash/mobile_app_version_model.dart';
import '../screens/verify_documents/verify_models/document_history.dart';
import '../screens/verify_documents/verify_models/next_levels_users.dart';
import '../screens/verify_documents/verify_models/pending_documents_model.dart';
import '../screens/verify_documents/verify_models/verify_doc_dashboard_model.dart';
import '../services/preferences.dart';

class ApiFetch extends getx.GetxService {
  static Dio dio = Dio();

  static Future<String?> login(Map<String, dynamic> data) async {
    Response response;
    try {
      Debug.log(ServerConfig.loginWithToken + data.toString());
      response = await dio.post(
        ServerConfig.loginWithToken,
        data: data,
      );
    } catch (e) {
      Debug.log(e);
      return null;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final loginResponse = LoginModel.fromJson(response.data);
        Debug.log(loginResponse.data);
        Get.snackbar(
          "Message",
          loginResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return loginResponse.data;
      } catch (e) {
        Debug.log(e);
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<LotsListModel>?> getLotsNo(query) async {
    Response response;
    List<LotsListModel>? dataList;
    try {
      Debug.log(ServerConfig.lots + query.toString());
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.lots + query.toString(),
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return dataList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final lotsResponse = LotsModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          lotsResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        dataList = lotsResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return dataList;
  }

  static Future<List<LotDetailModelList>?> getLotsDetail(value) async {
    Response response;
    List<LotDetailModelList>? lotDetailList;
    try {
      Debug.log(ServerConfig.getLotsDetail + value.toString());
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getLotsDetail + value.toString(),
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      Debug.log(e);
      return lotDetailList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final detail = LotDetailModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          detail.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        lotDetailList = detail.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return lotDetailList;
  }

  static Future<List<RollsListModel>?> getRolls(String value) async {
    Response response;
    List<RollsListModel>? inspectedRollsList;
    try {
      Debug.log(ServerConfig.rolls + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.rolls + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return inspectedRollsList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final rollsResponse = RollModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          rollsResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        inspectedRollsList = rollsResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return inspectedRollsList;
  }

  static Future<FaultsModel?> getFaults(String value) async {
    Response response;
    FaultsModel? faultsModel;
    try {
      final url = ServerConfig.faults + value;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return faultsModel;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        faultsModel = FaultsModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          faultsModel.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return faultsModel;
  }

  static Future<bool> saveFaults(List<Map<String, dynamic>> payload) async {
    try {
      const url = ServerConfig.saveFaults;
      Debug.log(ServerConfig.saveFaults + payload.toString());
      Debug.log(payload);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<String> getShiftData() async {
    const url = ServerConfig.getShift;

    try {
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.get(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        final jsonData = response.data as Map<String, dynamic>;
        final String data =
            jsonData['Data'] as String; // Access the value of 'Data'
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      throw Exception('Error: $e');
    }
  }

  static Future<List<InspectionTableList>?> getInspectionTables() async {
    Response response;
    List<InspectionTableList>? tableList;
    try {
      Debug.log(ServerConfig.getInspectionTable);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(ServerConfig.getInspectionTable,
          options: Options(headers: headers));
    } catch (e) {
      Debug.log(e);
      return tableList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final tableResponse = InspectionTable.fromJson(response.data);
        Get.snackbar(
          "Message",
          tableResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        tableList = tableResponse.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return tableList;
  }

  static Future<List<QualityListModel>?> getQualityStatus() async {
    Response response;
    List<QualityListModel>? qualityList;
    try {
      Debug.log(ServerConfig.getQualityStatus);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getQualityStatus,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      Debug.log(e);
      return qualityList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final qualityResponse = QualityModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          qualityResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        qualityList = qualityResponse.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return qualityList;
  }

  static Future<List<RollMarkingStatusList>?> getRollMarkingStatus() async {
    Response response;
    List<RollMarkingStatusList>? rollMarkingList;
    try {
      Debug.log(ServerConfig.getRollMarkingStatus);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getRollMarkingStatus,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e) {
      Debug.log(e);
      return rollMarkingList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final rollMarkingResponse = RollMarkingModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          rollMarkingResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        rollMarkingList = rollMarkingResponse.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return rollMarkingList;
  }

  static Future<RollDetailModelData?> getDetailByRoll(params) async {
    Response response;
    RollDetailModelData? rollDetail;
    try {
      Debug.log(ServerConfig.getDetailByRoll + params);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getDetailByRoll + params,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return rollDetail;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final rollResponse = RollDetailModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          rollResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        rollDetail = rollResponse.data;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return rollDetail;
  }

  static Future<bool> saveFaultsFormData(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.saveFaultsFormData + json.encode(data));
      const url = ServerConfig.saveFaultsFormData;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json", // Set content type
      };
      Debug.log(data);
      final response = await dio.post(
        url,
        data: json.encode(data),
        options: Options(headers: headers),
      );

      Debug.log(json.encode(data));

      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false; // Return false indicating failure
    }
  }

  static Future<List<DepartmentListModel>?> getDepartments(value) async {
    Response response;
    List<DepartmentListModel>? departmentList;
    try {
      Debug.log(ServerConfig.getDepartments + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getDepartments + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return departmentList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final department = GetDepartmentModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          department.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        departmentList = department.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return departmentList;
  }

  static Future<List<ToDepartmentListModel>?> getToDepartments() async {
    Response response;
    List<ToDepartmentListModel>? toDepartmentList;
    try {
      Debug.log(ServerConfig.getToDepartments);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getToDepartments,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return toDepartmentList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final toDepartment = ToDepartmentModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          toDepartment.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        toDepartmentList = toDepartment.data;
      } catch (e) {
        Debug.log(e);
      }
    }

    return toDepartmentList;
  }

  static Future<List<ShortNameAssetCodeListModel>?> getShortNameAssetCodes(
      value) async {
    Response response;
    List<ShortNameAssetCodeListModel>? shortNameList;
    try {
      Debug.log(ServerConfig.getShortNameAssetCode + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getShortNameAssetCode + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return shortNameList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final shortName = ShortNameAssetCodeModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          shortName.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        shortNameList = shortName.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return shortNameList;
  }

  static Future<List<LongNameModelList>?> getLongNameAssetCodes(value) async {
    Response response;
    List<LongNameModelList>? longNameList;
    try {
      Debug.log(ServerConfig.getLongNameAssetCode + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getLongNameAssetCode + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return longNameList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final longName = LongNameModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          longName.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        longNameList = longName.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return longNameList;
  }

  static Future<AssetCodeModel?> getAssetCodeByShortLongName(params) async {
    Response response;
    AssetCodeModel? assetCode;
    try {
      Debug.log(ServerConfig.getShortLongNameByAssetCode + params);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getShortLongNameByAssetCode + params,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return assetCode;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final shortLongNameAsset =
            ShortNameLongNameAssetModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          shortLongNameAsset.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (shortLongNameAsset.status) {
          assetCode = shortLongNameAsset.data;
        }
      } catch (e) {
        Debug.log(e);
      }
    }

    return assetCode;
  }

  static Future<List<ComplaintStatusListModel>?> getComplaintStatusList(
      query) async {
    Response response;
    List<ComplaintStatusListModel>? dataList;
    try {
      Debug.log(ServerConfig.getComplaintStatus + query.toString());
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getComplaintStatus + query.toString(),
        options: Options(headers: headers),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return dataList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final compliantStatus = ComplaintStatusModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          compliantStatus.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        dataList = compliantStatus.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return dataList;
  }

  static Future<List<DepartmentComplaintListModel>?> getDepartmentComplaintList(
      Map<String, dynamic> queryParams) async {
    Response response;
    List<DepartmentComplaintListModel>? dataList;
    try {
      String encodedQuery = Uri.encodeQueryComponent(jsonEncode(queryParams));
      Debug.log(encodedQuery);
      String apiUrl =
          "${ServerConfig.getDepartmentComplaint}filter=$encodedQuery";
      Debug.log(apiUrl);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        apiUrl,
        options: Options(headers: headers),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return dataList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final compliantList = DepartmentComplaintModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          compliantList.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        dataList = compliantList.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return dataList;
  }

  static Future<bool> saveComplaintData(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.submitComplaint + json.encode(data));
      const url = ServerConfig.submitComplaint;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false; // Return false indicating failure
    }
  }

  static Future<List<EmployeeByDepartmentListModel>?> getEmployeeByDept(
      value) async {
    Response response;
    List<EmployeeByDepartmentListModel>? employeeByDept;
    try {
      Debug.log(ServerConfig.getEmployeeByDept + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getEmployeeByDept + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return employeeByDept;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final employeeName = EmployeeByDepartmentModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          employeeName.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        employeeByDept = employeeName.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return employeeByDept;
  }

  static Future<List<ComplaintAssigneeListModel>?> getAssigneePerson(
      value) async {
    Response response;
    List<ComplaintAssigneeListModel>? assignee;
    try {
      Debug.log(ServerConfig.complaintAssigneePerson + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.complaintAssigneePerson + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return assignee;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());

      try {
        final assigneeName = ComplaintAssigneeModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          assigneeName.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        assignee = assigneeName.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return assignee;
  }

  static Future<bool> removeAssignee(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.removeAssigneePerson + json.encode(data));
      const url = ServerConfig.removeAssigneePerson;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> addAssignee(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.addAssigneePerson + json.encode(data));
      const url = ServerConfig.addAssigneePerson;
      Debug.log(url);

      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> changeDepartment(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.changeDepartment + json.encode(data));
      const url = ServerConfig.changeDepartment;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> setPlanDate(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.setPlanDate + json.encode(data));
      const url = ServerConfig.setPlanDate;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> setActualDate(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.setActualDate + json.encode(data));
      const url = ServerConfig.setActualDate;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false; // Return false indicating failure
    }
  }

  static Future<List<ComplaintRemarkListModel>?> getComplaintRemark(
      value) async {
    Response response;
    List<ComplaintRemarkListModel>? remark;
    try {
      Debug.log(ServerConfig.complaintRemark + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.complaintRemark + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return remark;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final remarks = ComplaintRemarksModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          remarks.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        remark = remarks.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return remark;
  }

  static Future<bool> closeComplaint(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.closeComplaint + json.encode(data));
      const url = ServerConfig.closeComplaint;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false; // Return false indicating failure
    }
  }

  static Future<bool> resolveComplaint(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.resolveComplaint + json.encode(data));
      const url = ServerConfig.resolveComplaint;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> complaintReject(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.complaintReject + json.encode(data));
      const url = ServerConfig.complaintReject;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> complaintVerify(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.complaintVerify + json.encode(data));
      const url = ServerConfig.complaintVerify;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<ComplaintChartListModel>?> getComplaintChartData(
      value) async {
    Response response;
    List<ComplaintChartListModel>? chart;

    try {
      Debug.log(ServerConfig.complaintChartData + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.complaintChartData + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return chart;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final chartData = ComplaintChartModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          chartData.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        chart = chartData.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return chart;
  }

  static Future<bool> changeComplaintStatus(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.changeStatusToAcknowledge + json.encode(data));
      const url = ServerConfig.changeStatusToAcknowledge;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<ComplaintButtonData?> getComplaintButtonAction(params) async {
    ComplaintButtonData? buttonAction;
    try {
      String apiUrl = ServerConfig.changeComplaintButton + params;
      Debug.log(apiUrl);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.get(
        apiUrl,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        try {
          final rollResponse = ComplaintButtonData.fromJson(response.data);

          buttonAction = rollResponse;
        } catch (e, s) {
          Debug.log(e);
          Debug.log(s);
        }
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
    }

    return buttonAction;
  }

  static Future<GetComplaintByNoDataModel?> getComplaintByCMPNO(params) async {
    Response response;
    GetComplaintByNoDataModel? complaintbyCMPNo;
    try {
      Debug.log(ServerConfig.getComplaintByCMPNO + params);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getComplaintByCMPNO + params,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return complaintbyCMPNo;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final complaintResponse = GetComplaintByNoModel.fromJson(response.data);

        complaintbyCMPNo = complaintResponse.data;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return complaintbyCMPNo;
  }

  static Future<ComplaintDashBoardDataModel?> getComplaintDashBoard() async {
    Response response;
    ComplaintDashBoardDataModel? complaintDashboard;

    try {
      const String url = ServerConfig.getComplaintDashBoard;
      Debug.log(url);

      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return complaintDashboard;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final complaintResponse =
            ComplaintDashBoardModel.fromJson(response.data);
        complaintDashboard = complaintResponse.data;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return complaintDashboard;
  }

  static Future<List<DemandListModel>?> getComplaintDemand(value) async {
    Response response;
    List<DemandListModel>? complaintDemand;
    try {
      Debug.log(ServerConfig.getDemand + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getDemand + value,
        options: Options(headers: headers),
      );
    } catch (e) {
      Debug.log(e);
      return complaintDemand;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final remarks = DemandModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          remarks.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        complaintDemand = remarks.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return complaintDemand;
  }

  static Future<bool> changeComplaintDemandStatus(
      Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.changeDemandStatus + json.encode(data));
      const url = ServerConfig.changeDemandStatus;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> addComplaintDemand(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.addComplaintDemand + json.encode(data));
      const url = ServerConfig.addComplaintDemand;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<ReceivedIGPListModel>?> getReceivedIGpListIGpsList(
      value) async {
    Response response;
    List<ReceivedIGPListModel>? igpList;
    try {
      Debug.log(ServerConfig.getReceivedIGPNo + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getReceivedIGPNo + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return igpList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final receiveResponse = PendingIGPNoModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          receiveResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        igpList = receiveResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return igpList;
  }

  static Future<List<RequestedIGPSListModel>?> getRequestedIGpListIGpsList(
      value) async {
    Response response;
    List<RequestedIGPSListModel>? requestedIgpList;
    try {
      Debug.log(ServerConfig.getRequestedIGPNo + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getRequestedIGPNo + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return requestedIgpList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final requestedResponse = RequestedIGPSModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          requestedResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        requestedIgpList = requestedResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return requestedIgpList;
  }

  static Future<List<InspectedIGPListModel>?> getInspectedIGpListIGpsList(
      value) async {
    Response response;
    List<InspectedIGPListModel>? inspectedIgpList;
    try {
      Debug.log(ServerConfig.getInspectedIGPNo + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getInspectedIGPNo + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return inspectedIgpList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final lotsResponse = InspectedIGPModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          lotsResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        inspectedIgpList = lotsResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return inspectedIgpList;
  }

  static Future<List<IGPDetailListModel>?> getPendingIGpsDetail(value) async {
    Response response;
    List<IGPDetailListModel>? igpList;
    try {
      Debug.log(ServerConfig.getIGPnODetail + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getIGPnODetail + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return igpList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final lotsResponse = IGPDetailModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          lotsResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        igpList = lotsResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return igpList;
  }

  static Future<bool> sendIGPDRequest(
      List<Map<String, dynamic>> payload) async {
    try {
      Debug.log(ServerConfig.sendIGPRequest + payload.toString());
      const url = ServerConfig.sendIGPRequest;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json", // Set content type
      };
      Debug.log(payload);
      final response = await dio.post(
        url,
        data: json.encode(payload),
        options: Options(headers: headers),
      );

      Debug.log(json.encode(payload));

      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false; // Return false indicating failure
    }
  }

  static Future<List<NotificationListModel>?> getNotificationRequest(
      value) async {
    Response response;
    List<NotificationListModel>? notificationList;
    try {
      Debug.log(ServerConfig.getIGPRequest + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getIGPRequest + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return notificationList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final lotsResponse = NotificationModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          lotsResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        notificationList = lotsResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return notificationList;
  }

  static Future<bool> addGoodsInspectionFormData(
      Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.addIGPFormData + json.encode(data));
      const url = ServerConfig.addIGPFormData;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<GoodsInspectionOtherDepartmentListModel>?>
      getOtherDepartmentInGoodInspection() async {
    Response response;
    List<GoodsInspectionOtherDepartmentListModel>? otherDepartmentList;
    try {
      Debug.log(ServerConfig.getOtherDepartmentInGoodInspection);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(ServerConfig.getOtherDepartmentInGoodInspection,
          options: Options(headers: headers));
    } catch (e) {
      Debug.log(e);
      return otherDepartmentList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final otherResponse =
            GoodsInspectionOtherDepartmentModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          otherResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        otherDepartmentList = otherResponse.list;
      } catch (e) {
        Debug.log(e);
      }
    }

    return otherDepartmentList;
  }

  static Future<List<ReceiveIGPListModel>?> getReceiveIGPList(value) async {
    Response response;
    List<ReceiveIGPListModel>? receiveIGPList;
    try {
      Debug.log(ServerConfig.getReceiveIGPList + value);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      response = await dio.get(
        ServerConfig.getReceiveIGPList + value,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return receiveIGPList;
    }
    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final lotsResponse = ReceiveIGPModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          lotsResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        receiveIGPList = lotsResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return receiveIGPList;
  }

  static Future<bool> receiveIGP(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.receiveIGP + json.encode(data));
      const url = ServerConfig.receiveIGP;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<KeyDashBoardModel?> getKeysList(String value) async {
    Response response;
    KeyDashBoardModel? keysList;
    try {
      Debug.log(ServerConfig.keysAndDashBoardDetail + value);
      String url = ServerConfig.keysAndDashBoardDetail + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return keysList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = KeysModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        keysList = keysResponse.data;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return keysList;
  }

  static Future<bool> keysIssuanceAndReturn(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.keysIssuance + json.encode(data));
      const url = ServerConfig.keysIssuance;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<MasterKeysListModel>?> getMasterKeysList(
      String params) async {
    Response response;
    List<MasterKeysListModel>? masterKeysList;
    try {
      Debug.log(ServerConfig.masterKeysList + params);
      String url = ServerConfig.masterKeysList + params;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return masterKeysList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = MasterKeysModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        masterKeysList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return masterKeysList;
  }

  static Future<bool> addKeyByMaster(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.addMasterKeys + json.encode(data));
      const url = ServerConfig.addMasterKeys;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> deleteKey(data) async {
    try {
      Debug.log(ServerConfig.deleteMasterKeys + data);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.delete(
        ServerConfig.deleteMasterKeys + data,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> updateKeyByMaster(Map<String, dynamic> data) async {
    try {
      Debug.log(ServerConfig.updateMasterKeys + json.encode(data));
      const url = ServerConfig.updateMasterKeys;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: json.encode(data),
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<MedicineListModel>?> getMedicinesList() async {
    Response response;
    List<MedicineListModel>? medicineList;
    try {
      Debug.log(ServerConfig.getMedicineList);
      String url = ServerConfig.getMedicineList;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return medicineList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = MedicineModel.fromJson(response.data);
        medicineList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return medicineList;
  }

  static Future<bool> medicineIssue(Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.medicinesIssue;
      Debug.log(ServerConfig.medicinesIssue + payload.toString());
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<PatientListModel>?> getPatientMedicineList(value) async {
    Response response;
    List<PatientListModel>? medicineList;

    try {
      Debug.log(ServerConfig.getPatientMedicinesIssuanceList + value);
      String url = ServerConfig.getPatientMedicinesIssuanceList + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return medicineList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final medicineModel = PatientModel.fromJson(response.data);
        medicineList = medicineModel.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return medicineList;
  }

  static Future<List<FirstAidBoxMedicineIssuanceListModel>?>
      getFirstAidMedicineList(value) async {
    Response response;
    List<FirstAidBoxMedicineIssuanceListModel>? medicineList;

    try {
      Debug.log(ServerConfig.getFirstAidBoxIssuance + value);
      String url = ServerConfig.getFirstAidBoxIssuance + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return medicineList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final medicineModel =
            FirstAidBoxMedicineIssuanceModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          medicineModel.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        medicineList = medicineModel.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return medicineList;
  }

  static Future<bool> igpReverseBack(data) async {
    try {
      Debug.log(ServerConfig.reverseBackIGP + data);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.put(
        ServerConfig.reverseBackIGP + data,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<MenuModelList>?> getMenuForUser(params) async {
    Response response;
    List<MenuModelList>? menuList;
    try {
      Debug.log(ServerConfig.getMenu + params);
      String url = ServerConfig.getMenu + params;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return menuList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final medicineModel = MenuModel.fromJson(response.data);
        menuList = medicineModel.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return menuList;
  }

  static Future<List<SubMenuModelList>?> getSubMenuForUser(params) async {
    Response response;
    List<SubMenuModelList>? subMenuList;

    try {
      Debug.log(ServerConfig.getSubMenu + params);
      String url = ServerConfig.getSubMenu + params;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return subMenuList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final medicineModel = SubMenuModel.fromJson(response.data);
        subMenuList = medicineModel.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return subMenuList;
  }

  static Future<PatientCardDataModel?> getPatientCardNo(String value) async {
    Response response;
    PatientCardDataModel? complaintDashboard;

    try {
      String url = ServerConfig.getPatientCardNo + value;
      Debug.log(url);

      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return complaintDashboard;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final complaintResponse = PatientCardModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          complaintResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        complaintDashboard = complaintResponse.data;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return complaintDashboard;
  }

  static Future<bool> addKeyWeekDays(payload) async {
    try {
      Debug.log(ServerConfig.saveKeyTimeTable + payload.toString());
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      Response response = await dio.post(
        ServerConfig.saveKeyTimeTable,
        data: payload,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Toaster.showToast("${response.statusMessage}");
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<KeyConcernedPersonListModel>?> getKeysConcernedPersonList(
      value) async {
    Response response;
    List<KeyConcernedPersonListModel>? concernedPersonList;

    try {
      Debug.log(ServerConfig.getKeyConcernedPerson + value);
      String url = ServerConfig.getKeyConcernedPerson + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return concernedPersonList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final medicineModel = KeyConcernedPersonModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          medicineModel.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        concernedPersonList = medicineModel.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return concernedPersonList;
  }

  static Future<bool> saveKeyTimeTable(payload) async {
    try {
      Debug.log(ServerConfig.saveKeyTimeTable + payload.toString());
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      Response response = await dio.post(
        ServerConfig.saveKeyTimeTable,
        data: payload, // Send payload as the data in the request body
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Toaster.showToast("${response.statusMessage}");
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<DiseaseListModel>?> getDiseaseList() async {
    Response response;
    List<DiseaseListModel>? diseaseList;
    try {
      Debug.log(ServerConfig.getDiseaseName);
      String url = ServerConfig.getDiseaseName;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return diseaseList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = DiseaseModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        diseaseList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return diseaseList;
  }

  static Future<bool> saveNewDiseaseName(data) async {
    try {
      Debug.log(ServerConfig.addDiseaseName + data);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.post(
        ServerConfig.addDiseaseName + data,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<KeyReportListModel>?> getKeyReports(value) async {
    Response response;
    List<KeyReportListModel>? reportList;
    try {
      Debug.log(ServerConfig.getKeyReports + value);
      String url = ServerConfig.getKeyReports + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reportList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = KeyReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reportList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return reportList;
  }

  static Future<List<MedicineStockListModel>?> getMedicineStockList(
      value) async {
    Response response;
    List<MedicineStockListModel>? stockList;
    try {
      Debug.log(ServerConfig.getMedicineStock + value);
      String url = ServerConfig.getMedicineStock + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return stockList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final stockResponse = MedicineStockModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          stockResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        stockList = stockResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return stockList;
  }

  static Future<List<FirstAidBoxListModel>?> getFirstAidBoxList() async {
    Response response;
    List<FirstAidBoxListModel>? boxesList;
    try {
      Debug.log(ServerConfig.getFirstAidBox);
      String url = ServerConfig.getFirstAidBox;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return boxesList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final boxesResponse = FirstAidBoxModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          boxesResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        boxesList = boxesResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return boxesList;
  }

  static Future<bool> saveNewFirstAidBox(data) async {
    try {
      Debug.log(ServerConfig.addFirstAidBox + data);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.post(
        ServerConfig.addFirstAidBox + data,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<SubDepartmentListModel>?> getKeySubDepartment() async {
    Response response;
    List<SubDepartmentListModel>? subDepartmentList;
    try {
      Debug.log(ServerConfig.getKeySubDepartment);
      String url = ServerConfig.getKeySubDepartment;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return subDepartmentList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = SubDepartmentModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        subDepartmentList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return subDepartmentList;
  }

  static Future<bool> saveNewSubDepartmentName(data) async {
    try {
      Debug.log(ServerConfig.addSubDepartment + data);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.post(
        ServerConfig.addSubDepartment + data,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<RowingQualityFaultListModel>?>
      getRowingQualityFaultList() async {
    Response response;
    List<RowingQualityFaultListModel>? faultList;
    try {
      Debug.log(ServerConfig.rowingQualityFault);
      String url = ServerConfig.rowingQualityFault;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return faultList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final faultListResponse =
            RowingQualityFaultModel.fromJson(response.data);
        Toaster.showToast(
          faultListResponse.message,
        );
        faultList = faultListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return faultList;
  }

  static Future<bool> saveNewRowingFaultName(data) async {
    try {
      Debug.log(ServerConfig.addQualityFault + data);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      Response response = await dio.post(
        ServerConfig.addQualityFault + data,
        options: Options(headers: headers),
      );

      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<RowingQualityInlineInspectionFormListModel>?>
      getRowingQualityInlineInspectionFormList(param) async {
    Response response;
    List<RowingQualityInlineInspectionFormListModel>? inLineList;
    try {
      Debug.log(ServerConfig.rowingQualityInspectionForm + param);
      String url = ServerConfig.rowingQualityInspectionForm + param;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return inLineList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final inLineListResponse =
            RowingQualityInlineInspectionFormModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          inLineListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        inLineList = inLineListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return inLineList;
  }

  static Future<List<RowingQualityOperatorOperationListModel>?>
      getRowingQualityOperationList(params) async {
    Response response;
    List<RowingQualityOperatorOperationListModel>? operationList;
    try {
      Debug.log(ServerConfig.rowingQualityWorkerOperation + params);
      String url = ServerConfig.rowingQualityWorkerOperation + params;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return operationList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            RowingQualityOperatorOperationModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        operationList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return operationList;
  }

  static Future<Map<String, dynamic>?> saveRowingQualityDetail(
      Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.addRowingQualityMasterDetail;
      Debug.log(ServerConfig.addRowingQualityMasterDetail + payload.toString());
      Debug.log(payload);

      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return response.data; // Return the entire response data
      } else {
        return null; // Return null in case of non-200 status code
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return null; // Return null in case of an exception
    }
  }

  static Future<bool> saveRowingQualityFaultDetail(
      Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.addRowingQualityFaultDetail;
      Debug.log(ServerConfig.addRowingQualityFaultDetail + payload.toString());
      Debug.log(payload);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> saveRowingQualityInspectionFlag(
      Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.addRowingQualityInspectionFlag;
      Debug.log(
          ServerConfig.addRowingQualityInspectionFlag + payload.toString());
      Debug.log(payload);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<RowingQualityMachineDashboardListModel>?>
      getRowingQualityDashBoardMachine(String value) async {
    Response response;
    List<RowingQualityMachineDashboardListModel>? machineFlagList;
    try {
      Debug.log(ServerConfig.getRowingQualityDashboardMachineWithFlag + value);
      String url =
          ServerConfig.getRowingQualityDashboardMachineWithFlag + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return machineFlagList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            RowingQualityMachineDashboardModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        machineFlagList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return machineFlagList;
  }

  static Future<List<FlagColorListModel>?> getRowingQualityFlagColor() async {
    Response response;
    List<FlagColorListModel>? flagColorList;
    try {
      Debug.log(ServerConfig.getRowingQualityFlagColor);
      String url = ServerConfig.getRowingQualityFlagColor;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return flagColorList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse = FlagColorModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        flagColorList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return flagColorList;
  }

  static Future<List<InLineStatusReportListModel>?>
      getRowingQualityInLineStatusReport(data) async {
    Response response;
    List<InLineStatusReportListModel>? inLineStatusList;
    try {
      Debug.log(ServerConfig.getRowingQualityInLineStatusReport + data);
      String url = ServerConfig.getRowingQualityInLineStatusReport + data;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return inLineStatusList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            InLineStatusReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        inLineStatusList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return inLineStatusList;
  }

  static Future<bool> changeMachineFlagUpdate(params) async {
    try {
      Debug.log(ServerConfig.saveMachineFlagUpdate + params);
      String url = ServerConfig.saveMachineFlagUpdate + params;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.put(
        url,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<RowingQualityEmployeeStitchPcsListModel>?>
      getRowingQualityEmployeeStitchPcs(data) async {
    Response response;
    List<RowingQualityEmployeeStitchPcsListModel>? pcsList;
    try {
      Debug.log(ServerConfig.getEmployeeStitchPcs + data);
      String url = ServerConfig.getEmployeeStitchPcs + data;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return pcsList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            RowingQualityEmployeeStitchPcsModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        pcsList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return pcsList;
  }

  static Future<Map<String, dynamic>?> saveRowingQualityEndLineMasterForm(
      Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.saveRowingQualityEndLineMasterForm;
      Debug.log(
          ServerConfig.saveRowingQualityEndLineMasterForm + payload.toString());
      Debug.log(payload);

      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return response.data;
      } else {
        return null;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return null;
    }
  }

  static Future<bool> saveRowingQualityEndLineGarmentFault(
      Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.addRowingQualityFaultPerGarments;
      Debug.log(
          ServerConfig.addRowingQualityFaultPerGarments + payload.toString());
      Debug.log(payload);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<bool> rowingQualitySkipGarmentInspection(param) async {
    try {
      Debug.log(ServerConfig.rowingQualitySkipGarmentInspection + param);
      String url = ServerConfig.rowingQualitySkipGarmentInspection + param;
      Debug.log(url);
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dio.post(
        url,
        options: Options(headers: headers),
      );
      Debug.log(response);
      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return false;
    }
  }

  static Future<List<RowingQualityBundleListModel>?>
      getRowingQualityBundleDetail(params) async {
    Response response;
    List<RowingQualityBundleListModel>? operationList;
    try {
      Debug.log(ServerConfig.rowingQualityBundleDetail + params);
      String url = ServerConfig.rowingQualityBundleDetail + params;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return operationList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            RowingQualityBundleModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        operationList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return operationList;
  }

  static Future<List<RowingQualityDHUListModel>?> getRowingQualityDHUDetail(
      data) async {
    Response response;
    List<RowingQualityDHUListModel>? operationList;
    try {
      Debug.log(ServerConfig.rowingQualityGetDHUDetail + data);
      String url = ServerConfig.rowingQualityGetDHUDetail + data;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return operationList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            RowingQualityDHUModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        operationList = operationListResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return operationList;
  }

  static Future<List<RowingQualityRoundDetailListModel>?>
      getRowingQualityRoundDetail(data) async {
    Response response;
    List<RowingQualityRoundDetailListModel>? roundList;
    try {
      Debug.log(ServerConfig.rowingQualityGetRoundDetail + data);
      String url = ServerConfig.rowingQualityGetRoundDetail + data;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return roundList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final operationListResponse =
            RowingQualityRoundDetailModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          operationListResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        roundList = operationListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return roundList;
  }

  static Future<List<InspectorActivityListModel>?>
      getRowingInspectorActivityDetail(value) async {
    Response response;
    List<InspectorActivityListModel>? activityList;
    try {
      Debug.log(ServerConfig.rowingQualityInspectorActivityDetail + value);
      String url = ServerConfig.rowingQualityInspectorActivityDetail + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return activityList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = InspectorActivityModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        activityList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return activityList;
  }

  static Future<List<EndLineBundleReportsListModel>?>
      getRowingEndLineBundleReports(value) async {
    Response response;
    List<EndLineBundleReportsListModel>? bundleList;
    try {
      Debug.log(ServerConfig.rowingQualityEndLineBundleReports + value);
      String url = ServerConfig.rowingQualityEndLineBundleReports + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return bundleList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = EndLineBundleReportsModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        bundleList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return bundleList;
  }

  static Future<List<RowingQualityOperationListModel>?> getRowingOperationList(
      value) async {
    Response response;
    List<RowingQualityOperationListModel>? bundleList;
    try {
      Debug.log(ServerConfig.rowingQualityOperationList + value);
      String url = ServerConfig.rowingQualityOperationList + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return bundleList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityOperationModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        bundleList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return bundleList;
  }

  static Future<List<RowingQualityReportDetailListModel>?>
      getRowingEndLineReportsDetail(value) async {
    Response response;
    List<RowingQualityReportDetailListModel>? reportList;
    try {
      Debug.log(ServerConfig.rowingQualityEndLineReportDetail + value);
      String url = ServerConfig.rowingQualityEndLineReportDetail + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reportList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityReportDetailModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reportList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return reportList;
  }

  static Future<List<RowingQualityEndLineTotalPcsInspectListModel>?>
      getRowingEndLineTotalPcsInspect(value) async {
    Response response;
    List<RowingQualityEndLineTotalPcsInspectListModel>? pcsList;
    try {
      Debug.log(
          ServerConfig.rowingQualityEndLineGetTotalPcsStitchWorkOrderWise +
              value);
      String url =
          ServerConfig.rowingQualityEndLineGetTotalPcsStitchWorkOrderWise +
              value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return pcsList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityEndLineTotalPcsInspectModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        pcsList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return pcsList;
  }

  static Future<List<RowingQualityInLineFlagWithDHUListModel>?>
      getRowingQualityFlagWithDhuReport(value) async {
    Response response;
    List<RowingQualityInLineFlagWithDHUListModel>? pcsList;
    try {
      Debug.log(ServerConfig.rowingQualityInLineFlagReportWithDHU + value);
      String url = ServerConfig.rowingQualityInLineFlagReportWithDHU + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return pcsList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityInLineFlagWithDHUModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        pcsList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return pcsList;
  }

  static Future<List<EndLineInspectorHourlyReportListModel>?>
      getRowingQualityInspectorHourlyReport(value) async {
    Response response;
    List<EndLineInspectorHourlyReportListModel>? hourlyList;
    try {
      Debug.log(ServerConfig.rowingQualityEndLineInspectorHourlyReport + value);
      String url =
          ServerConfig.rowingQualityEndLineInspectorHourlyReport + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return hourlyList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            EndLineInspectorHourlyReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        hourlyList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return hourlyList;
  }

  static Future<List<InLineInspectorMonthlyFlagReportListModel>?>
      getRowingQualityOperatorMonthlyFlagReport(value) async {
    Response response;
    List<InLineInspectorMonthlyFlagReportListModel>? hourlyList;
    try {
      Debug.log(ServerConfig.rowingQualityEndLineOperatorMonthlyReport + value);
      String url =
          ServerConfig.rowingQualityEndLineOperatorMonthlyReport + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return hourlyList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            InLineInspectorMonthlyFlagReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        hourlyList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return hourlyList;
  }

  static Future<List<InLineInspectorMonthlyFlagDetailReportListModel>?>
      getRowingQualityOperatorMonthlyFlagDetailReport(value) async {
    Response response;
    List<InLineInspectorMonthlyFlagDetailReportListModel>? hourlyList;
    try {
      Debug.log(
          ServerConfig.rowingQualityEndLineOperatorMonthlyDetailReport + value);
      String url =
          ServerConfig.rowingQualityEndLineOperatorMonthlyDetailReport + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return hourlyList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            InLineInspectorMonthlyFlagDetailReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        hourlyList = keysResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return hourlyList;
  }

  static Future<List<EndLineQAStitchingReportListModel>?>
      getRowingQualityEndLineQAStitchingReport(String value) async {
    try {
      Debug.log(ServerConfig.rowingQualityEndLineQAStitchingReport + value);
      String url = ServerConfig.rowingQualityEndLineQAStitchingReport + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      Response response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        EndLineQAStitchingReportModel keysResponse =
            EndLineQAStitchingReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        return keysResponse.lists;
      } else {
        Debug.log('Error: ${response.statusCode}');
        return null;
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return null;
    }
  }

  static Future<List<InLineProductionHourlyReportListModel>?>
      getRowingQualityInLineProductionReport(value) async {
    Response response;
    List<InLineProductionHourlyReportListModel>? stitchingQAList;
    try {
      Debug.log(ServerConfig.rowingQualityInLineProductionHourlyReport + value);
      String url =
          ServerConfig.rowingQualityInLineProductionHourlyReport + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return stitchingQAList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            InLineProductionHourlyReportModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        stitchingQAList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return stitchingQAList;
  }

  static Future<List<CheckWorkOrderRateListModel>?>
      getRowingQualityWorkOrderRateList(value) async {
    Response response;
    List<CheckWorkOrderRateListModel>? rateList;
    try {
      Debug.log(ServerConfig.rowingQualityCheckWorkOrderRateList + value);
      String url = ServerConfig.rowingQualityCheckWorkOrderRateList + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return rateList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = CheckWorkOrderRateModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        rateList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }

    return rateList;
  }

  static Future<List<RowingQualityWorkOrderSummaryListModel>?>
      getRowingQualityWorkOrderSummaryReport(value) async {
    Response response;
    List<RowingQualityWorkOrderSummaryListModel>? rateList;
    try {
      Debug.log(ServerConfig.rowingQualityCheckWorkOrderSummaryReport + value);
      String url =
          ServerConfig.rowingQualityCheckWorkOrderSummaryReport + value;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return rateList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityWorkOrderSummaryModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        rateList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return rateList;
  }

  static Future<List<RowingQualityAllFaultsListModel>?>
      getRowingQualityAllFaultList() async {
    Response response;
    List<RowingQualityAllFaultsListModel>? faultList;
    try {
      Debug.log(ServerConfig.rowingQualityGetAllFaults);
      String url = ServerConfig.rowingQualityGetAllFaults;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return faultList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final faultListResponse =
            RowingQualityAllFaultsModel.fromJson(response.data);
        Toaster.showToast(
          faultListResponse.message,
        );
        faultList = faultListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return faultList;
  }

  static Future<List<MobileVersionListModel>?> getMobileAppVersionList() async {
    Response response;
    List<MobileVersionListModel>? versionList;
    try {
      Debug.log(ServerConfig.getMobileVersion);
      String url = ServerConfig.getMobileVersion;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return versionList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final faultListResponse = MobileVersionModel.fromJson(response.data);
        Toaster.showToast(
          faultListResponse.message,
        );
        versionList = faultListResponse.list;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return versionList;
  }

  static Future<Map<String, dynamic>?> saveNewMobileVersion(
      Map<String, dynamic> payload) async {
    try {
      const url = ServerConfig.addMobileVersion;
      Debug.log(ServerConfig.addMobileVersion + payload.toString());
      Debug.log(payload);

      String token = Get.find<Preferences>().getString(Keys.token) ?? "";
      final headers = {
        "Authorization": "Bearer $token",
      };

      final response = await dio.post(
        url,
        data: payload,
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        Debug.log(response.data.toString());
        return response.data; // Return the entire response data
      } else {
        return null; // Return null in case of non-200 status code
      }
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return null; // Return null in case of an exception
    }
  }

  static Future<List<ChangeFlagReasonListModel>?>
      getRowingQualityChangeFlgReason() async {
    Response response;
    List<ChangeFlagReasonListModel>? reasonList;
    try {
      Debug.log(ServerConfig.rowingQualityChangeFlagReason);
      String url = ServerConfig.rowingQualityChangeFlagReason;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reasonList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = ChangeFlagReasonModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reasonList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return reasonList;
  }

  static Future<List<WorkOrderProductionStitchingListModel>?>
      getRowingQualityWorkOrderProductionStitchingReport(date) async {
    Response response;
    List<WorkOrderProductionStitchingListModel>? reasonList;
    try {
      Debug.log(
          ServerConfig.rowingQualityWorkOrderProductionStitchingReport + date);
      String url =
          ServerConfig.rowingQualityWorkOrderProductionStitchingReport + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reasonList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            WorkOrderProductionStitchingModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reasonList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return reasonList;
  }

  static Future<List<RowingQualityCheckOperatorProductionReportListModel>?>
      getRowingQualityOperatorProductionReport(date) async {
    Response response;
    List<RowingQualityCheckOperatorProductionReportListModel>? reasonList;
    try {
      Debug.log(ServerConfig.rowingQualityOperatorProductiongReport + date);
      String url = ServerConfig.rowingQualityOperatorProductiongReport + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reasonList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityCheckOperatorProductionReportModel.fromJson(
                response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reasonList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return reasonList;
  }

  static Future<List<RowingQualityTopOperationListModel>?>
      getRowingQualityTopOperatorReport(date) async {
    Response response;
    List<RowingQualityTopOperationListModel>? reasonList;
    try {
      Debug.log(ServerConfig.rowingQualityFaultOperationsFrequency + date);
      String url = ServerConfig.rowingQualityFaultOperationsFrequency + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reasonList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityTopOperationModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reasonList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return reasonList;
  }

  static Future<List<RowingQualityTopFaultWithoutOperationListModel>?>
      getRowingQualityTopFaultWithOutOperation(date) async {
    Response response;
    List<RowingQualityTopFaultWithoutOperationListModel>? reasonList;
    try {
      Debug.log(
          ServerConfig.rowingQualityFaultFrequencyWithoutOperation + date);
      String url =
          ServerConfig.rowingQualityFaultFrequencyWithoutOperation + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return reasonList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse =
            RowingQualityTopFaultWithoutOperationModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        reasonList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return reasonList;
  }

  static Future<List<CardScanListModel>?> getRowingQualityCardInformation(
      date) async {
    Response response;
    List<CardScanListModel>? cardList;
    try {
      Debug.log(ServerConfig.rowingQualityRFIDCardInformation + date);
      String url = ServerConfig.rowingQualityRFIDCardInformation + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return cardList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = CardScanModel.fromJson(response.data);
        Get.snackbar(
          "Message",
          keysResponse.message,
          snackPosition: SnackPosition.BOTTOM,
        );
        cardList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return cardList;
  }

  static Future<List<DocumentVerifyAppListModel>?> getVerifyDashboardAppList(
      date) async {
    Response response;
    List<DocumentVerifyAppListModel>? documentVerifyAppList;
    try {
      Debug.log(ServerConfig.getVerifyDocumentsAppsList + date);
      String url = ServerConfig.getVerifyDocumentsAppsList + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return documentVerifyAppList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        // String params ="$date&appId=${response.data["appId"]}";
        // Debug.log(params);
        final keysResponse = DocumentVerifyAppModel.fromJson(response.data);
        // Get.snackbar(
        //   "Message",
        //   keysResponse.message,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        documentVerifyAppList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return documentVerifyAppList;
  }

  static Future<List<PendingDocumentsListModel>?> getPendingDocsList(
      date) async {
    Response response;
    List<PendingDocumentsListModel>? documentVerifyAppList;
    try {
      Debug.log(ServerConfig.getVerifyGetPendingDocsList + date);
      String url = ServerConfig.getVerifyGetPendingDocsList + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return documentVerifyAppList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = PendingDocumentsModel.fromJson(response.data);
        // Get.snackbar(
        //   "Message",
        //   keysResponse.message,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        documentVerifyAppList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return documentVerifyAppList;
  }

  static Future<List<NextLevelUsersListModel>?> getNextLevelUsers(date) async {
    Response response;
    List<NextLevelUsersListModel>? modelList;
    try {
      Debug.log(ServerConfig.getVerifyNextLevelUsersList + date);
      String url = ServerConfig.getVerifyNextLevelUsersList + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return modelList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = NextLevelUsersModel.fromJson(response.data);
        // Get.snackbar(
        //   "Message",
        //   keysResponse.message,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
        modelList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return modelList;
  }

  static Future<List<NextLevelUsersListModel>?> getBelowLevelUsers(date) async {
    Response response;
    List<NextLevelUsersListModel>? modelList;
    try {
      Debug.log(ServerConfig.getVerifyBelowLevelUsersList + date);
      String url = ServerConfig.getVerifyBelowLevelUsersList + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return modelList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = NextLevelUsersModel.fromJson(response.data);
        if (keysResponse.lists.isNotEmpty) {
          // Get.snackbar(
          //   "Message",
          //   keysResponse.message,
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        }

        modelList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return modelList;
  }

  static Future<List<NextLevelUsersListModel>?> getSameLevelUsers(date) async {
    Response response;
    List<NextLevelUsersListModel>? modelList;
    try {
      Debug.log(ServerConfig.getSameLevelUsers + date);
      String url = ServerConfig.getSameLevelUsers + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return modelList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = NextLevelUsersModel.fromJson(response.data);
        if (keysResponse.lists.isNotEmpty) {
          // Get.snackbar(
          //   "Message",
          //   keysResponse.message,
          //   snackPosition: SnackPosition.BOTTOM,
          // );
        }

        modelList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return modelList;
  }

  static Future<void> updateAppLevel(UpdateAppLevelModel updateAppLevel) async {
    Response response;
    try {
      Debug.log(ServerConfig.getVerifyUpdateAppLevel);
      String url = ServerConfig.getVerifyUpdateAppLevel;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.post(
        url,
        data: updateAppLevel.toJson(),
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {}
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      // return modelList;
    }
  }

  static Future<String?> fetchPdfUrl(date) async {
    Response response;
    String? pdfUrl;
    try {
      Debug.log(ServerConfig.getVerifyGetFile + date);
      String url = ServerConfig.getVerifyGetFile + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return pdfUrl;
    }

    if (response.statusCode == 200) {
      try {
        pdfUrl = response.data['pdfUrl'];
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return pdfUrl;
  }


  static Future<int?> getCountAllDocs(date) async {
    Response response;
    int? cnt;
    try {
      Debug.log(ServerConfig.getCountAllDocs + date);
      String url = ServerConfig.getCountAllDocs + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return cnt;
    }

    if (response.statusCode == 200) {
      try {
        cnt = response.data['Data']['CNT'];
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return cnt;
  }

  static Future<List<DocumentHistoryList>?> getDocHistory(date) async {
    Response response;
    List<DocumentHistoryList>? modelList;
    try {
      Debug.log(ServerConfig.getDocHistory + date);
      String url = ServerConfig.getDocHistory + date;
      String token = Get.find<Preferences>().getString(Keys.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };

      response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );
    } catch (e, s) {
      Debug.log(e);
      Debug.log(s);
      return modelList;
    }

    if (response.statusCode == 200) {
      Debug.log(response.data.toString());
      try {
        final keysResponse = DocumentHistory.fromJson(response.data);
        if (keysResponse.lists.isNotEmpty) {
          Get.snackbar(
            "Message",
            keysResponse.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        modelList = keysResponse.lists;
      } catch (e, s) {
        Debug.log(e);
        Debug.log(s);
      }
    }
    return modelList;
  }
}
