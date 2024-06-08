class ServerConfig {
  // static const baseUrl = "http://172.16.0.95:1257/api/";

  static const baseUrl = "http://172.16.0.11/api/";

  // Below are the all api that are use in our system
  static const login = "${baseUrl}Account/Login";
  static const loginWithToken = "${baseUrl}Account/LoginWithToken";
  static const getMenu= "${baseUrl}Account/GetMenu?";
  static const getSubMenu = "${baseUrl}Account/GetSubMenu?";
  static const getMobileVersion = "${baseUrl}Account/GetAppVersion";
  static const addMobileVersion = "${baseUrl}Account/UpdateAppVersion?";


  // Fabric Inspection Department Api

  static const lots = "${baseUrl}FID/GetLots?";
  static const getLotsDetail = "${baseUrl}FID/GetLotDetail?";
  static const rolls = "${baseUrl}FID/GetRolls?";
  static const faults = "${baseUrl}FID/GetFaults?";
  static const saveFaults = "${baseUrl}FID/AddFaultByRoll?";
  static const getDetailByRoll = "${baseUrl}FID/GetDetailByRoll?";
  static const getShift = "${baseUrl}FID/GetShift?";
  static const getQualityStatus = "${baseUrl}FID/GetQualityStatus?";
  static const getRollMarkingStatus = "${baseUrl}FID/GetRollMarkingStatus?";
  static const getInspectionTable = "${baseUrl}FID/GetIspectionType?";
  static const saveFaultsFormData = "${baseUrl}FID/AddDetailByRoll?";

  // Complaint Portal API

  static const getDepartments = "${baseUrl}ComplaintPortal/GetDeptartments?";
  static const getToDepartments = "${baseUrl}ComplaintPortal/GetToDepartment?";
  static const getShortNameAssetCode = "${baseUrl}ComplaintPortal/GetShortNameAssetCode?";
  static const getLongNameAssetCode = "${baseUrl}ComplaintPortal/GetLongNameAssetCode?";
  static const getShortLongNameByAssetCode = "${baseUrl}ComplaintPortal/GetShortNameLongNameByAssetCode?";
  static const getComplaintStatus = "${baseUrl}ComplaintPortal/GetStatus?";
  static const getDepartmentComplaint = "${baseUrl}ComplaintPortal/GeComplaintsByDept?";
  static const submitComplaint = "${baseUrl}ComplaintPortal/SubmitComplaint?";
  static const complaintAssigneePerson = "${baseUrl}ComplaintPortal/GetAssignedPersonByCMPNo?";
  static const getEmployeeByDept = "${baseUrl}ComplaintPortal/GetEmployeeByDept?";
  static const removeAssigneePerson = "${baseUrl}ComplaintPortal/RemoveAssignee?";
  static const addAssigneePerson = "${baseUrl}ComplaintPortal/AddAssignee?";
  static const changeDepartment = "${baseUrl}ComplaintPortal/ChangeCMPDepartment?";
  static const setPlanDate = "${baseUrl}ComplaintPortal/SetPlanDate?";
  static const setActualDate = "${baseUrl}ComplaintPortal/SetActualDate?";
  static const complaintRemark = "${baseUrl}ComplaintPortal/GetRemarksByCMPNo?";
  static const closeComplaint = "${baseUrl}ComplaintPortal/ComplaintClosed?";
  static const resolveComplaint = "${baseUrl}ComplaintPortal/ComplaintResolved?";
  static const complaintReject = "${baseUrl}ComplaintPortal/ComplaintReject?";
  static const complaintVerify = "${baseUrl}ComplaintPortal/ComplaintVerified?";
  static const complaintChartData = "${baseUrl}ComplaintPortal/GetStatusByDept?";
  static const changeStatusToAcknowledge = "${baseUrl}ComplaintPortal/ChangeStatusToAcknowladge?";
  static const changeComplaintButton = "${baseUrl}ComplaintPortal/ComplaintRights?";
  static const getComplaintByCMPNO = "${baseUrl}ComplaintPortal/GetComplaintsByCMPNO?";
  static const getComplaintDashBoard = "${baseUrl}ComplaintPortal/Dashboard?";
  static const getDemand = "${baseUrl}ComplaintPortal/GetDemand?";
  static const changeDemandStatus = "${baseUrl}ComplaintPortal/ChangeCmpByDemand?";
  static const addComplaintDemand = "${baseUrl}ComplaintPortal/AddCmpDemand?";

  //Goods Inspection Api

  static const getReceivedIGPNo = "${baseUrl}GIN/GetReceivedIGPNo?";
  static const getRequestedIGPNo = "${baseUrl}GIN/GetRequestedIGPNo?";
  static const getInspectedIGPNo = "${baseUrl}GIN/GetInspectedIGPNo?";
  static const getIGPnODetail = "${baseUrl}GIN/GetIGPNoDetail?";
  static const sendIGPRequest = "${baseUrl}GIN/SendRequest?";
  static const getIGPRequest = "${baseUrl}GIN/GetRequest?";
  static const addIGPFormData = "${baseUrl}GIN/AddInspection?";
  static const getOtherDepartmentInGoodInspection = "${baseUrl}GIN/GetOtherDept?";
  static const getReceiveIGPList = "${baseUrl}GIN/GetIGPForReceiving?";
  static const receiveIGP = "${baseUrl}GIN/ReceiveIGP?";
  static const reverseBackIGP = "${baseUrl}GIN/ReverseIGPForReceiving?";




//Keys Management Api

  static const keysAndDashBoardDetail = "${baseUrl}Keys/KeysDashboard1?";
  static const keysIssuance = "${baseUrl}Keys/KeysIssueReturn?";
  static const masterKeysList = "${baseUrl}Keys/GetKeysMaster?";
  static const addMasterKeys = "${baseUrl}Keys/AddKeysMaster?";
  static const updateMasterKeys = "${baseUrl}Keys/UpdateKeysMaster?";
  static const deleteMasterKeys = "${baseUrl}Keys/RemoveKeysMaster?";
  static const getKeyConcernedPerson = "${baseUrl}Keys/GetKeysConcerendPersons?";
  static const saveKeyTimeTable = "${baseUrl}Keys/AddKeysTimeTable?";
  static const getKeyTimeTable = "${baseUrl}Keys/GetKeysTimeTable?";
  static const getKeyReports = "${baseUrl}Keys/GetKeysWithTimeTable?";
  static const getKeySubDepartment = "${baseUrl}Keys/GetKeysSubDept?";
  static const addSubDepartment = "${baseUrl}Keys/AddKeysSubDept?";

//Medical Issuance Api

  static const getMedicineList = "${baseUrl}MI/GetMedicine?";
  static const medicinesIssue = "${baseUrl}MI/MedicalIssuance?";
  static const getPatientMedicinesIssuanceList = "${baseUrl}MI/GetMedicalIssuance?";
  static const getPatientCardNo = "${baseUrl}MI/GetPatientDetailByCardNo?";
  static const getDiseaseName = "${baseUrl}MI/GetDiseaseName?";
  static const addDiseaseName = "${baseUrl}MI/AddDisease?";
  static const getMedicineStock = "${baseUrl}MI/GetMedicinWithStock?";
  static const getFirstAidBoxIssuance = "${baseUrl}MI/GetFirstAidBoxIssuance?";
  static const getFirstAidBox= "${baseUrl}MI/GetFirstAidBox?";
  static const addFirstAidBox= "${baseUrl}MI/AddFirstAidBox?";


  // Rowing Quality API's

  static const rowingQualityFault= "${baseUrl}Rowing/GetRowingQualityFaults";
  static const addQualityFault= "${baseUrl}Rowing/AddRowingQualityFault";
  static const rowingQualityInspectionForm= "${baseUrl}Rowing/GetRowingQualityOrderAndWorkerId?";
  static const rowingQualityWorkerOperation= "${baseUrl}Rowing/GetRowingQualityWorkerOperation?";
  static const addRowingQualityMasterDetail= "${baseUrl}Rowing/AddRowingQualityMasterForm";
  static const addRowingQualityFaultDetail= "${baseUrl}Rowing/AddRowingQualityFaultInspectionDetail";
  static const addRowingQualityInspectionFlag= "${baseUrl}Rowing/AddRowingQualityInspectionFlag?";
  static const getRowingQualityDashboardMachineWithFlag= "${baseUrl}Rowing/GetRowingQualityMachineWiseDetail?";
  static const getRowingQualityFlagColor= "${baseUrl}Rowing/GetRowingQualityFlagColors";
  static const getRowingQualityInLineStatusReport= "${baseUrl}Rowing/GetRowingQualityInlineStatusRport?";
  static const saveMachineFlagUpdate= "${baseUrl}Rowing/MachineFlagUpdate?";
  static const getEmployeeStitchPcs= "${baseUrl}Rowing/GetEmployeeStitcpcs?";
  static const saveRowingQualityEndLineMasterForm= "${baseUrl}Rowing/AddRowingQualityEndlineMaster?";
  static const addRowingQualityFaultPerGarments= "${baseUrl}Rowing/AddRowingQualityFaultInspectionDetailEndline?";
  static const rowingQualitySkipGarmentInspection= "${baseUrl}Rowing/RowingQualitySkipedEndLineInspection?";
  static const rowingQualityBundleDetail= "${baseUrl}Rowing/GetRowingQualityBundleDetails?";
  // static const rowingQualityGetDHUDetail= "${baseUrl}Rowing/GetRowingEndlineDHUData?";
  static const rowingQualityGetDHUDetail= "${baseUrl}Rowing/GetRowingEndlineDHUDataNew?";
  static const rowingQualityGetRoundDetail= "${baseUrl}Rowing/GetRowingInlineRoundDetail?";
  static const rowingQualityInspectorActivityDetail= "${baseUrl}Rowing/GetRowingInspecterActivityDetail?";
  static const rowingQualityEndLineBundleReports= "${baseUrl}Rowing/GetRowingEndlineBundelReport?";
  static const rowingQualityOperationList= "${baseUrl}Rowing/GetoperationnameAgainstWorkders?";
  static const rowingQualityEndLineReportDetail= "${baseUrl}Rowing/GetRowingEndlineDetailReport?";
  static const rowingQualityEndLineGetTotalPcsStitchWorkOrderWise= "${baseUrl}Rowing/GetTotalPcsStichWorkorderwise?";
  static const rowingQualityInLineFlagReportWithDHU= "${baseUrl}Rowing/GetRowingINlineFlagWithDhuDetailReport?";
  static const rowingQualityEndLineInspectorHourlyReport= "${baseUrl}Rowing/GetRowingEndLineBundelSummaryReport?";
  static const rowingQualityEndLineOperatorMonthlyReport= "${baseUrl}Rowing/GetInlineOperatorFlagReport?";
  static const rowingQualityEndLineOperatorMonthlyDetailReport= "${baseUrl}Rowing/GetInlineOperatorFlagMonthlyDetailReport?";
  static const rowingQualityEndLineQAStitchingReport= "${baseUrl}Rowing/GetEndlineDhudataWithOffLinePcsNew?";
  static const rowingQualityInLineProductionHourlyReport= "${baseUrl}Rowing/GetInlineproductionHourlyReport?";
  static const rowingQualityCheckWorkOrderRateList= "${baseUrl}Rowing/GetWorkorderRatelist?";
  static const rowingQualityCheckWorkOrderSummaryReport= "${baseUrl}Rowing/GetWorkorderStitchOutputSummary?";
  static const rowingQualityGetAllFaults= "${baseUrl}Rowing/GetRowingQualityALLFaults";
  static const rowingQualityChangeFlagReason= "${baseUrl}Rowing/GetRowingQualityFaultsReasons";
  static const rowingQualityWorkOrderProductionStitchingReport= "${baseUrl}Rowing/GetRowingQualityWorkOrdreStichingDetailDHU?";
  static const rowingQualityOperatorProductiongReport= "${baseUrl}Rowing/GetOperatorProductionWithEndlineDHU?";
  static const rowingQualityFaultOperationsFrequency= "${baseUrl}Rowing/GetFaultOperationsFrequncy?";
  static const rowingQualityFaultFrequencyWithoutOperation= "${baseUrl}Rowing/GetFaultFaultsFrequncy?";
  static const rowingQualityRFIDCardInformation = "${baseUrl}Rowing/GetRFIDCardBundelid_AndOpertaionTracting?";

  // Verify Documents

  static const getVerifyDocumentsAppsList = "${baseUrl}DocApprovel/GetAppsList?";
  static const getVerifyGetCountDocsList = "${baseUrl}DocApprovel/GetCountDocs?";
  static const getVerifyGetPendingDocsList = "${baseUrl}DocApprovel/GetPendingDocs?";
  static const getVerifyNextLevelUsersList = "${baseUrl}DocApprovel/GetNextLevelUsers?";
  static const getVerifyBelowLevelUsersList = "${baseUrl}DocApprovel/GetBelowLevelsUsers?";
  static const getVerifyUpdateAppLevel = "${baseUrl}DocApprovel/UpdateAppLevel";
  static const getVerifyGetFile = "${baseUrl}DocApprovel/GetFile?";
  static const getDocHistory = "${baseUrl}DocApprovel/GetDocHistory?";


}