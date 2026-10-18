import 'package:game_domain/src/entities/run_tuning.dart';
import 'package:shared_domain/shared_domain.dart';

/// How often an interstitial may show between runs.
typedef InterstitialCaps = ({
  int everyNthRunEnd,
  int minCompletedRuns,
  Duration minGap,
});

const _everyNthKey = 'interstitial_every_n_run_ends';
const _minRunsKey = 'interstitial_min_completed_runs';
const _minSecondsKey = 'interstitial_min_seconds';

const _defaults = (
  everyNthRunEnd: 2,
  minCompletedRuns: 3,
  minGap: Duration(seconds: 90),
);

/// The caps Remote Config publishes, each falling back to its default when
/// missing, not a number, or out of its range.
InterstitialCaps interstitialCapsOf(RemoteValueFun valueOf) => (
  everyNthRunEnd:
      _intIn(valueOf(_everyNthKey), 1, 20) ?? _defaults.everyNthRunEnd,
  minCompletedRuns:
      _intIn(valueOf(_minRunsKey), 0, 100) ?? _defaults.minCompletedRuns,
  minGap: Duration(
    seconds:
        _intIn(valueOf(_minSecondsKey), 0, 3600) ?? _defaults.minGap.inSeconds,
  ),
);

/// The three keys, for the Remote Config template and its table.
final List<RemoteKey> interstitialKeys = [
  RemoteKey(
    defaultValue: '${_defaults.everyNthRunEnd}',
    description: 'An interstitial shows at most every this many run ends',
    kind: .number,
    max: 20,
    min: 1,
    name: _everyNthKey,
  ),
  RemoteKey(
    defaultValue: '${_defaults.minCompletedRuns}',
    description: 'No interstitial before this many completed runs',
    kind: .number,
    max: 100,
    min: 0,
    name: _minRunsKey,
  ),
  RemoteKey(
    defaultValue: '${_defaults.minGap.inSeconds}',
    description: 'Seconds at least between two interstitials',
    kind: .number,
    max: 3600,
    min: 0,
    name: _minSecondsKey,
  ),
];

int? _intIn(String? text, int min, int max) {
  final value = text == null ? null : int.tryParse(text.trim());

  return value != null && value >= min && value <= max ? value : null;
}
