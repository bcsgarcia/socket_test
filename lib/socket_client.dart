import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  StreamSocket streamSocket = StreamSocket();
  Socket? socket;

  void connectAndListen(String host, String socketPort) {
    final url = 'http://$host:$socketPort/catraca';

    log(url);

    socket = io(url, OptionBuilder().setTransports(['websocket']).build());

    socket?.onConnect((_) => streamSocket.changeConnection(true));
    socket?.on('toTotem', (data) => streamSocket.addResponse(data));
    socket?.onDisconnect((_) => streamSocket.changeConnection(false));
  }

  void sendMsg(String msg) => socket?.emit('toCatraca', msg);
}

class StreamSocket {
  final _socketResponseController = StreamController<String>();
  final _changeConnectionController = StreamController<bool>();

  void Function(String) get addResponse => _socketResponseController.sink.add;
  void Function(bool) get changeConnection =>
      _changeConnectionController.sink.add;

  Stream<String> get getResponse => _socketResponseController.stream;
  Stream<bool> get getConnectionState => _changeConnectionController.stream;

  void dispose() {
    _socketResponseController.close();
    _changeConnectionController.close();
  }
}
