import 'package:app_info/src/app_info.dart';
import 'package:app_info/src/package_name.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timber/timber.dart';

const _unknown = 'unknown';

/// Reads the app's version and the device it runs on, for Settings and a
/// feedback email.
///
/// Never throws: each half that fails reads as "unknown", so a feedback email
/// still opens with whatever could be read.
Future<AppInfo> readAppInfo({
  @visibleForTesting Future<BaseDeviceInfo> Function()? loadDeviceInfo,
  @visibleForTesting Future<PackageInfo> Function()? loadPackageInfo,
}) async {
  final ((build, version), (device, os)) = await (
    _readPackage(loadPackageInfo ?? PackageInfo.fromPlatform),
    _readDevice(loadDeviceInfo ?? () => DeviceInfoPlugin().deviceInfo),
  ).wait;

  return AppInfo(build: build, device: device, os: os, version: version);
}

String _orUnknown(String value) => value.isEmpty ? _unknown : value;

/// Caught whatever the error: besides the channel's own exceptions, the plugin
/// casts the native map field by field, so a missing field is a `TypeError`.
Future<(String, String)> _readDevice(
  Future<BaseDeviceInfo> Function() load,
) async {
  try {
    return switch (await load()) {
      final IosDeviceInfo info => (
        _orUnknown(info.modelName.isEmpty ? info.model : info.modelName),
        _orUnknown('${info.systemName} ${info.systemVersion}'.trim()),
      ),
      final AndroidDeviceInfo info => (
        _orUnknown(_androidDevice(info.manufacturer, info.model)),
        'Android ${info.version.release} (SDK ${info.version.sdkInt})',
      ),
      _ => (_unknown, _unknown),
    };
  } catch (error, stackTrace) {
    Timber.e(
      tag: packageName,
      logMessage: 'Reading the device failed',
      exception: error,
      stackTrace: stackTrace,
    );

    return (_unknown, _unknown);
  }
}

/// Some makers already lead the model with their name ("OnePlus 9"), which
/// would otherwise read twice.
String _androidDevice(String manufacturer, String model) {
  if (model.toLowerCase().startsWith(manufacturer.toLowerCase())) return model;

  return '$manufacturer $model'.trim();
}

Future<(String, String)> _readPackage(
  Future<PackageInfo> Function() load,
) async {
  try {
    final info = await load();

    return (_orUnknown(info.buildNumber), _orUnknown(info.version));
  } catch (error, stackTrace) {
    Timber.e(
      tag: packageName,
      logMessage: 'Reading the app version failed',
      exception: error,
      stackTrace: stackTrace,
    );

    return (_unknown, _unknown);
  }
}
