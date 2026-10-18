import 'package:shared_domain/shared_domain.dart';

/// Builds a board from 8 rows of 8 characters: `.` empty, `#` filled, `S` stone,
/// `F` fog, `H` fog hiding a stone.
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
            'F' => const CellState.fog(hidesStone: false),
            'H' => const CellState.fog(hidesStone: true),
            _ => throw ArgumentError('unknown cell "$char"'),
          },
    ],
  );
}
