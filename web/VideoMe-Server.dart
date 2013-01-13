library VideoMeServer;

import 'dart:io';
import 'dart:isolate';
import 'dart:json';
import 'applib/file-logger.dart' as log;
import 'applib/server-utils.dart';

var script = new File(new Options().script);
var directory = script.directorySync();
String basePath = "${directory.path}/log";
HttpServer server = new HttpServer();
WebSocketHandler wsHandler = new WebSocketHandler();

class StaticFileHandler {

  _send404(HttpResponse response) {
    response.statusCode = HttpStatus.NOT_FOUND;
    response.outputStream.close();
  }

  // TODO: etags, last-modified-since support
  onRequest(HttpRequest request, HttpResponse response) {
    final String path = request.path == '/' ? '/Coffin.html' : request.path;
    final File file = new File('${basePath}${path}');
    file.exists().then((found) {
      if (found) {
        file.fullPath().then((String fullPath) {
          if (!fullPath.startsWith(basePath)) {
            _send404(response);
          } else {
            file.openInputStream().pipe(response.outputStream);
          }
        });
      } else {
        _send404(response);
      }
    });
  }
}

class RequestHandler {

  Set<WebSocketConnection> connections;

  RequestHandler(String basePath) : connections = new Set<WebSocketConnection>() {
    log.initLogging('${basePath}/server-log.txt');
  }

  // closures!
  onOpen(WebSocketConnection conn) {
    print('new ws conn: $conn');
    connections.add(conn);

    conn.onClosed = (int status, String reason) {
      print('conn is closed');
      connections.remove(conn);
    };

    conn.onMessage = (message) {
      print('new ws msg: $message');
      Map map = JSON.parse(message);
      switch (map['name']) {
//        case 'getCarousellItems' :
//          _getCarousellItems(conn);
//          break;
      }
      time('send to isolate', () => log.log(message));
    };
  }
}

//_getCarousellItems(WebSocketConnection conn) {
////_getCarousellItems(HttpResponse request) {
//  if (imagePathList.length == 0) {
//    var directory = new Directory("web/img/coffin");
//    DirectoryLister directoryLister = directory.list();
//    var i = 1;
//    directoryLister.onFile = (path) {
//      imagePathList.add(path);
//    };
//    directoryLister.onDone = (ka) {
//      print(imagePathList);
//      var tO = new TransferObject();
//      tO.Id = 0;
//      tO.Name = "getCarousellItems";
//      tO.Items.addAll(imagePathList);
//      conn.send(JSON.stringify(tO));
////      request.outputStream.writeString(JSON.stringify(tO), Encoding.UTF_8);
//    };
//  }
//}

class TransferObject {
  int Id;
  String Name;
  List<String> Items = new List<String>();
  
  toJson() {
    var a = {'Id': Id, 'Name': Name, 'Items': Items.toString()};
    print (a);
    return a;
  }
}

runServer(int port) {
  wsHandler.onOpen = new RequestHandler(basePath).onOpen;

  server.defaultRequestHandler = new StaticFileHandler().onRequest;
  server.addRequestHandler((req) => req.path == "/ws", wsHandler.onRequest);
  server.onError = (error) => print(error);
  server.listen('127.0.0.1', port);
  print('listening for connections on $port');
}

main() {
  runServer(1337);
}
