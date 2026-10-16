# Dart Dot Shorthands

Dart 3.10 added **dot shorthands**: when the target type is known from context, drop the
type name and write just `.member`. Use them **everywhere they apply** — enum values, static
members, static getters, named/unnamed constructors, and static factories — for shorter, less
noisy code. The context type comes from the variable's declared type, a parameter type, a
return type, a `case` pattern, a collection element type, or the operands of `==`.

## Rules

- **Prefer the shorthand** whenever a context type is available and the analyzer accepts it —
  don't spell out the type name redundantly.
- **Never introduce an explicit type just to enable a shorthand**, and never remove an existing
  shorthand to "be explicit". If context is missing (e.g. `var`/`final` with an inferred type,
  or the type genuinely can't be resolved), keep the full name — the shorthand won't compile.
- Applies to handwritten code; **leave generated `*.br.g.dart` / `*.g.dart` etc. untouched**.
- When editing existing code, convert redundant fully-qualified references in the region you
  touch — but don't reformat or re-touch unrelated lines (see [formatting](formatting.md)).

## Examples

```dart
// Enum values / static members with a known context type
Brightness brightness = .dark;                 // not Brightness.dark
setMode(.light);                                // parameter type drives it
return switch (status) {
  .pending => ...,                              // case pattern on a known enum
  .settled => ...,
};

// Named constructors / static factories
Duration timeout = .zero;                       // not Duration.zero
EdgeInsets padding = .all(DSSpace.medium);      // not EdgeInsets.all(DSSpace.medium)
final Alignment a = .center;                    // context from the declared type

// Collections carry the element type into each element
List<Axis> axes = [.horizontal, .vertical];
```

```dart
// No context type → shorthand won't compile, keep the full name
final mode = ThemeMode.dark;                    // `final`, inferred type, no target type
```
