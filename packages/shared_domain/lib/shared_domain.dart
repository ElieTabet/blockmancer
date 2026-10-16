// shared_domain — entities shared across features. Entities only: no business
// logic, no use cases, no domain services.
//
// An entity reading its own fields still counts as an entity: TokenPair knows
// whether its own expiries have passed, the same way AuthError knows its own
// cases. What would not belong here is anything that decides what to *do* about
// either.
export 'src/entities/errors/auth_error.br.dart';
export 'src/entities/token_pair.br.dart';
