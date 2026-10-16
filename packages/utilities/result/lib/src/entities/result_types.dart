import 'package:result_dart/result_dart.dart' hide AsyncResult, Result;

/// An operation that can fail, with nothing useful to return on success.
typedef AsyncUnitResult<E extends Object> = AsyncResultDart<Unit, E>;

typedef AsyncResult<T extends Object, E extends Object> = AsyncResultDart<T, E>;

typedef Result<T extends Object, E extends Object> = ResultDart<T, E>;
