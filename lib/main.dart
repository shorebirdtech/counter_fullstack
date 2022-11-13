import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'infra/client.dart';
import 'backend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Dart (intentionally) does not have finalizers, so to manage listening
// its easier to let State do so, since it already gets a dispose call.
abstract class ShorebirdState<T extends StatefulWidget> extends State<T> {
  final List<Listenable> _listenables = <Listenable>[];

  void watch(Listenable listenable) {
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

// generated
class MyInterface {
  MyInterface(this._connection);

  final Connection _connection;

  CachedValue<int> get getCount {
    return _connection.cache<int>((Session session) {
      return session.get<int>('counter');
    }, initial: 0);
  }

  void incrementCounter() {
    _connection.call((Session session) {
      session.post('increment');
    });
  }
}

class _MyHomePageState extends ShorebirdState<MyHomePage> {
  late CachedValue<int> _counter;
  late Connection _connection;

  @override
  void initState() {
    super.initState();
    _connection = MyInterface(Connection(url));
    watch(_counter = _connection.getCount());
  }

  void _incrementCounter() {
    _connection.incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
