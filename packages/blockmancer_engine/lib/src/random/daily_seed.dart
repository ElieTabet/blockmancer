/// The daily run's seed: the UTC date as `yyyymmdd`. The engine has no clock,
/// so the caller says what day it is.
int dailySeed({required int day, required int month, required int year}) =>
    year * 10000 + month * 100 + day;
