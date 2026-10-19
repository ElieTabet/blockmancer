// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reminder_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The daily reminders: a week of them, planned afresh on every app start and
/// return, on a change of the Settings switch or of the app's language, and
/// at a daily run's end (see [PlanDailyRemindersBehavior]). Only for a player
/// who has played a daily run to its end, with the switch on; cancelled
/// otherwise. Its state is the plan.
///
/// Kept alive so the plan follows the switch and the language for the app's
/// life.

@ProviderFor(DailyReminderNotifier)
final dailyReminderProvider = DailyReminderNotifierProvider._();

/// The daily reminders: a week of them, planned afresh on every app start and
/// return, on a change of the Settings switch or of the app's language, and
/// at a daily run's end (see [PlanDailyRemindersBehavior]). Only for a player
/// who has played a daily run to its end, with the switch on; cancelled
/// otherwise. Its state is the plan.
///
/// Kept alive so the plan follows the switch and the language for the app's
/// life.
final class DailyReminderNotifierProvider
    extends
        $AsyncNotifierProvider<DailyReminderNotifier, List<PlannedReminder>> {
  /// The daily reminders: a week of them, planned afresh on every app start and
  /// return, on a change of the Settings switch or of the app's language, and
  /// at a daily run's end (see [PlanDailyRemindersBehavior]). Only for a player
  /// who has played a daily run to its end, with the switch on; cancelled
  /// otherwise. Its state is the plan.
  ///
  /// Kept alive so the plan follows the switch and the language for the app's
  /// life.
  DailyReminderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderNotifierHash();

  @$internal
  @override
  DailyReminderNotifier create() => DailyReminderNotifier();
}

String _$dailyReminderNotifierHash() =>
    r'6561a68a6bfc677e3adc7df2370fc50f5e21f289';

/// The daily reminders: a week of them, planned afresh on every app start and
/// return, on a change of the Settings switch or of the app's language, and
/// at a daily run's end (see [PlanDailyRemindersBehavior]). Only for a player
/// who has played a daily run to its end, with the switch on; cancelled
/// otherwise. Its state is the plan.
///
/// Kept alive so the plan follows the switch and the language for the app's
/// life.

abstract class _$DailyReminderNotifier
    extends $AsyncNotifier<List<PlannedReminder>> {
  FutureOr<List<PlannedReminder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PlannedReminder>>, List<PlannedReminder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PlannedReminder>>,
                List<PlannedReminder>
              >,
              AsyncValue<List<PlannedReminder>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
