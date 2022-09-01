import 'package:event_bus/event_bus.dart';

void setBus(EventBus eventBus) => _eventBus = eventBus;

EventBus _eventBus = EventBus();

mixin EventEmitter {
  void emit() {
    _eventBus.fire(this);
  }
}

abstract class Event with EventEmitter {
  String get type;
}

class AnalyticsEvent extends Event {
  final String eventName;
  final Map<String, dynamic>? properties;

  AnalyticsEvent(
    this.eventName, {
    this.properties,
  });

  @override
  String get type => name;

  static const String name = 'AnalyticsEvent';

  @override
  String toString() => '$type: $eventName, $properties';

  factory AnalyticsEvent.incremented({
    required int value,
  }) =>
      AnalyticsEvent(
        'Incremented',
        properties: {
          'value': value,
        },
      );

  factory AnalyticsEvent.decremented({
    required int value,
  }) =>
      AnalyticsEvent(
        'Decremented',
        properties: {
          'value': value,
        },
      );
}

class ServerSideEvent extends Event {
  final String eventName;
  final Map<String, dynamic>? properties;

  ServerSideEvent(
    this.eventName, {
    this.properties,
  });

  @override
  String get type => name;

  static const String name = 'ServerSideEvent';

  @override
  String toString() => '$type: $eventName, $properties';

  factory ServerSideEvent.incremented({
    required int value,
  }) =>
      ServerSideEvent(
        'Incremented',
        properties: {
          'value': value,
        },
      );

  factory ServerSideEvent.decremented({
    required int value,
  }) =>
      ServerSideEvent(
        'Decremented',
        properties: {
          'value': value,
        },
      );
}

abstract class EventListener<E> {

  EventListener() {
    _eventBus.on<E>().listen(onEvent);
  }

  Future<void> onEvent(E event);
}
