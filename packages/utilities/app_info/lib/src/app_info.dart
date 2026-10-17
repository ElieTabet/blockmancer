import 'package:flutter/foundation.dart' show immutable;

@immutable
final class AppInfo {
  const AppInfo({
    required this.build,
    required this.device,
    required this.os,
    required this.version,
  });

  final String build;

  final String device;

  final String os;

  final String version;

  @override
  bool operator ==(Object other) =>
      other is AppInfo && other._fields == _fields;

  @override
  int get hashCode => _fields.hashCode;

  (String, String, String, String) get _fields => (build, device, os, version);
}
