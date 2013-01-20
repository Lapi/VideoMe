library ServerConnection;

import 'dart:html';
import 'dart:json';
import 'controls/ServerResponseWindow.dart';

class ServerConnection {
  WebSocket webSocket;
  String url;
  ServerResponseWindow serverResponseWindow;

  ServerConnection(this.url, this.serverResponseWindow) {
    _init();
  }

  send(String from, String message) {
    var encoded = JSON.stringify({'f': from, 'm': message});
    _sendEncodedMessage(encoded);
  }

  _receivedCarousellItems(transferObject) {
//    carouselContent.compose(transferObject);    
  }

  _sendEncodedMessage(String encodedMessage) {
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(encodedMessage);
    } else {
      print('WebSocket not connected, message $encodedMessage not sent');
    }
  }

  _init([int retrySeconds = 2]) {
    bool encounteredError = false;
    
    scheduleReconnect() {
      serverResponseWindow.displayNotice('web socket closed, retrying in $retrySeconds seconds');
      if (!encounteredError) {
        window.setTimeout(() => _init(retrySeconds*2), 1000*retrySeconds);
      }
      encounteredError = true;
    }
    
    serverResponseWindow.displayNotice("Connecting to Web socket");
    webSocket = new WebSocket(url);

    webSocket.on.open.add((e) {
      serverResponseWindow.displayNotice('Connected');
      send("test", "frage");
    });
    
    webSocket.on.close.add((e) => scheduleReconnect());
    webSocket.on.close.add((e) {
      serverResponseWindow.displayNotice('web socket closed');
    });
    webSocket.on.error.add((e) => scheduleReconnect());
    webSocket.on.error.add((e) {
      serverResponseWindow.displayNotice('Error connecting to ws');
    });
    
    webSocket.on.message.add((e) {
      print('received message ${e.data}');
      var transferObject = JSON.parse(e.data);
      if (transferObject['Name'] == 'getCarousellItems') {
        _receivedCarousellItems(transferObject);
      }
    });
  }
}