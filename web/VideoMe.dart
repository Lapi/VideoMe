library VideoMe;

import 'dart:html';
import 'applib/ServerConnection.dart';
import 'applib/controls/ConnectedUsersControl.dart';
import 'applib/controls/ServerResponseWindow.dart';

ServerConnection serverConnection;
ConnectedUserControl connectedUserControl;

void main() {
  TextAreaElement serverResponse = query('#serverResponse');
  serverConnection = new ServerConnection("ws://127.0.0.1:1337/ws", new ServerResponseWindow(serverResponse));

  TextAreaElement connectedUsers = query('#connectedUsers');
  connectedUserControl = new ConnectedUserControl(connectedUsers);
  
}