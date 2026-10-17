import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:shared_domain/shared_domain.dart';

/// A run to start: the mode it counts for, the numbers and jokers it is played
/// with, and the seed the rules play it on.
typedef RunStart = ({RunConfig config, GameMode mode, int seed});
