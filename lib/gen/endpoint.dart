// This will be generated code
import 'package:counter_fullstack/backend.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shorebird/shorebird.dart';

// Is this per-session, or per-server?
// Currently this is assuming per-server.
class CounterHandler extends ShorebirdHandler {
  // This should not use Router directly?
  // This should also not operate on absolute paths.
  CounterEndpoint endpoint = CounterEndpoint();

  @override
  void addRoutes(Router router) {
    // FIXME: This handler should not require a session.
    router.get("/counter/watch", streamHandler(endpoint.watch(Session())));
    router.post("/counter/increment", increment);
  }

  Response increment(Request request) {
    endpoint.increment(Session());
    return Response.ok("Incremented");
  }
}
