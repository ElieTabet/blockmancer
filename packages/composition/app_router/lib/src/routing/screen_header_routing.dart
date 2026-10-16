import 'package:flutter/widgets.dart';
import 'package:screen_header/screen_header.dart' show ScreenHeaderRouting;

/// Where the header's sign-in control goes.
///
/// A separate class from [SessionRoutingImpl], which answers for a session
/// *ending*: that one navigates through the [AppRouter] instance because its
/// trigger is a 401 deep in the network layer with no widget behind it. This
/// one is a tap, so it takes the context and resolves the router from it.
///
/// Both end at [presentLogin], which is the point: login rises over whatever
/// the member was looking at, and dismissing drops them back onto it.
final class ScreenHeaderRoutingImpl implements ScreenHeaderRouting {
  const ScreenHeaderRoutingImpl();

  @override
  void onSignInRequested(BuildContext context) {
    assert(
      context.mounted,
      'onSignInRequested called with an unmounted context',
    );
    // No login screen, so the header never offers a sign-in.
  }
}
