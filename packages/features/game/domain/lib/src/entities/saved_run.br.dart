import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:shared_domain/shared_domain.dart';

part 'saved_run.br.freezed.dart';

/// A run left unfinished, to pick up where it stood.
@freezed
abstract class SavedRun with _$SavedRun {
  const factory SavedRun({required GameMode mode, required RunState run}) =
      _SavedRun;
}
