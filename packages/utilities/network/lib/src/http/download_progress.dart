/// Bytes received so far, and the total expected.
///
/// [total] is `-1` when the response carries no length. The publication
/// download endpoint buffers its body server-side and often sends none, so a
/// caller must handle that rather than divide by it.
typedef ProgressFun = void Function(int received, int total);
