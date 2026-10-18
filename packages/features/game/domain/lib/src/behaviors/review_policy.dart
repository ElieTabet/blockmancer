import 'package:game_domain/src/entities/engagement.br.dart';
import 'package:game_domain/src/entities/run_tuning.dart';
import 'package:shared_domain/shared_domain.dart';

const _cooldownKey = 'review_cooldown_days';
const _defaultCooldownDays = 60;

/// How long after asking the app waits before asking again, as Remote Config
/// publishes it (0 to 3650 days, else the default).
Duration reviewCooldownOf(RemoteValueFun valueOf) {
  final days = int.tryParse(valueOf(_cooldownKey)?.trim() ?? '');

  return Duration(
    days: days != null && days >= 0 && days <= 3650
        ? days
        : _defaultCooldownDays,
  );
}

/// The key, for the Remote Config template and its table.
const reviewKeys = [
  RemoteKey(
    defaultValue: '$_defaultCooldownDays',
    description: 'Days at least between two rating prompts',
    kind: .number,
    max: 3650,
    min: 0,
    name: _cooldownKey,
  ),
];

/// Whether to ask the OS for its rating prompt now, as a run's end has
/// finished celebrating: only after a boss win or a newly earned star, once
/// the player has finished 3 runs on at least 2 different days, never in a
/// session that hit an error, once per app version, and [cooldown] after the
/// last time.
bool reviewDue({
  required String appVersion,
  required bool bossBeaten,
  required Duration cooldown,
  required Engagement engagement,
  required bool hadError,
  required bool newStar,
  required DateTime now,
}) {
  final askedAt = engagement.reviewAskedAt;

  return (bossBeaten || newStar) &&
      engagement.completedRuns >= 3 &&
      engagement.daysOpened >= 2 &&
      !hadError &&
      engagement.reviewAskedVersion != appVersion &&
      (askedAt == null || now.difference(askedAt) >= cooldown);
}
