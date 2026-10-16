import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_header/screen_header.dart' as screen_header;

/// Fills the slots the shared header reads, so a composition test mounts a real
/// tab with a real band on it.
///
/// Every main screen wears the header now, so without this every one of these
/// tests would die on the first tab it drew — the slots throw until composition
/// binds them, and a test container is not composition.
List<Override> stubScreenHeader() => [
  ...screen_header.bindProviders(
    isAuthenticated: (ref) async => false,
    logout: (ref) =>
        () async => throw UnimplementedError(),
    organizationName: (ref) => 'Acme Club',
  ),
];
