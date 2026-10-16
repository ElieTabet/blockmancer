import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_destination.br.freezed.dart';

/// Where a tapped push leads.
///
/// One case until the app has screens a push can be about: add a case per key
/// the server sends, and resolve it in `ResolvePushDestinationBehavior`.
@freezed
sealed class PushDestination with _$PushDestination {
  const factory PushDestination.home() = HomePushDestination;
}
