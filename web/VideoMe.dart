library VideoMe;

import 'dart:html';
import 'applib/ServerConnection.dart';
import 'applib/controls/ConnectedUsersControl.dart';

ServerConnection serverConnection;
ConnectedUserControl connectedUserControl;

void main() {
  serverConnection = new ServerConnection("ws://127.0.0.1:1337/ws");
  
  connectedUserControl = new ConnectedUserControl(query('#connectedUsers'));
}