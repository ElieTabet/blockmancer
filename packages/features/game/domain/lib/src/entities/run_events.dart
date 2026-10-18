import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:game_domain/src/entities/progression_change.br.dart';
import 'package:shared_domain/shared_domain.dart';

/// What a move did, as analytics counts it. A run starts at its starting
/// pick, as saving does, so a run opened by mistake and left counts nothing.
/// A round ends when it is won, or when a lost round is given up: a revive
/// plays it on. A revive itself is counted by `trackRevive`, which knows what
/// paid for it.
List<AnalyticsEvent> runEventsOf(
  GameMode mode,
  RunState before,
  Transition transition,
) {
  final (after, events) = transition;
  final picked = after.jokers.length > before.jokers.length;

  return [
    if (picked && before.pickIndex == 0)
      .runStart(mode: _kindOf(mode), world: after.config.world),
    if (before.phase case PickingJokerPhase(:final offers) when picked)
      .jokerPick(id: after.jokers.last, offered: offers),
    for (final event in events)
      ...switch (event) {
        RoundWon(:final roundIndex, :final score) => <AnalyticsEvent>[
          .roundEnd(round: roundIndex + 1, score: score, won: true),
        ],
        _ => const <AnalyticsEvent>[],
      },
    if (before.phase is RoundLostPhase && after.phase is OverPhase)
      .roundEnd(round: before.roundIndex + 1, score: before.score, won: false),
  ];
}

/// How a finished run ended, with what it earned on the map: nothing outside
/// a world run, or when what it earned could not be kept.
List<AnalyticsEvent> runEndEventsOf(RunState run, ProgressionChange? change) {
  final newStars = change?.newStars;
  final unlockedWorld = change?.unlockedWorld;

  return [
    .runEnd(
      starsEarned: [
        newStars?.bossBeaten,
        newStars?.noRevive,
        newStars?.scoreThreshold,
      ].where((earned) => earned ?? false).length,
      total: run.runTotal,
      won: run.phase is WonPhase,
    ),
    if (unlockedWorld != null) .worldUnlock(world: unlockedWorld),
  ];
}

RunKind _kindOf(GameMode mode) => switch (mode) {
  DailyMode() => .daily,
  PracticeMode() => .practice,
  WorldMode() => .world,
};
