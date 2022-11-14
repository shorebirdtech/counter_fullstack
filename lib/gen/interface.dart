import 'package:flutter/foundation.dart';

import 'package:counter_fullstack/infra/shared.dart';
import 'package:counter_fullstack/backend.dart' as backend;

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

  static const int initialCount = 0;

// What happens if this is called twice?
// We really want to subscribe to the stream from the server in a
// multi-cast fashion, no?
  CachedValue<int> getCount() {
    // Do all the work to call across the wire.

    // turn the function pointer into a url
    // Set the initial value to the passed initial value.
    var value = CachedValue<int>(initialCount);
    // call the url
    // Sign up for the stream, update the cached value stream updates.
    backend.getCount(Session()).listen((event) {
      value._updateValue(event);
    });
    return value;
  }

  void incrementCounter() {
    // Turn the function pointer into a url
    // call to the url
    // Do I wait for the response?
    // Hack, just call the function directly.
    backend.incrementCount(Session());
  }
}
