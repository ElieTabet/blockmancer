import 'package:settings_domain/settings_domain.dart';

/// What the app reports about a release build on an iPhone.
const testAppDetails = AppDetails(
  build: '2',
  device: 'iPhone 15 Pro',
  os: 'iOS 18.1',
  version: '1.0.0',
);

/// A phone's mail app: records each draft it is asked to open, and opens it
/// unless [installed] is false.
final class FakeMailApp {
  FakeMailApp({this.installed = true});

  final drafts = <Uri>[];
  final bool installed;

  Future<bool> compose(Uri mailto) async {
    drafts.add(mailto);

    return installed;
  }
}
