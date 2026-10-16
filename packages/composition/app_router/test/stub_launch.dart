import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:splash_presentation/splash_presentation.dart' as splash_ui;

/// Fills the slots the launch screens read. The splash is told it may not
/// launch, so a test that lands on it stays there instead of routing on its
/// own; the update-required screen finds no store listing.
List<Override> stubLaunch() => [
  ...splash_ui.bindProviders(
    checkAppStatus: (ref) =>
        () async => false,
    isAuthenticated: (ref) async => false,
    prepareDevice: (ref) => () async {},
    refreshSettings: (ref) => () async {},
  ),
];
