import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_vikings_talk/analytics.dart';
import 'package:flutter_vikings_talk/events.dart';
import 'package:flutter_vikings_talk/server.dart';

void main() {
  analyticsService;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final int? count;

  const MyApp({
    super.key,
    this.count,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Vikings Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Vikings Demo',
        count: count,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int? count;

  const MyHomePage({
    super.key,
    required this.title,
    this.count,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _counter;
  bool _serverEventsStarted = false;

  @override
  void initState() {
    super.initState();

    _counter = widget.count ?? 0;

    serverInterceptor.serverStream.listen((event) {
      setState(() {
        _counter += event.properties!['value'] as int;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    AnalyticsEvent.incremented(value: _counter).emit();
  }

  void _decrementCounter() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    }
    AnalyticsEvent.decremented(value: _counter).emit();
  }

  void _toggleServerEvents() {
    setState(() {
      _serverEventsStarted = !_serverEventsStarted;
    });
    if (_serverEventsStarted) {
      serverInterceptor.start();
    } else {
      serverInterceptor.stop();
    }
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
              'Current value:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        children: [
          FloatingActionButton(
            onPressed: _toggleServerEvents,
            tooltip: 'Start Server Events',
            child: Icon(
              _serverEventsStarted ? Icons.stop : Icons.play_arrow,
            ),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
