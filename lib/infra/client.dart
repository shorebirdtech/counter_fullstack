import 'shared.dart';
export 'shared.dart';

import 'package:flutter/foundation.dart';

// This differs from ValueNotifier, in that its read-only from the consumer.
class CachedValue<T> extends ChangeNotifier implements ValueListenable<T> {
  CachedValue(this._value);

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

class Connection {
  Connection();

  // What happens if this is called twice?
  // We really want to subscribe to the stream from the server in a
  // multi-cast fashion, no?
  CachedValue<T> cache<T>(Stream<T> Function(Session) getter,
      {required T initial}) {
    // turn the function pointer into a url
    // Set the initial value to the passed initial value.
    var value = CachedValue<T>(initial);
    // call the url
    // Sign up for the stream, update the cached value stream updates.
    getter(Session()).listen((event) {
      value._updateValue(event);
    });
    return value;
  }

  void call(void Function(Session) function) {
    // Turn the function pointer into a url
    // call to the url
    // Do I wait for the response?

    // HACK for now: just call the function
    function(Session());
  }
}
