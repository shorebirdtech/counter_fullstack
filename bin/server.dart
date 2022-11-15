// This should be in a separate package.

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import "package:shelf_router/shelf_router.dart" as routing;
import "package:shelf_eventsource/shelf_eventsource.dart";
import "package:eventsource/publisher.dart";

import 'package:counter_fullstack/infra/shared.dart';
import 'package:counter_fullstack/backend.dart';

void main() async {
  EventSourcePublisher publisher = EventSourcePublisher(cacheCapacity: 100);

  int id = 0;
  watchCounter(Session()).listen((event) {
    publisher.add(Event.message(id: "$id", data: event.toString()));
    id++;
  });

  Response incrementCountHandler(Request request) {
    incrementCount(Session());
    return Response.ok("Incremented");
  }

  var router = routing.Router();
  router.get("/watchCounter", eventSourceHandler(publisher));
  router.post("/incrementCounter", incrementCountHandler);

  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);
  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
