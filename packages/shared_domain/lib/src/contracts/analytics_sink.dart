import 'package:shared_domain/src/entities/analytics/analytics_event.br.dart';

/// Where the game reports what players do. Today an on-device log for the
/// testers; Firebase Analytics in phase 3, behind this same interface.
/// [log] never throws and never waits: counting must not slow a move.
abstract interface class AnalyticsSink {
  void log(AnalyticsEvent event);
}
