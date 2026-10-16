# Cross-Feature Communication

Features are **sandboxed** — each owns its logic and dependencies. The import ban is not advisory:
it's enforced **structurally by the pub workspace** — a feature layer package can only import what
its `pubspec.yaml` declares, and no feature declares another feature, so a feature→feature import
simply won't resolve. Coordination happens in the **composition layer** (`packages/composition/` —
`app_router` / `app_providers`), which imports the features so they never import each other.

## Rules

- **Never import one feature from another** (`packages/features/X` → `packages/features/Y` is
  forbidden). Coordinate via **composition / DI**: a feature exposes an **interface** + a throwing
  `@riverpod` slot (e.g. `<Feature>Routing` in `providers_di.br.dart`), and the composition layer
  provides the concrete implementation via `bindRoutingProviders(...)`. See [riverpodify-ui](riverpodify-ui.md).
- **Share entities via `packages/shared_domain/`.** Shared-domain contains **entities only**; it may
  expose a provider **interface/contract**, but its **implementation must live inside a feature** (or
  the composition layer).
- **No business logic in shared_domain** — no use cases/behaviours, no domain services, no business
  rules. If shared behaviour is needed, create a dedicated feature and expose it via an interface.
- **Widget-factory-like patterns:** pass **identifiers** (`Widget func(StronglyTypedId id)`), not full
  entities, to avoid leaking domain details across boundaries.
- **Rare exception:** a shared package under `features/` is a last resort for a genuine cross-cutting
  structural concern used by many features. Prefer `shared_domain` (entities) or the composition layer
  (wiring) first; document the justification if you must.
