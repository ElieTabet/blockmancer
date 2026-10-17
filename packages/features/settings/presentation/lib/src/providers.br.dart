import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:settings_presentation/src/entities/app_language_locale.dart';
import 'package:settings_presentation/src/providers_di.br.dart' as di;
import 'package:settings_presentation/src/routing/settings_routing.dart';

part 'providers.br.g.dart';

// settings_presentation — public providers exposed by this layer.

typedef ApplyStoredLanguageFun = Future<void> Function();

/// Shows the app in the language the player chose. Startup awaits it before
/// the first frame, so a chosen language never flashes the phone's first.
@riverpod
ApplyStoredLanguageFun applyStoredLanguage(Ref ref) =>
    () async => (await ref.read(settingsProvider.future)).language.apply();

List<Override> bindRoutingProviders({
  required SettingsRouting Function(Ref ref) settingsRouting,
}) => [di.settingsRoutingProvider.overrideWith(settingsRouting)];
