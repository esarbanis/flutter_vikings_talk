// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vikings_talk/events.dart';
import 'package:flutter_vikings_talk/main.dart';


void main() {
  late EventBus testEventBus;

  setUp(() {
    testEventBus = EventBus();
    setBus(testEventBus);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter decrements smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(
      count: 1,
    ));
    await tester.pump();

    // Verify that our counter starts at 0.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    // Verify that our counter has incremented.
    expect(find.text('1'), findsNothing);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Counter decrements event test', (WidgetTester tester) async {
    Future eventList = testEventBus.on<AnalyticsEvent>().toList();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(
      count: 1,
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    testEventBus.destroy();

    final events = await eventList;
    expect(events, isNotEmpty);

    final event = events.first as AnalyticsEvent;
    expect(event.eventName, 'Decremented');
    expect(event.properties!['value'] as int, 0);
  });

  testWidgets('Counter increments event test', (WidgetTester tester) async {
    Future eventList = testEventBus.on<AnalyticsEvent>().toList();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    testEventBus.destroy();

    final events = await eventList;
    expect(events, isNotEmpty);

    final event = events.first as AnalyticsEvent;
    expect(event.eventName, 'Incremented');
    expect(event.properties!['value'] as int, 1);
  });
}
