import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_config/src/package_name.dart';
import 'package:remote_config/src/remote_values.dart';
import 'package:timber/timber.dart';

/// Firebase Remote Config behind [RemoteValues]. In-app defaults live with the
/// code that reads each key, not in the SDK, so only a value actually
/// published counts.
final class FirebaseRemoteValues implements RemoteValues {
  final StreamController<void> _changes = .broadcast();
  static const _fetchTimeout = Duration(seconds: 10);
  final FirebaseRemoteConfig? _injected;
  final Duration _minimumFetchInterval;
  StreamSubscription<RemoteConfigUpdate>? _updates;

  FirebaseRemoteValues({
    required Duration minimumFetchInterval,
    FirebaseRemoteConfig? remoteConfig,
  }) : _injected = remoteConfig,
       _minimumFetchInterval = minimumFetchInterval;

  /// Resolved on use: the instance throws until `Firebase.initializeApp` has
  /// run, and constructing this is wiring.
  FirebaseRemoteConfig get _remoteConfig =>
      _injected ?? FirebaseRemoteConfig.instance;

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: _fetchTimeout,
          minimumFetchInterval: _minimumFetchInterval,
        ),
      );
      await _remoteConfig.fetchAndActivate();
      _changes.add(null);
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Fetching Remote Config failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// The SDK fetches each update itself but leaves it to be activated. An
  /// error on the stream (Android reports a dropped connection there) leaves
  /// it listening: the SDK reconnects on its own.
  @override
  void listenForUpdates() {
    if (_updates != null) return;

    try {
      _updates = _remoteConfig.onConfigUpdated.listen(
        (_) => unawaited(_activateUpdate()),
        onError: (Object error, StackTrace stackTrace) => Timber.e(
          tag: packageName,
          logMessage: 'Listening for Remote Config updates failed',
          exception: error,
          stackTrace: stackTrace,
        ),
      );
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Listening for Remote Config updates failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  String? valueOf(String key) {
    try {
      final value = _remoteConfig.getValue(key);

      return value.source == ValueSource.valueRemote ? value.asString() : null;
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Reading Remote Config failed',
        exception: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<void> _activateUpdate() async {
    try {
      await _remoteConfig.activate();
      _changes.add(null);
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Activating a Remote Config update failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
