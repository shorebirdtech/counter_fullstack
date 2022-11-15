import 'package:flutter/foundation.dart';

import 'package:eventsource/eventsource.dart';
import 'package:http/http.dart' as http;

// Is this just a https://api.flutter.dev/flutter/widgets/AsyncSnapshot-class.html?
// This differs from ValueNotifier, in that its read-only from the consumer.
class CachedValue<T> extends ChangeNotifier implements ValueListenable<T> {
  CachedValue(this._value);

  // Needs speculation state.

  // state.Speculative
  // state.Authoratative
  // state.Default

  @override
  T get value => _value;
  T _value;

  void _updateValue(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '$value';
}

// generated code
class MyInterface {
  MyInterface();

// This should come from the Connection.
  static const String baseUrl = 'http://localhost:8080';

  static const int initialCount = 0;

// What happens if this is called twice?
// We really want to subscribe to the stream from the server in a
// multi-cast fashion, no?
  CachedValue<int> getCount() {
    // Do all the work to call across the wire.
    // Set the initial value to the passed initial value.
    var value = CachedValue<int>(initialCount);

    Uri uri = Uri.parse('$baseUrl/watchCounter');
    // call the url
    // Sign up for the stream, update the cached value stream updates.
    EventSource.connect(uri).then((EventSource source) {
      source.listen((Event e) {
        value._updateValue(int.parse(e.data ?? ""));
      });
    });
    return value;
  }

  Future<void> incrementCounter() async {
    // call to the url
    // Do I wait for the response?
    Uri uri = Uri.parse('$baseUrl/incrementCounter');
    await http.post(uri);
  }
}
