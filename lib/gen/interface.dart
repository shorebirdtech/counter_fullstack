// This will be generated code

import 'package:eventsource/eventsource.dart';
import 'package:http/http.dart' as http;
import 'package:shorebird_flutter/shorebird_flutter.dart';

class CounterClient {
  CounterClient();

// This should come from the Connection.
  static const String baseUrl = 'http://localhost:8080';

  static const int initialCount = 0;

  // What should happen if this is called twice?
  CachedValue<int> watch() {
    var value = CachedValue<int>(initialCount);

    Uri uri = Uri.parse('$baseUrl/counter/watch');
    EventSource.connect(uri).then((EventSource source) {
      source.listen((Event e) {
        // FIXME: updateValue should be private, this contract is wrong.
        value.updateValue(int.parse(e.data ?? ""));
      });
    });
    return value;
  }

  Future<void> increment() async {
    Uri uri = Uri.parse('$baseUrl/counter/increment');
    await http.post(uri);
  }
}
