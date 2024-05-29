import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class RowingQualityNFCController extends GetxController {
  RxBool isNfcAvailable = false.obs;
  RxString result = ''.obs;
  RxList<String> dataList = <String>[].obs;

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
        List<int> uidBytes = tag.data['nfca']['identifier'];
        String uid = uidBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(':');
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null) {
          NdefMessage message = await ndef.read();
          List<NdefRecord> records = message.records;
          String data = '';
          for (NdefRecord record in records) {
            if (isTextRecord(record)) {
              String payloadText = String.fromCharCodes(record.payload);
              data += payloadText;
            }
          }
          result.value = 'UID: $uid\n$data';
          populateDataList();
        } else {
          result.value = 'Tag is not NFC compatible';
        }
      } catch (e) {
        result.value = 'Error reading NFC data: $e';
      }
      NfcManager.instance.stopSession();
    });
  }

  bool isTextRecord(NdefRecord record) {
    if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
      if (record.typeNameFormat.toString().contains('T')) {
        return true;
      }
    }
    return false;
  }

  void populateDataList() {
    dataList.value = result.value.split('en').where((element) => element.isNotEmpty).toList();
    update();
  }
}
