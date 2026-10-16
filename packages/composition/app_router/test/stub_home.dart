import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:home_presentation/home_presentation.dart' as home_ui;

/// The Home tab's copy, which is how these tests know it is on screen.
const homePlaceholder =
    "Your app starts here. Replace this tab with the app's own main screen.";

/// Fills the slot the Home tab reads, so a composition test mounts the real tab
/// instead of dying on the permission ask it makes once drawn.
List<Override> stubHome() => [
  ...home_ui.bindProviders(askForNotifications: (ref) => () async {}),
];
