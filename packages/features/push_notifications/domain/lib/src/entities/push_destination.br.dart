import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_destination.br.freezed.dart';

/// Where a tapped push leads.
///
/// Add a case per key a push carries, and resolve it in
/// `ResolvePushDestinationBehavior`.
@freezed
sealed class PushDestination with _$PushDestination {
  /// A daily reminder, by its message's id: the daily run's card.
  const factory PushDestination.dailyRun({required String messageId}) =
      DailyRunPushDestination;

  const factory PushDestination.home() = HomePushDestination;
}
