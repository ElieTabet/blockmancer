/// The UTC days in a row, up to [today], on which a daily run was played to
/// its end ([days], `yyyymmdd`). Today not played yet doesn't break it: it
/// breaks once a whole UTC day goes by without one.
int dailyStreakOf({required Set<int> days, required DateTime today}) {
  final start = DateTime.utc(today.year, today.month, today.day);
  var day = days.contains(_keyOf(start))
      ? start
      : start.subtract(const Duration(days: 1));
  var streak = 0;

  while (days.contains(_keyOf(day))) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }

  return streak;
}

/// How the daily run stands on [day]'s UTC day: played to its end or not,
/// and the streak then, were nothing more played until then.
({bool played, int streak}) dailyStandingOf({
  required DateTime day,
  required Set<int> days,
}) {
  final utc = day.toUtc();

  return (
    played: days.contains(_keyOf(utc)),
    streak: dailyStreakOf(days: days, today: utc),
  );
}

int _keyOf(DateTime day) => day.year * 10000 + day.month * 100 + day.day;
