import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_presentation/src/routing/settings_routing.dart';

part 'providers_di.br.g.dart';

// settings_presentation — inbound dependency-injection slots. Each throws
// until the composition layer overrides it.

@riverpod
SettingsRouting settingsRouting(Ref ref) => throw UnimplementedError(
  'settingsRoutingProvider must be overridden by the composition layer (app_router)',
);
