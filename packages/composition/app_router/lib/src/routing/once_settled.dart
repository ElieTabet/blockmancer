import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

/// Calls [open] on the frame after [root]'s stack settles with a route not in
/// [waitsOut] on top, handing it that route's name. The stack changes
/// mid-frame, and a route pushed from there lands under the one still
/// arriving; a frame is asked for too, as a settled screen may have none
/// coming.
void onceSettled(
  StackRouter root, {
  required FutureOr<void> Function(String top) open,
  required Set<String> waitsOut,
}) {
  void openOnceSettled() {
    final top = root.stackData.lastOrNull?.name;

    if (top == null || waitsOut.contains(top)) return;

    root.removeListener(openOnceSettled);

    WidgetsBinding.instance
      ..addPostFrameCallback((_) => unawaited(Future.sync(() => open(top))))
      ..ensureVisualUpdate();
  }

  root.addListener(openOnceSettled);
  openOnceSettled();
}
