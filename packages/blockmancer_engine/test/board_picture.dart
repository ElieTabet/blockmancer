import 'package:blockmancer_engine/blockmancer_engine.dart';

/// Builds a board from 8 rows of 8 characters: `.` empty, `#` filled, `S` stone.
/// Missing trailing rows are empty.
Board boardFrom(List<String> picture) {
  final rows = [
    ...picture,
    ...List.filled(Board.size - picture.length, '........'),
  ];

  return Board(
    cells: [
      for (final row in rows)
        for (final char in row.split(''))
          switch (char) {
            '.' => const CellState.empty(),
            '#' => const CellState.filled(colorIndex: 0),
            'S' => const CellState.stone(),
            _ => throw ArgumentError('unknown cell "$char"'),
          },
    ],
  );
}
