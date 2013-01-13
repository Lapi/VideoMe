library ConnectedUsersControl;

import 'dart:html';
import '../View.dart';

class ConnectedUserControl extends View<TextAreaElement> {
  ConnectedUserControl(TextAreaElement elem) : super(elem);

  displayUser(String name) {
    _display("$name connected");
  }
  
  displayMessage(String msg, String from) {
    _display("$from: $msg\n");
  }
  
  displayNotice(String notice) {
    _display("[system]: $notice\n");
  }
  
  _display(String str) {
    elem.text = "${elem.text}$str";
  }
}
