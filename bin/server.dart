// This dependency should not exist.
import 'package:shorebird/shorebird.dart';
import 'package:counter_fullstack/gen/endpoint.dart';

void main() async {
  var handlers = [CounterHandler()];
  var server = Server();
  await server.serve(handlers, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
