import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../../../server/api_fetch.dart';
import '../models/rowing_quality_rfid_card_scane_model.dart';

class RowingQualityScanEndLineRFIDController extends GetxController {
  final RxList<CardScanListModel>operatorProductionList = RxList<CardScanListModel>();
  final RxBool isLoading = RxBool(true);
  RxBool isNfcAvailable = false.obs;
  RxString result = ''.obs;
  RxString uid = ''.obs;
  RxString blockDataString = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initNfc();
    tagRead();
  }

  Future<void> initNfc() async {
    isNfcAvailable.value = await NfcManager.instance.isAvailable();
  }

  void tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        Debug.log('--------------------------------------------------------${tag.data}');
        Debug.log('--------------------------------------------------------${tag.handle}');
        List<int> uidBytes = tag.data['mifareclassic']['identifier'];
        Debug.log(tag.data['mifareclassic']);
        String uidString = uidBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(':');
        uid.value = uidString;
        result.value = uidString.toUpperCase();
        Debug.log("UID: $uidString");
        var mifareClassic = MifareClassic.from(tag);
        if (mifareClassic == null) {
          Debug.log('MifareClassic is null');
          result.value = 'Error: MifareClassic is null';
          return;
        }
        Uint8List keyA = Uint8List.fromList([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]);
        int sectorIndex = 1;
        int blockIndex = 5;
        bool auth = await mifareClassic.authenticateSectorWithKeyA(sectorIndex: sectorIndex, key: keyA);
        if (auth) {
          Debug.log('Authentication successful');
          List<int> blockData = await mifareClassic.readBlock(blockIndex: blockIndex);
          Debug.log("Block 5 Data------------------------------: $blockData");
          String blockDataString = blockData.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
          Debug.log("Block 5 Data As String--------------------: $blockDataString");
          String cardNumber = blockDataString.substring(2, 8);
          Debug.log("Card Number: $cardNumber");
          getRowingQualityTopOperatorReport(cardNumber);
          this.blockDataString.value = cardNumber;
        } else {
          Debug.log("Authentication failed");
        }
      } catch (e) {
        result.value = 'Error reading NFC data: $e';
        Debug.log("Error reading NFC data: $e");
      }
      NfcManager.instance.stopSession();
    });
  }
  Future<void> getRowingQualityTopOperatorReport(String card) async {
    isLoading(true);
    String data = "RFID=$card";
    operatorProductionList.clear();

    List<CardScanListModel>? responseList = await ApiFetch.getRowingQualityCardInformation(data);
    isLoading(false);

    if (responseList != null) {
      Set<String> seenBundleIDs = {};
      List<CardScanListModel> filteredList = responseList.where((item) {
        if (seenBundleIDs.contains(item.bundleId)) {
          return false;
        } else {
          seenBundleIDs.add(item.bundleId);
          return true; // include unique items
        }
      }).toList();
      operatorProductionList.assignAll(filteredList);
    } else {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


}
