// settings_domain — what the player has chosen, the reset of their progress,
// and feedback and test stats for the team. No storage, no idea what progress is, and no
// device or mail app of its own: all come in through slots.
export 'src/behaviors/send_feedback_behavior.dart' show feedbackAddress;
export 'src/behaviors/test_stats_summary_behavior.dart' show testStatsSubject;
export 'src/contracts/settings_store.dart';
export 'src/entities/app_details.br.dart';
export 'src/entities/app_language.dart';
export 'src/entities/app_settings.br.dart';
export 'src/notifiers/consent_notifier.br.dart';
export 'src/notifiers/settings_notifier.br.dart';
export 'src/providers.br.dart';
export 'src/providers_di.br.dart';
