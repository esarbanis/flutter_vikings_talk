import 'package:flutter_vikings_talk/events.dart';

abstract class AnalyticsService {
  void logEvent(AnalyticsEvent event);
}

class _LoggingAnalyticsService extends EventListener<AnalyticsEvent>
    implements AnalyticsService {

  _LoggingAnalyticsService() : super();

  @override
  void logEvent(AnalyticsEvent event) {
    print(event);
  }

  @override
  Future<void> onEvent(AnalyticsEvent event) async {
    logEvent(event);
  }
}

final AnalyticsService _analyticsService = _LoggingAnalyticsService();

AnalyticsService get analyticsService => _analyticsService;
