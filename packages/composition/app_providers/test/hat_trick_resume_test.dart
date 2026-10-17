// A run saved mid-tray and resumed goes through the saved run's wire format
// and back into the engine: this is the one place both are real.

import 'dart:convert';

import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/src/dtos/saved_run_dto.br.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

/// [run] as the next launch reads it back: written, then migrated and read.
RunState _resumed(RunState run) {
  final written = jsonEncode(
    SavedRunDto.fromDomain(
      SavedRun(mode: const .practice(), run: run),
    ).toJson(),
  );

  return SavedRunDto.fromJson(
    migrate(jsonDecode(written) as Map<String, dynamic>),
  ).toDomain().run;
}

void main() {
  test('Given a tray whose first two pieces cleared, When the run is saved and '
      'resumed, Then its third clearing piece still earns Hat Trick', () {
    // Given: Hat Trick owned, rows 0 to 2 one cell short, three singles dealt
    const rules = BlockmancerEngine();
    final start = rules.startRun(
      config: rules.defaultConfig.copyWith(jokerPool: const [.hattrick]),
      seed: 1,
    );
    final (picked, _) = rules.pickJoker(start, id: .hattrick);
    var run = picked.copyWith(
      board: Board.empty().withCells({
        for (var row = 0; row < 3; row++)
          for (var col = 0; col < Board.size - 1; col++)
            Cell(col: col, row: row): const .filled(colorIndex: 0),
      }),
      tray: const [0, 0, 0],
      trayClearMask: 0,
    );
    for (final trayIndex in [0, 1]) {
      (run, _) = rules.place(
        run,
        anchor: Cell(col: 7, row: trayIndex),
        trayIndex: trayIndex,
      );
    }

    // When
    final resumed = _resumed(run);
    final (_, events) = rules.place(
      resumed,
      anchor: const Cell(col: 7, row: 2),
      trayIndex: 2,
    );

    // Then
    expect(resumed.trayClearMask, 0x3);
    expect(
      events,
      contains(
        const GameEvent.jokerFired(
          delta: .pointsAdded(amount: 300),
          joker: .hattrick,
        ),
      ),
    );
  });
}
