import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_presentation/src/routing/settings_routing.dart';

part 'providers_di.br.g.dart';

// settings_presentation — inbound dependency-injection slots. Each throws
// until the composition layer overrides it.

@riverpod
SettingsRouting settingsRouting(Ref ref) => throw UnimplementedError(
  'settingsRoutingProvider must be overridden by the composition layer (app_router)',
);

/// Opens the share sheet with [text], and answers whether it opened. [origin]
/// is the rect it points from on an iPad.
typedef ShareTextFun =
    Future<bool> Function(String text, {Rect? origin, String? subject});

@riverpod
ShareTextFun shareText(Ref ref) => throw UnimplementedError(
  'shareTextProvider must be overridden by the composition layer',
);
