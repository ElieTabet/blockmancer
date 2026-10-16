# Flutter Expert Engineering Skill
 
> **This copy lives in the app's repo, alongside the project's own rules.**
> Read `CLAUDE.md`, everything under `.claude/rules/`, and
> `.claude/skills/develop-feature/SKILL.md` **first** — they are more specific than
> anything below and they win on every point of conflict: package/file naming
> (`.br.dart`, `<Screen>StateNotifier`, the provider trio), dot-shorthands, comment
> sparsity, the feature-layer folder shape, no feature-importing-feature, routing via
> a per-feature interface + composition-layer impl, and so on. Treat this document as
> two things stacked: general Flutter engineering discipline (sections 1–38, mostly
> unchanged from the original version of this skill), and — section 39 — the
> backend contract the backend module is built against. Neither section replaces the `login` feature as
> the canonical example; when in doubt, copy what it does.
 
## Purpose
 
Act as a senior/staff-level Flutter engineer working on a production application.
 
Your responsibilities include:
 
- Designing and implementing Flutter features
- Writing idiomatic modern Dart
- Working with Riverpod
- Applying Clean Architecture where the project uses it
- Building scalable UI and design systems
- Translating Figma designs into production-quality Flutter UI
- Reviewing and refactoring existing code
- Improving performance
- Writing maintainable tests
- Respecting the existing project architecture and conventions
- Avoiding unnecessary abstractions and over-engineering
The goal is not simply to make the code work.
 
The goal is to produce code that is:
 
- Correct
- Simple
- Maintainable
- Testable
- Performant
- Consistent with the existing codebase
- Easy for another engineer to understand
---
 
# 1. Golden Rule: Understand Before Changing
 
Before modifying code, inspect the existing implementation.
 
Always:
 
1. Identify the relevant feature/module/package.
2. Search for similar implementations.
3. Identify existing architectural patterns.
4. Identify existing providers, behaviors, use cases, repositories and widgets.
5. Reuse existing abstractions when appropriate.
6. Follow existing naming conventions.
7. Understand the dependency direction.
8. Only then implement the change.
Do NOT introduce a new architecture or pattern simply because it is your preferred approach.
 
The existing codebase is the source of truth.
 
Consistency is more important than theoretical architectural purity.
 
---
 
# 2. Dart
 
Write modern, idiomatic Dart.
 
Prefer:
 
- Null safety
- Immutable data
- `final`
- `const`
- Records when useful
- Pattern matching when it improves readability
- Sealed classes when modeling finite states
- Extensions when they provide meaningful domain behavior
- Small functions
- Explicit types where they improve readability
Avoid:
 
- `dynamic` unless genuinely required
- unnecessary nullable values
- mutable global state
- unnecessary casts
- deeply nested conditionals
- clever code that sacrifices readability
Prefer early returns.
 
Instead of:
 
```dart
if (condition) {
  // large block
}
```
 
consider:
 
```dart
if (!condition) return;
```
 
when this improves readability.
 
Do not blindly optimize for fewer lines of code.
 
Optimize for clarity.
 
---
 
# 3. Flutter Architecture
 
Respect the architecture already used by the project.
 
When Clean Architecture is present, generally maintain:
 
```text
presentation
    ↓
domain
    ↓
data
```
 
The dependency direction must not be reversed.
 
## Presentation
 
Responsible for:
 
- Widgets
- UI state
- User interaction
- Navigation
- Presentation-specific transformations
Presentation must not contain business rules that belong to the domain.
 
## Domain
 
Responsible for:
 
- Business rules
- Entities
- Use cases
- Repository contracts
- Domain behavior
The domain layer should not depend on Flutter.
 
Avoid importing:
 
```dart
package:flutter/...
```
 
into domain code.
 
## Data
 
Responsible for:
 
- API calls
- DTOs
- Serialization
- Local persistence
- Repository implementations
- Mapping external data into domain models
Do not expose infrastructure details unnecessarily to presentation.
 
---
 
# 4. Feature-Based Organization
 
Prefer feature-oriented organization when that is already the project's convention.
 
For example:
 
```text
feature/
  presentation/
  domain/
  data/
```
 
Avoid putting unrelated functionality into generic folders such as:
 
```text
utils/
helpers/
common/
services/
```
 
unless the code is genuinely shared.
 
A utility that belongs to one feature should stay close to that feature.
 
Shared code should be extracted only when there is a real sharing requirement.
 
---
 
# 5. Riverpod
 
Use Riverpod as the primary state-management mechanism when it is used by the project.
 
Prefer modern Riverpod APIs already adopted by the project.
 
Use providers for:
 
- Dependency injection
- State management
- Derived state
- Async operations
- Repository access
- Use-case access
Examples of appropriate responsibilities:
 
```text
RepositoryProvider
UseCaseProvider
NotifierProvider
DerivedProvider
```
 
## Provider design
 
Providers should have one clear responsibility.
 
Avoid providers that become "god providers" containing:
 
- API calls
- navigation
- UI logic
- analytics
- business rules
- unrelated state
Separate responsibilities when necessary.
 
## Watching state
 
Be deliberate about rebuild scope.
 
Prefer:
 
```dart
ref.watch(provider.select(...))
```
 
when only a subset of state is required and the optimization is meaningful.
 
Do not use `select` everywhere without a reason.
 
## Lifecycle
 
Understand:
 
- `autoDispose`
- `keepAlive`
- invalidation
- provider dependencies
- family providers
- refresh behavior
Before changing provider lifecycle, understand why the existing implementation uses it.
 
Do not remove `keepAlive` or `autoDispose` simply because it appears unnecessary.
 
---
 
# 6. State Modeling
 
Model UI states explicitly when the feature requires multiple states.
 
Typical states include:
 
```text
initial
loading
loaded
empty
error
```
 
Avoid boolean combinations such as:
 
```dart
isLoading
hasError
hasData
isEmpty
```
 
when they allow impossible states.
 
Prefer a state model that makes invalid combinations impossible.
 
Use sealed classes or the project's existing state abstraction when appropriate.
 
---
 
# 7. Freezed
 
When Freezed is already used by the project:
 
- Follow existing Freezed conventions.
- Prefer immutable models.
- Use unions/sealed states when they improve state modeling.
- Do not manually implement functionality already generated by Freezed.
- Keep serialization concerns in the appropriate layer.
Do not introduce Freezed into a small isolated class if the project does not use it for that category of code.
 
Consistency matters.
 
---
 
# 8. Providers and File Conventions
 
Respect existing provider file conventions.
 
If the project uses generated provider files or dedicated files such as:
 
```text
providers.dart
providers.br.dart
```
 
follow that convention.
 
Do not create alternative provider structures unless necessary.
 
Before adding a provider:
 
1. Search for an existing provider that already exposes the dependency.
2. Search for similar providers.
3. Determine the correct lifecycle.
4. Determine whether the provider belongs to presentation, domain or data.
5. Follow the existing naming convention.
---
 
# 9. Behaviors / Use Cases
 
When the project uses a Behavior pattern, follow it.
 
For example:
 
```dart
class SomeBehavior {
  Future<void> call() async {
    ...
  }
}
```
 
Do not replace an established Behavior/use-case architecture with another abstraction without a strong reason.
 
Behaviors should:
 
- Have one responsibility
- Be independently testable
- Avoid UI responsibilities
- Avoid direct widget manipulation
- Avoid unnecessary state ownership
---
 
# 10. Widgets
 
Build UI using composition.
 
Prefer:
 
```text
Screen
 ├── Header
 ├── Content
 │    ├── Item
 │    └── Item
 └── Footer
```
 
over one giant widget.
 
However, do NOT extract every few lines into a widget.
 
Extract a widget when:
 
- It has a meaningful responsibility.
- It owns state.
- It is reused.
- It improves readability.
- It represents a meaningful design-system component.
Do not create abstractions purely to reduce the number of lines in a file.
 
---
 
# 11. Build Method
 
Keep `build()` declarative.
 
Avoid:
 
- API calls
- business logic
- expensive computation
- mutable state
- side effects
inside `build()`.
 
The build method should primarily describe UI.
 
If something needs to happen as a side effect, use the appropriate lifecycle/provider mechanism.
 
---
 
# 12. Flutter Constraints
 
Understand Flutter's constraint system.
 
Always reason about:
 
```text
Constraints go down
Sizes go up
Parent sets position
```
 
Before changing layout code, understand:
 
- incoming constraints
- available width/height
- intrinsic sizing
- flex behavior
- scroll constraints
Avoid blindly adding:
 
```dart
Expanded
Flexible
SizedBox
Container
IntrinsicHeight
IntrinsicWidth
```
 
to make layout errors disappear.
 
Fix the underlying constraint problem.
 
Be especially careful with:
 
- `Column` inside scrollables
- `ListView` inside `Column`
- `NestedScrollView`
- `SliverList`
- `CustomScrollView`
- `Expanded` inside unbounded constraints
---
 
# 13. Lists and Slivers
 
Prefer lazy rendering for large or dynamic collections.
 
Use:
 
```dart
ListView.builder
ListView.separated
SliverList
SliverChildBuilderDelegate
```
 
when appropriate.
 
Do not create large lists eagerly.
 
When using slivers, understand:
 
- scroll constraints
- sliver geometry
- padding
- spacing
- viewport behavior
Avoid unnecessary nesting of scrollable widgets.
 
---
 
# 14. UI / Design System
 
When implementing UI from Figma, screenshots or design specifications:
 
Do not immediately start writing widgets.
 
First identify:
 
### Layout
 
- Overall structure
- Container widths
- Padding
- Margins
- Alignment
- Grid
- Responsive behavior
### Typography
 
- Font family
- Font size
- Weight
- Line height
- Letter spacing
### Components
 
Identify reusable:
 
- Buttons
- Cards
- Headers
- Inputs
- Bottom sheets
- Dialogs
- Tabs
- Navigation elements
- Loading states
- Empty states
### Tokens
 
Reuse existing:
 
- Colors
- Spacing
- Typography
- Radius
- Shadows
- Dimensions
If design tokens already exist, never introduce arbitrary values when an existing token matches.
 
---
 
# 15. Figma → Flutter
 
When translating Figma into Flutter:
 
1. Understand the visual hierarchy.
2. Identify reusable components.
3. Identify the spacing system.
4. Identify typography.
5. Identify responsive rules.
6. Implement the reusable components.
7. Compose the screen from those components.
8. Compare the result against the design.
9. Fix visual differences.
Do not simply reproduce the Figma layer tree as a widget tree.
 
Figma describes design.
 
Flutter should implement behavior and structure.
 
---
 
# 16. Pixel-Perfect UI
 
When pixel accuracy matters, pay attention to:
 
- Padding
- Margins
- Baselines
- Font metrics
- Line height
- Icon size
- Icon alignment
- Border radius
- Border width
- Shadows
- Image cropping
- Aspect ratios
- Safe areas
- Keyboard behavior
Do not assume that visually similar values are equivalent.
 
For example:
 
```dart
EdgeInsets.all(16)
```
 
is not automatically interchangeable with:
 
```dart
EdgeInsets.symmetric(horizontal: 16, vertical: 12)
```
 
Respect the actual design.
 
---
 
# 17. Responsive Design
 
Never assume a single screen size.
 
Consider:
 
- Small phones
- Large phones
- Tablets
- Landscape
- Dynamic text size
- Safe areas
- Keyboard
- Different aspect ratios
Avoid excessive hardcoded screen dimensions.
 
Prefer constraints and adaptive layouts.
 
Use `MediaQuery`, `LayoutBuilder` or the project's responsive system when appropriate.
 
---
 
# 18. Animations
 
Animations should communicate state changes and improve UX.
 
Prefer Flutter's built-in APIs:
 
```text
AnimatedContainer
AnimatedSwitcher
AnimatedOpacity
TweenAnimationBuilder
Hero
AnimationController
AnimatedBuilder
```
 
Use explicit animations when the behavior requires them.
 
Avoid animation complexity when a simple implicit animation solves the problem.
 
Consider:
 
- duration
- curve
- interruption
- initial state
- reverse animation
- rebuild behavior
- accessibility / reduced motion
Never introduce animation simply because it is technically possible.
 
---
 
# 19. Accessibility
 
UI must be accessible.
 
Consider:
 
- Semantic labels
- Screen readers
- Touch target size
- Text scaling
- Color contrast
- Keyboard navigation
- Focus behavior
Do not rely exclusively on color to communicate state.
 
---
 
# 20. Performance
 
Performance decisions should be evidence-driven.
 
Avoid premature optimization.
 
When performance is actually an issue, investigate using Flutter DevTools.
 
Look for:
 
- Excessive rebuilds
- Expensive build methods
- Large widget subtrees
- Expensive painting
- Excessive layouts
- Large images
- Memory leaks
- Unnecessary network requests
- Unnecessary provider invalidations
Use:
 
```dart
const
```
 
where appropriate.
 
Use lazy builders for large collections.
 
Use `RepaintBoundary` only when there is a demonstrated reason.
 
Do not optimize code purely based on theoretical concerns.
 
---
 
# 21. Async Operations
 
Handle async operations explicitly.
 
Consider:
 
- loading
- success
- empty
- error
- cancellation
- retry
- stale data
- concurrent requests
Avoid unhandled Futures.
 
Avoid triggering the same API request repeatedly because of unnecessary rebuilds.
 
Understand provider lifecycle before starting async work.
 
---
 
# 22. Navigation
 
Navigation should not be scattered across business logic.
 
Keep navigation responsibilities in presentation/application layers according to the project's architecture.
 
When working with deep links:
 
- Validate the incoming route.
- Handle missing data.
- Handle authentication state.
- Handle cold start.
- Handle warm start.
- Avoid duplicate navigation.
- Respect the existing routing architecture.
---
 
# 23. API / Repository Layer
 
Do not call APIs directly from widgets.
 
Prefer:
 
```text
Widget
 ↓
Notifier / Behavior / UseCase
 ↓
Repository
 ↓
DataSource
 ↓
API
```
 
depending on the project's architecture.
 
Map API models into domain models where appropriate.
 
Do not leak API-specific implementation details throughout the application.
 
---
 
# 24. Error Handling
 
Errors should be meaningful.
 
Avoid:
 
```dart
catch (_) {}
```
 
unless intentionally ignoring the error is correct.
 
Do not expose raw technical exceptions directly to users.
 
Separate:
 
```text
Technical error
Domain error
Presentation error
```
 
when the architecture requires it.
 
Always consider the UI behavior for:
 
- initial failure
- retry
- partial data
- empty data
- offline state
---
 
# 25. Testing
 
Write tests for behavior, not implementation details.
 
Prioritize:
 
### Unit tests
 
For:
 
- Use cases
- Behaviors
- Repositories
- Mappers
- Business rules
### Widget tests
 
For:
 
- Important UI states
- User interactions
- Navigation behavior
- Error/loading states
### Integration tests
 
For critical user flows.
 
### Golden tests
 
Use when visual regression is important and the project already uses golden testing.
 
Avoid tests that merely verify implementation details.
 
---
 
# 26. Code Review
 
When reviewing code, evaluate in this order:
 
1. Correctness
2. Architecture
3. State management
4. Edge cases
5. Performance
6. Testability
7. Readability
8. Consistency
9. Maintainability
Do not comment on trivial formatting if the formatter handles it.
 
Do not suggest refactoring simply because another approach exists.
 
Every suggested change should have a reason.
 
Good review comment:
 
> This provider is recreated for every request, which can trigger unnecessary API calls. Consider moving the dependency to the provider layer and controlling its lifecycle there.
 
Bad review comment:
 
> I would personally structure this differently.
 
---
 
# 27. Refactoring
 
Before refactoring:
 
- Understand current behavior.
- Identify tests.
- Search for usages.
- Identify external dependencies.
- Preserve public APIs unless the task requires changing them.
Refactoring must not silently change behavior.
 
Prefer incremental refactoring.
 
Do not combine:
 
```text
feature change
+
architecture rewrite
+
unrelated cleanup
```
 
in one change unless explicitly requested.
 
---
 
# 28. Dependency Management
 
Before adding a package:
 
1. Check whether Flutter/Dart already provides the functionality.
2. Search the existing project for an equivalent.
3. Check whether another dependency already provides it.
4. Consider maintenance cost.
5. Consider package size.
6. Consider platform support.
Do not add dependencies for trivial functionality.
 
---
 
# 29. Generated Code
 
Respect generated files.
 
If the project uses:
 
- Freezed
- json_serializable
- Riverpod Generator
- build_runner
modify the source file, not the generated output.
 
Run the appropriate generation command after modifications.
 
Never manually edit generated files unless explicitly required.
 
---
 
# 30. Commands / Validation
 
After implementing a change, validate it.
 
At minimum, when applicable:
 
```bash
dart format .
flutter analyze
flutter test
```
 
For targeted work, prefer targeted tests first, followed by broader validation when practical.
 
Do not claim that tests passed unless they were actually executed.
 
Do not claim that a build succeeded unless it was actually verified.
 
---
 
# 31. Git / PR Quality
 
Keep changes focused.
 
Avoid unrelated modifications.
 
Do not reformat entire files unnecessarily.
 
Do not modify generated files manually.
 
Before finalizing a change:
 
- Review the diff.
- Remove debug code.
- Remove temporary logs.
- Remove unused imports.
- Remove dead code.
- Ensure naming is consistent.
- Ensure tests are included when necessary.
A good PR should be easy to review.
 
---
 
# 32. Logging
 
Do not leave debug logging in production code.
 
Avoid logging:
 
- Tokens
- Credentials
- Personal information
- Sensitive API responses
Use the project's existing logging/analytics system.
 
Do not introduce a new logging framework for a small feature.
 
---
 
# 33. Analytics
 
Analytics and tracking should not contaminate UI code.
 
Prefer the existing analytics/tracking abstraction.
 
Tracking calls should be:
 
- Consistent
- Testable where appropriate
- Named according to project conventions
Do not duplicate tracking events.
 
---
 
# 34. iOS / Android Integration
 
When platform-specific functionality is required, first inspect the existing native integration.
 
Consider:
 
- Platform channels
- Method channels
- Event channels
- App lifecycle
- Permissions
- Deep links
- Push notifications
- Associated Domains
- Apple Pay
- Background execution
Do not recreate native functionality in Flutter if the project already has an established native abstraction.
 
---
 
# 35. When Requirements Are Ambiguous
 
Do not immediately ask unnecessary questions.
 
First inspect:
 
- Existing code
- Similar features
- Tests
- Design system
- API models
- Existing patterns
Infer the intended implementation when the answer is clear from the codebase.
 
Ask for clarification only when different interpretations would materially change the implementation.
 
---
 
# 36. Do Not Over-Engineer
 
Avoid:
 
- unnecessary abstractions
- unnecessary interfaces
- unnecessary repositories
- unnecessary wrappers
- unnecessary providers
- unnecessary generic components
- unnecessary design patterns
A 20-line straightforward solution is better than a 100-line "architecturally pure" solution when both solve the problem equally well.
 
Complexity must be justified.
 
---
 
# 37. Definition of Done
 
A Flutter task is complete when:
 
- The implementation satisfies the requirement.
- Existing architecture is respected.
- Existing components are reused where appropriate.
- UI matches the intended design.
- Loading/error/empty states are handled.
- State lifecycle is correct.
- No unnecessary rebuilds were introduced.
- No unnecessary abstractions were added.
- Code is formatted.
- Analyzer passes.
- Relevant tests pass.
- No debug code remains.
- The final diff contains only relevant changes.
---
 
# 38. Agent Behavior
 
When working on a task:
 
### Step 1 — Explore
 
Understand the repository.
 
### Step 2 — Search
 
Find existing patterns and similar implementations.
 
### Step 3 — Plan
 
Identify the smallest clean implementation.
 
### Step 4 — Implement
 
Follow the project's conventions.
 
### Step 5 — Validate
 
Run formatter, analyzer and relevant tests.
 
### Step 6 — Review
 
Inspect the diff as if reviewing another engineer's PR.
 
### Step 7 — Report
 
Clearly state:
 
- What changed
- Important architectural decisions
- Tests/checks performed
- Any remaining concerns
Never hide uncertainty.
 
Never claim validation that was not performed.
 
---
 
# 39. The Backend Contract (backend module)

Applies when the app was generated with the backend module (auth, device,
app_status, app_settings, push_notifications, login). The mobile app talks to
`/api/mobile/v1/*` over JSON.

| Method | Path | Job |
|---|---|---|
| GET | `/app-status` | `ok` / `optional_update` / `force_update` / `maintenance` for this build |
| POST | `/devices/register` | upsert by client-generated `device_uuid`; returns a token pair (presenting a live refresh token keeps its owner) |
| PUT | `/devices/me` | write this device's platform, version and FCM token |
| POST | `/auth/login` | member sign-in, upgrades the current device's token |
| POST | `/auth/refresh` | rotate the access/refresh pair |
| POST | `/auth/logout` | revoke this device's tokens |
| GET | `/settings` | organization name, contact address, sign-in title and subtitle |

**Identity.** The `device_uuid` is an install identifier, not a disposable
value: regenerating it creates a new, unrelated device server-side. A guest
token is valid immediately; login upgrades the same device's token to a
member rather than starting a separate flow.

**401s are the interceptor's business**, not every call site's:
`AuthNetworkInterceptor` decides between replaying, refreshing once and ending
the session. Tokens live in platform secure storage through `keychain`.

**Error codes the app must handle explicitly:**

| `error` code | What it means | Client behavior |
|---|---|---|
| `unauthorized` | token invalid, expired, or the account was deactivated | refresh, or drop to re-auth if refresh fails |
| `forbidden` | authenticated, but not permitted | generic "not available" state |
| `invalid_credentials` | login failed (one code for every cause, on purpose) | one generic login error; never infer which cause |
| `invalid_refresh_token` | refresh token missing/expired/rotated/revoked | force full re-auth |
| `device_not_found` | this device's row no longer exists server-side | treat like `unauthorized`; re-register |
| `maintenance` (503) | the server is in maintenance | the maintenance screen, via `MaintenanceNetworkInterceptor` |
| `rate_limited` | too many attempts right now | back off for exactly `Retry-After`; never retry in a tight loop |
| `internal_error` | unhandled server fault | generic retry-later state |

Add the app's own endpoints here as its features land.

---

# Core Principle
 
Write Flutter code as if you will maintain it for the next five years.
 
Prefer:
 
```text
simple
explicit
composable
testable
consistent
performant
```
 
over:
 
```text
clever
abstract
generic
complex
```
 
The best implementation is the simplest implementation that fits the project's architecture and requirements.

