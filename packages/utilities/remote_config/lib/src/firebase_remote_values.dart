import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_config/src/package_name.dart';
import 'package:remote_config/src/remote_values.dart';
import 'package:timber/timber.dart';

/// Firebase Remote Config behind [RemoteValues]. In-app defaults live with the
/// code that reads each key, not in the SDK, so only a value actually
/// published counts.
final class FirebaseRemoteValues implements RemoteValues {
  final FirebaseRemoteConfig? _injected;
  final Duration _minimumFetchInterval;

  static const _fetchTimeout = Duration(seconds: 10);

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
  Future<void> fetchAndActivate() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: _fetchTimeout,
          minimumFetchInterval: _minimumFetchInterval,
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Fetching Remote Config failed',
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
}
