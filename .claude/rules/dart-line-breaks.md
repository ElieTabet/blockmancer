# Dart Block Spacing

Use vertical spacing to separate logical blocks inside methods and functions.
Tightly packed code reads as a wall of text and is hard to scan in PR review.

- Keep related setup statements grouped together.
- Insert one blank line around a large variable declaration (multi-line literal, `switch`, long chain, or declaration spanning 3+ lines) when it separates two logical steps.
- Insert one blank line before control-flow blocks (`if`, `switch`, `for`, `while`, `try`).
- Insert one blank line after a control-flow block before the next independent statement.
- Insert one blank line after early-return / guard clauses before the main logic begins.
- Keep consecutive statements without a blank line only when they belong to the same micro-step.
- Prefer this spacing in generated code and handwritten code for consistency.

## Don't overdo it

- No blank lines inside short, tight bodies (e.g. a 2-line `if` body).
- No double blank lines.
- Statements that flow naturally together (variable + immediate use on the next line) stay together.

## Scope when editing

When editing an existing tightly-packed file, only re-ventilate the regions you're touching. Don't reformat unrelated code unless explicitly asked.

## Example

```dart
void navigateRegisterBack(
  WidgetRef ref,
  BuildContext context,
  RegisterStep currentStep,
) {
  final flow = ref.read(registerFlowProvider);
  final formState = ref.read(registerFormProvider);
  final previous = flow.previousStep(currentStep, formState);

  if (previous == null) {
    ref.read(registerRoutingProvider).onFlowCompleted(context: context);
    return;
  }

  navigateRegisterToTargetStep(ref, context, previous);
}
```

## Large Declaration Example

```dart
void sendBet(Ref ref) {
  final state = ref.read(bettingSlipStateProvider);
  final selections = state.selections;

  if (selections.isEmpty) return;

  final Odds? combinedOdds = switch (selections.length) {
    1 => selections.first.odds,
    _ => switch (state.multipleBetState.status) {
      MultipleBetStatusNotCombinable() || MultipleBetStatusSingleOnly() => null,
      _ => state.multipleBetState.effectiveOdds,
    },
  };

  final payload = BetSharePayload(
    identifiers: selections.map((selection) => selection.toBetShareIdentifier()).toList(),
    selectionLabels: selections.map((selection) => selection.selectionName).toList(),
    combinedOdds: combinedOdds,
  );

  ref.read(sendBetActionProvider)(payload);
}
```
