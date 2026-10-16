// shared_domain — entities shared across features, and the contracts they are
// injected through. Entities only: no business logic, no use cases, no domain
// services. A contract's implementation lives elsewhere and composition binds it.
//
// An entity reading its own fields still counts as an entity: TokenPair knows
// whether its own expiries have passed, the same way AuthError knows its own
// cases. What would not belong here is anything that decides what to *do* about
// either.
export 'src/contracts/game_rules.dart';
export 'src/entities/errors/auth_error.br.dart';
export 'src/entities/game/board.br.dart';
export 'src/entities/game/cell.br.dart';
export 'src/entities/game/cell_state.br.dart';
export 'src/entities/game/game_event.br.dart';
export 'src/entities/game/joker_delta.br.dart';
export 'src/entities/game/joker_id.dart';
export 'src/entities/game/loss_reason.dart';
export 'src/entities/game/placement_preview.br.dart';
export 'src/entities/game/run_config.br.dart';
export 'src/entities/game/run_phase.br.dart';
export 'src/entities/game/run_state.br.dart';
export 'src/entities/game/shape.dart';
export 'src/entities/token_pair.br.dart';
