// result — the workspace's Result type.
//
// A failure that a caller is expected to handle is a *return value*, not an
// exception: the signature then says so, and the compiler makes ignoring it a
// visible choice. Exceptions stay for what genuinely is exceptional.
//
// `result_dart`'s own `Result`/`AsyncResult` are hidden so the shorter names
// below (which take the error type as a parameter) are the ones in scope.
export 'package:result_dart/result_dart.dart' hide AsyncResult, Result;

export 'src/entities/result_types.dart';
