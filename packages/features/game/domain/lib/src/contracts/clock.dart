/// The time now. Read through this rather than `DateTime.now()`, so a test can
/// fix the day.
abstract interface class Clock {
  DateTime now();
}
