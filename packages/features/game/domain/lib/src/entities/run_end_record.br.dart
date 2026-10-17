import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_end_record.br.freezed.dart';

/// A finished run against its mode's best, the run itself counted.
@freezed
abstract class RunEndRecord with _$RunEndRecord {
  const factory RunEndRecord({required int best, required bool isNewBest}) =
      _RunEndRecord;
}
