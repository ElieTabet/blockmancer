import 'dart:async';

import 'package:remote_config/remote_config.dart';

/// Remote Config as the console would publish it: [publish] stands for a live
/// update, [onFetch] for what the next fetch brings.
final class FakeRemoteValues implements RemoteValues {
  final StreamController<void> _changes = .broadcast();
  Completer<void>? fetchGate;
  int fetches = 0;
  int listens = 0;
  Map<String, String>? onFetch;
  final Map<String, String> published = {};

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<void> fetchAndActivate() async {
    fetches++;
    await fetchGate?.future;
    published.addAll(onFetch ?? const {});
    _changes.add(null);
  }

  @override
  void listenForUpdates() => listens++;

  void publish(String key, String value) {
    published[key] = value;
    _changes.add(null);
  }

  @override
  String? valueOf(String key) => published[key];
}
