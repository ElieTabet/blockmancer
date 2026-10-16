# Formatting & Commas

Leave formatting to the formatter, and **never add or remove a comma on code you are not
functionally changing**. `dart format` is enforced two ways: the `.git-hooks/pre-commit` hook
formats staged Dart on every commit, and `melos run pr-check` runs `scripts/format_check.sh`
(`dart format --set-exit-if-changed` over non-generated sources). So hand-adjusting whitespace or
line breaks is never needed — and stray commas actively corrupt the diff.

## Why commas matter (the trap)

In Dart's tall style a **trailing comma is a directive**, not decoration:

- A trailing comma after the last element of an argument list, parameter list, or collection
  **forces `dart format` to split that construct one element per line**.
- With **no** trailing comma, `dart format` collapses the construct onto a **single line** when it
  fits within the page width (this workspace uses `dart format`'s default 80 cols) and only splits it when it genuinely overflows.

So adding one unnecessary trailing comma while editing a call explodes it — and often the lines
around it — into multi-line tall style. When that happens across a file, a one-line functional
change turns into a 60-line "reformat" diff. The formatter is **not** the culprit; it is faithfully
obeying the commas. The churn is caused by the comma edits and is **entirely avoidable** — proven by
removing the stray commas, which collapses the construct straight back to one line.

## Rules

- **Never add or remove a comma** (trailing or otherwise) on a line whose behavior you are not
  changing. That single character flips a construct between one-line and multi-line and buries the
  real change in reformatting noise.
- **Adding an argument/parameter/element to an existing single-line construct:** add just the
  element, keep it on one line, and do **not** introduce a trailing comma if the result still fits
  in 80 chars. Let the formatter split it only if it overflows.
- **Never reformat, re-indent, or re-break unchanged lines** — including code adjacent to your edit
  that you did not functionally change.
- **Never touch generated files** (`*.br.g.dart`, `*.br.gr.dart`, `*.g.dart`, `*.gr.dart`,
  `*.freezed.dart`, `*.config.dart`, `*.gen.dart`, `*.mocks.dart`, `*.tailor.dart`, `*.pb.dart`, …);
  they are rewritten by `build_runner`, and the pre-commit hook skips them anyway.
- If a diff shows lines you didn't functionally change flipping to multi-line, look for a stray
  trailing comma you introduced and remove it — don't accept the churn as "just the formatter".
  See [dart-line-breaks](dart-line-breaks.md) for the blank-line block spacing you *do* control.

## Alphabetical ordering

**Field declarations in a class body are sorted alphabetically**, by the declared
name, in one list — statics and instance fields together, not in separate runs.
Dart's `compareTo` is by code unit, so `_privateName` sorts before `publicName`.

```dart
// ❌ "Field declaration "_client" is out of alphabetical order."
final class NewsHttpDataSource implements NewsRepository {
  static const _feedPath = '/news-items';
  static const _readsPath = '/news-items/reads';

  final HttpClient _client;
```

```dart
// ✅ one alphabetical list, statics and instance fields alike
final class NewsHttpDataSource implements NewsRepository {
  final HttpClient _client;

  static const _feedPath = '/news-items';
  static const _readsPath = '/news-items/reads';
```

This is `custom_lints`' `prefer_field_declarations_sorted_alphabetically`, which
ships a quick-fix that rearranges them. It is an **analyzer-plugin** lint, so it
runs in the IDE only — `dart analyze` (`melos run analyze`, pr-check) does not
load the plugin and will not catch a violation. Order the fields as you write
them rather than relying on a gate that isn't there.

The same plugin orders **enum constants** on the same terms.

### Parameters

**Parameters are sorted alphabetically within their group, required before
optional** — `prefer_parameters_sorted_alphabetically`:

> Parameter "error" is out of alphabetical order within its group (required
> before optional, each group sorted). Sort required parameters alphabetically
> first, then optional parameters alphabetically.

```dart
// ❌ "Parameter "error" is out of alphabetical order within its group."
bool _launchFailed(String message, Object error, StackTrace stackTrace) {
```

```dart
// ✅ required positionals, alphabetical
bool _launchFailed(Object error, String message, StackTrace stackTrace) {
```

The groups run in this order, each sorted alphabetically inside itself:

1. a `Ref` parameter — riverpod's `Ref ref` stays first, ahead of everything
2. the other required positionals
3. optional positionals
4. required named
5. optional named, with `super.x` last — which is what keeps `super.key` at the
   end of every widget constructor

```dart
const ScreenHeader({
  required this.title,          // required named, alphabetical
  this.showSessionAction = true, // optional named, alphabetical
  this.subtitle,
  super.key,                     // super comes last
});
```

Note the lint visits **constructors and function declarations only** — it does
not look at methods. A method's parameters are unchecked by the plugin, but
order them the same way: the convention is the point, and the tool only happens
to cover part of it.
