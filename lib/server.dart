import 'dart:async';

import 'events.dart';

abstract class ServerInterceptor<E> {
  Stream<E> get serverStream;
  void start();
  void stop();
}

const kServerValue = 1;

class _PeriodicMockedServerInterceptor
    extends ServerInterceptor<ServerSideEvent> {
  final StreamController<ServerSideEvent> _streamController =
      StreamController<ServerSideEvent>.broadcast();
  final _period = const Duration(seconds: 2);
  Timer? _timer;

  @override
  Stream<ServerSideEvent> get serverStream => _streamController.stream;

  @override
  void start() {
    _timer = Timer.periodic(_period, (timer) {
      _streamController.add(ServerSideEvent.incremented(value: kServerValue));
    });
  }

  @override
  void stop() {
    _timer?.cancel();
  }
}

final _serverInterceptor = _PeriodicMockedServerInterceptor();

ServerInterceptor<ServerSideEvent> get serverInterceptor => _serverInterceptor;
