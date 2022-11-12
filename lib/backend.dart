// FIXME: This whole file should just be part of main.dart but can't
// be due to needing to be run in standalone Dart and such not
// being compatible with package:flutter imports.

import 'infra/backend.dart';
import 'dart:async';

// This should just be able to import flutter/foundation.dart.
// But it can't and still be runable in stand-alone Dart.
// import 'package:flutter/foundation.dart';
// so we implement our own:
typedef VoidCallback = void Function();

// Could use https://pub.dev/packages/state_notifier/versions/0.7.0
// But should just be able to use package:flutter/foundation.dart.
class ValueNotifier<T> {
  ValueNotifier(this._value);

  final List<VoidCallback> _listeners = [];

  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}

// This should just be:
// class MyStore extends DataStore {
//    int count = 0;
// }

class MyStore extends DataStore {
  MyStore();

  static MyStore? _instance;
  factory MyStore.of(Session session) {
    _instance ??= MyStore();
    return _instance!;
  }

  Stream<int> watchInt(String name) {
    if (name != 'count') {
      throw Exception('Invalid name');
    }
    StreamController<int> controller = StreamController<int>();

    // FIXME: What should this do on pause/resume?
    // https://github.com/dart-lang/sdk/issues/50446
    controller.add(count.value);

    count.addListener(() {
      controller.add(count.value);
    });
    return controller.stream;
  }

  ValueNotifier<int> count = ValueNotifier(0);
}

@backend
Stream<int> getCount(Session session) {
  // Should this use Key Value Observing?
  // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/index.html
  return MyStore.of(session).watchInt('count');
}

@backend
void incrementCount(Session session) {
  MyStore.of(session).count.value++;
}
