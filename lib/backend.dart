// FIXME: This file should be part of main.dart but can't yet because
// stand-alone Dart does not support Flutter imports (depend on dart:ui).

import 'package:shorebird/shorebird.dart';

// This should just be:
// @shared
// class MyStore extends DataStore {
//    @watchable
//    int count = 0;
// }

class MyStore extends DataStore {
  MyStore();

  static MyStore? _shared;
  factory MyStore.shared() {
    _shared ??= MyStore();
    return _shared!;
  }

  Watchable<int> count = Watchable(0);
}

class CounterEndpoint extends Endpoint {
  Stream<int> watch(Session session) {
    return MyStore.shared().count.watch();
  }

  void increment(Session session) {
    MyStore.shared().count.value++;
  }
}
