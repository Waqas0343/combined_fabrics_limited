import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class SocketController extends GetxController {
  late WebSocketChannel _channel;
  var isConnected = false.obs;
  var alerts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();
  }

  void connectWebSocket() {
    try {
      _channel =
          IOWebSocketChannel.connect('ws://your_company_websocket_server:8080');
      isConnected.value = true;

      // Listen for incoming alerts
      _channel.stream.listen((message) {
        addAlert(message);
      });
    } catch (e) {
      isConnected.value = false;
      Debug.log('WebSocket connection error: $e');
    }
  }

  void addAlert(String message) {
    alerts.add(message);
  }

  void sendAlert(String message) {
    _channel.sink.add(message);
  }

  @override
  void onClose() {
    _channel.sink.close();
    super.onClose();
  }
}
