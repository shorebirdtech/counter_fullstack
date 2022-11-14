import 'package:flutter/widgets.dart';

// Dart (intentionally) does not have finalizers, so to manage listening
// its easier to let State do so, since it already gets a dispose call.
abstract class ListenableState<T extends StatefulWidget> extends State<T> {
  final List<Listenable> _listenables = <Listenable>[];

  void listen(Listenable listenable) {
    _listenables.add(listenable);
    listenable.addListener(_update);
  }

  void _update() {
    // One of our listenables changed, so rebuild the entire widget.
    // If you want more precise control, you can use a ValueListenableBuilder.
    setState(() {});
  }

  @override
  @mustCallSuper
  void dispose() {
    final listenables = List.from(_listenables);
    _listenables.clear();
    for (final listenable in listenables) {
      listenable.removeListener(_update);
    }
    super.dispose();
  }
}
