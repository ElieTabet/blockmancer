import 'dart:ui';

import 'package:settings_domain/settings_domain.dart';

/// What the app reports about a release build on an iPhone.
const testAppDetails = AppDetails(
  build: '2',
  device: 'iPhone 15 Pro',
  os: 'iOS 18.1',
  version: '1.0.0',
);

/// A phone's mail app: records each draft it is asked to open, and opens it
/// unless [installed] is false. Throws instead when [broken].
final class FakeMailApp {
  FakeMailApp({this.broken = false, this.installed = true});

  final bool broken;
  final drafts = <Uri>[];
  final bool installed;

  Future<bool> compose(Uri mailto) async {
    if (broken) throw StateError('the platform channel failed');

    drafts.add(mailto);

    return installed;
  }
}

/// The operating system's share sheet: keeps what it was handed, and opens
/// unless [opens] is false.
final class FakeShareSheet {
  FakeShareSheet({this.opens = true});

  final bool opens;
  final shared = <({Rect? origin, String? subject, String text})>[];

  Future<bool> share(String text, {Rect? origin, String? subject}) async {
    shared.add((origin: origin, subject: subject, text: text));

    return opens;
  }
}
