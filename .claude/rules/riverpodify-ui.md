# Riverpodify UI

The unit of rebuild is **the widget that subscribes**. So push the subscription **down** to the
smallest widget that actually renders the value, give that widget a **`const` call site**, and have
it watch the **narrowest value-comparable projection** of state — `ref.watch(p.select((s) => s.field))`,
not `ref.watch(p)`.

A parent that watches state and passes it down as constructor arguments inverts this: the parent
rebuilds on every emission, its children can't be `const`, and the whole subtree reconciles for a
change that concerned one label. Watching a whole entity in a leaf is the same mistake one level
down — any field changing rebuilds a widget that renders one field.

**The payoff scales with how often the source emits.** On a one-shot fetch a coarse watch is
harmless — the data under it never changes again. On a polled endpoint or an open gRPC stream it is
the difference between rebuilding one leaf and rebuilding a subtree on every tick. Judge the
granularity you need by the source: the streaming screens are where this is mandatory, and where
getting it wrong is a real performance bug rather than a style nit.

Companion rules: [widgets](widgets.md) (a class, not a `Widget`-returning function — that's what
gives you somewhere to *put* the subscription) and [cross-feature](cross-feature.md) (pass
identifiers, not entities).

## Rules

- **The leaf that renders the value is the widget that watches it.** Never `ref.watch` in a parent
  to pass the result into a child. If a widget needs a value only to forward it, it shouldn't have it.
- **Constructors take identifiers, not data.** `const GoalboosterBackground(goalboosterId: id)`, then
  `ref.watch(goalboosterAssetsProvider(id).select(…))` inside. An id-only constructor is what makes the
  call site `const` and keeps the parent's rebuilds from reaching the child.
- **`const` every call site you can.** A `const` widget is the *same instance* as last frame, so
  Flutter skips updating that subtree entirely. Non-`const` because a value was threaded in is the
  usual reason this is lost.
- **`.select` to the closest data you render** — a field, a formatted primitive, a boolean predicate.
  `select((state) => state is LeaderboardWonBadgeLaunched)` beats watching the state and testing the
  type in `build`, because the widget then rebuilds only when the *answer* changes.
- **Selectors must be cheap and `==`-comparable.** Safe: primitives, enums, `freezed` values, `IList`,
  and **records** — Dart records have structural equality, so `select((t) => (t.a, t.b))` is a correct
  way to grab two fields with one subscription, *provided every field in the record is itself
  value-comparable* (a record wrapping a `List` is not). Never return a freshly built `List`/`Set`/`Map`
  or a non-value object: identity equality makes the selector fire on every emission. Never do real
  work in a selector — it runs on each emission of the source.
- **One widget, one reason to rebuild.** A widget watching several unrelated selects rebuilds on all of
  those axes. Either split it, or — when it genuinely needs a combination — introduce a per-widget
  `{Feature}UiStateNotifier` exposing one `freezed` `{Feature}UiState`, so the recombination happens
  in a cached, value-compared provider and the widget keeps a single subscription.
- **In lists, the row is a `const` widget watching its own item.** `itemBuilder: (_, i) => MyRow(id: ids[i])`
  with `MyRow` watching `itemProvider(id)` — one item changing rebuilds one row, not the list.
- **Theme, l10n, and formatters are read in the leaf via `ref`**, not passed through constructors —
  same reason: it keeps the call site `const` and the parent uninvolved.
- **`AsyncValue`: select the projection you render** (`.value?.field`, `.isLoading`), not the whole
  `AsyncValue` — but keep loading/error branches explicit in the widget that actually renders them.
- **Don't over-apply.** No `.select` when the provider's value *is* the thing you use, or when you
  genuinely need the whole object — a pointless selector is noise. On one-shot data a coarse watch is
  fine; don't add selectors to a page that fetches once. Remember `.select` suppresses *rebuilds*, not
  *selector runs* — every row's selector still executes on each emission of the source, so N leaf
  subscriptions is cheap but not free. Don't shred widgets past the point of readability. And don't
  claim a rebuild win you didn't measure — for hot paths, verify it with a rebuild-count test.

## Examples

```dart
// ❌ Parent owns every subscription: one score change rebuilds the whole card,
//    and no child can be const because data is threaded through the constructors.
class MatchCard extends ConsumerWidget {
  const MatchCard({required this.matchId, super.key});

  final MatchId matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final match = ref.watch(matchProvider(matchId));

    return Column(
      children: [
        MatchTitle(title: match.title),
        MatchScore(score: match.score),
        MatchOdds(odds: match.odds),
      ],
    );
  }
}
```

```dart
// ✅ Each leaf subscribes to exactly what it draws; the card itself never rebuilds.
class MatchCard extends StatelessWidget {
  const MatchCard({required this.matchId, super.key});

  final MatchId matchId;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      MatchTitle(matchId: matchId),
      MatchScore(matchId: matchId),
      MatchOdds(matchId: matchId),
    ],
  );
}

class MatchScore extends ConsumerWidget {
  const MatchScore({required this.matchId, super.key});

  final MatchId matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(matchProvider(matchId).select((match) => match.score));

    return Text(score.label);
  }
}
```

```dart
// ❌ Fresh List in a selector — identity equality, so it "changes" on every emission
ref.watch(provider.select((state) => state.items.where((item) => item.active).toList()));

// ✅ Select a value-comparable projection instead
ref.watch(provider.select((state) => state.items.where((item) => item.active).length));

// ✅ Records are structurally equal — two fields, one subscription
final (color, border) = ref.watch(themeProvider.select((theme) => (theme.cardColor, theme.cardBorderColor)));
```

The pattern to aim for: a `const`, id-only-constructor leaf widget with one narrow `select`.
