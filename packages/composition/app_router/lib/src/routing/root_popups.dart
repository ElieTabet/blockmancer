import 'dart:async';

import 'package:app_router/src/app_router.dart' show AppRouter;
import 'package:flutter/widgets.dart';
import 'package:splash_presentation/splash_presentation.dart' show SplashRoute;

typedef PresentPopup = Future<void> Function(BuildContext context);

/// The one gate for every popup the app raises on its own — today the update
/// offer. Popups raised from different features at about the same moment can
/// only be made to take turns here, where they are all in view.
final class RootPopups {
  static final _gates = Expando<RootPopups>();

  /// Screens a popup must not rise over: the splash replaces the stack on its
  /// way out and would sweep the popup with it, and the blocking screens
  /// already say more than any popup could.
  static final _notOver = {SplashRoute.name};

  final List<(PresentPopup, Completer<void>)> _pending = [];
  final AppRouter _router;
  bool _showing = false;

  RootPopups._(this._router);

  /// One gate per router, so every routing built on the same router shares it.
  factory RootPopups.of(AppRouter router) =>
      _gates[router] ??= RootPopups._(router);

  /// Completes once [popup] has, after every popup asked for before it. A
  /// popup that never found a screen to sit on completes without showing.
  Future<void> present(PresentPopup popup) {
    final done = Completer<void>();

    _pending.add((popup, done));

    if (!_showing) _next();

    return done.future;
  }

  void _next() {
    if (_pending.isEmpty) return;

    _showing = true;

    final (popup, done) = _pending.removeAt(0);

    _whenSettled((context) async {
      try {
        if (context != null) await popup(context);

        done.complete();
      } catch (error, stackTrace) {
        done.completeError(error, stackTrace);
      } finally {
        _showing = false;
        _next();
      }
    });
  }

  /// Waits for the stack to settle somewhere a popup may sit, then hands over
  /// the root navigator's context on the next frame — the stack changes
  /// mid-frame, and a popup cannot be pushed from there.
  void _whenSettled(void Function(BuildContext? context) then) {
    final root = _router.root;

    void presentOnceSettled() {
      final top = root.stackData.lastOrNull?.name;

      if (top == null || _notOver.contains(top)) return;

      root.removeListener(presentOnceSettled);

      // A frame is asked for too: a settled screen may have none coming, and
      // the popup would wait for whatever happened to draw next.
      WidgetsBinding.instance
        ..addPostFrameCallback((_) {
          final context = root.navigatorKey.currentContext;

          then(context != null && context.mounted ? context : null);
        })
        ..ensureVisualUpdate();
    }

    root.addListener(presentOnceSettled);
    presentOnceSettled();
  }
}
