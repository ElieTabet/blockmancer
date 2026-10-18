import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_key.br.freezed.dart';

enum RemoteKeyKind { number, string }

/// One key Remote Config may publish: what it is called, what the app plays
/// with when nothing (or nothing valid) is published, and what it changes. The
/// package that reads a key describes it, so the template and the table in
/// docs are generated from the code and can't drift from it.
@freezed
abstract class RemoteKey with _$RemoteKey {
  const factory RemoteKey({
    /// The in-app default, as Remote Config would publish it.
    required String defaultValue,
    required String description,
    required RemoteKeyKind kind,
    required String name,

    /// The allowed range of a number, inclusive; a value outside it is
    /// ignored.
    num? max,
    num? min,
  }) = _RemoteKey;
}
