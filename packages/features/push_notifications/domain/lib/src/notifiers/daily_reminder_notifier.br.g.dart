// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reminder_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The daily reminder: scheduled only for a player who has played a daily run
/// to its end, with the switch on; cancelled otherwise. Its state is the time
/// zone it was scheduled in, null when there is none, so a change of zone
/// reschedules it at the new local time.
///
/// Kept alive so that zone outlives the screens: it is read again on every
/// return to the app.

@ProviderFor(DailyReminderNotifier)
final dailyReminderProvider = DailyReminderNotifierProvider._();

/// The daily reminder: scheduled only for a player who has played a daily run
/// to its end, with the switch on; cancelled otherwise. Its state is the time
/// zone it was scheduled in, null when there is none, so a change of zone
/// reschedules it at the new local time.
///
/// Kept alive so that zone outlives the screens: it is read again on every
/// return to the app.
final class DailyReminderNotifierProvider
    extends $AsyncNotifierProvider<DailyReminderNotifier, String?> {
  /// The daily reminder: scheduled only for a player who has played a daily run
  /// to its end, with the switch on; cancelled otherwise. Its state is the time
  /// zone it was scheduled in, null when there is none, so a change of zone
  /// reschedules it at the new local time.
  ///
  /// Kept alive so that zone outlives the screens: it is read again on every
  /// return to the app.
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
    r'd4d5afd3468f01d6c6a72fbf2de574b889974010';

/// The daily reminder: scheduled only for a player who has played a daily run
/// to its end, with the switch on; cancelled otherwise. Its state is the time
/// zone it was scheduled in, null when there is none, so a change of zone
/// reschedules it at the new local time.
///
/// Kept alive so that zone outlives the screens: it is read again on every
/// return to the app.

abstract class _$DailyReminderNotifier extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
