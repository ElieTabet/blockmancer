# Providers: one file per role, never two named the same

A package exposes providers through **at most two** files under `lib/src/`:

- **`providers.br.dart`** — everything this package publishes: its `@riverpod`
  providers, the typedefs they return, **and** the `bindProviders(...)` helper.
- **`providers_di.br.dart`** — inbound DI slots: `@riverpod` providers that throw
  until something outside overrides them.

Layer-internal providers, not exported from the barrel, go in
`providers_internal.br.dart`.

## Rules

- **Never have both `providers.br.dart` and `providers.dart` in one package.** Fold them
  into `providers.br.dart`. Two files whose names differ only by `.br` is a coin-flip
  every time someone adds a provider, and the split is invisible at the import site.
- **The merged file keeps the `.br` suffix**, because it hosts `@riverpod` and therefore
  has a generated companion — see the `.br` convention in CLAUDE.md. A package with *no*
  codegen at all (only a `bindProviders` helper) uses a plain `providers.dart`; that is
  the one case where the unsuffixed name is correct.
- **`bindProviders(...)` is the name of every binding helper** — not
  `bindNetworkProviders`, not `bindAuthDomainProviders`. Callers disambiguate with an
  import prefix (`login.bindProviders(...)`, `network.bindProviders(...)`). Routing keeps
  its own `bindRoutingProviders(...)`.
- **A `bindProviders` helper only overrides slots; it never contains logic.** If wiring
  two things together requires a decision — combining them, mapping an error, choosing a
  result — that decision belongs in the package that owns the meaning, exposed as its own
  provider. The composition layer wires; it does not interpret.

## Why the last rule matters

`splash_domain` declares slots for "run the once-per-launch work" and "is there a valid
session", and composes them into a verdict **itself**. The composition layer only
says which functions fill those slots. Putting that composition in `app_providers` would
have hidden a real product decision in the wiring, where nothing tests it and no feature
owner would look for it.
