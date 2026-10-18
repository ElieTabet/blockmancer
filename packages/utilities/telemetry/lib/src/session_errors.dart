import 'package:flutter/foundation.dart';

/// Whether an uncaught error reached Flutter or the platform this launch: a
/// session that broke is no moment to ask for a rating.
final class SessionErrors {
  var _seen = false;
  var _watching = false;

  bool get seen => _seen;

  /// Wraps the handlers in place, Crashlytics' when collecting or Flutter's
  /// own otherwise, so they still run. Once per launch.
  void watch() {
    if (_watching) return;

    _watching = true;

    final flutter = FlutterError.onError;
    FlutterError.onError = (details) {
      _seen = true;
      flutter?.call(details);
    };

    final platform = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _seen = true;

      return platform?.call(error, stackTrace) ?? false;
    };
  }
}
