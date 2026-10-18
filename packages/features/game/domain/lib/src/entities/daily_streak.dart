/// The UTC days in a row, up to [today], on which a daily run was played to
/// its end ([days], `yyyymmdd`). Today not played yet doesn't break it: it
/// breaks once a whole UTC day goes by without one.
int dailyStreakOf({required Set<int> days, required DateTime today}) {
  int keyOf(DateTime day) => day.year * 10000 + day.month * 100 + day.day;

  final start = DateTime.utc(today.year, today.month, today.day);
  var day = days.contains(keyOf(start))
      ? start
      : start.subtract(const Duration(days: 1));
  var streak = 0;

  while (days.contains(keyOf(day))) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }

  return streak;
}
