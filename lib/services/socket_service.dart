import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {
  
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket? get socket => this._socket;
  Function get emit => socket?.emit ?? () {} ;

  SocketService() {
    this._initConfig();
  }


  void _initConfig() {

    this._socket = IO.io( 'https://flutter-socket-server82.herokuapp.com/',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .build()
    );

    this._socket?.onConnect( ( _ ) {      
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
        
    this._socket?.onDisconnect( ( _ ) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

}