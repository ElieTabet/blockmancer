import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/src/providers_di.br.dart' as di;

part 'consent_notifier.br.g.dart';

/// The player's consent, asked at launch where the law requires it, and
/// Analytics told the answer: granted only when ads may be requested, the
/// purpose-by-purpose detail being the consent string the form writes for
/// the SDKs. Null until it has been asked.
@Riverpod(keepAlive: true)
class ConsentNotifier extends _$ConsentNotifier {
  @override
  di.ConsentAnswer? build() => null;

  /// Once per launch, and again after the player changes their answer.
  Future<void> gather() async {
    final answer = await ref.read(di.gatherConsentProvider)();

    await ref.read(di.setAnalyticsConsentProvider)(
      granted: answer.canRequestAds,
    );

    if (ref.mounted) state = answer;
  }

  /// Reopens the form from Settings, then takes the new answer.
  Future<void> showPrivacyChoices() async {
    await ref.read(di.showPrivacyOptionsProvider)();
    await gather();
  }
}
