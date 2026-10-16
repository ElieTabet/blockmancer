# Blockmancer

A block puzzle roguelite: place pieces, clear lines, and build joker combos that change how every run plays. Climb the world map, beat bosses, and compete in a daily run with the same pieces for everyone.

| | |
|---|---|
| Bundle id / application id | `com.elietabet.blockmancer` |
| Production API | not set yet — see [NEXT_STEPS.md](NEXT_STEPS.md) |
| Modules | Firebase (Crashlytics, Analytics, push) |
| Languages | en, fr |

Built from the Foundation template: a Dart pub workspace with Melos, one package per feature
layer, Riverpod with DI slots, auto_route, freezed and slang. See [CLAUDE.md](CLAUDE.md) for how it
is put together, and [NEXT_STEPS.md](NEXT_STEPS.md) for what is left before the first release.

## Run it

```bash
dart pub get
dart run melos run prepare             # bootstrap + codegen
dart run melos run flavor-dev          # against http://localhost:8888/api/mobile/v1 (iOS simulator, macOS)
dart run melos run flavor-dev-android  # the same API from an Android emulator
dart run melos run flavor-prod         # against production (none yet: falls back to the dev API)
```

Environments live in `app/env/*.json` and reach the app as `--dart-define-from-file`.

## Check it

```bash
bash scripts/pr_check.sh   # format, analyze, dependency cycles, generated files, tests
```

## Release it

```bash
dart run melos run build-android   # obfuscated .aab — needs app/android/key.properties
dart run melos run build-ios       # obfuscated .ipa — needs Xcode signing
```

## Work on it with Claude

`.claude/` holds the project's rules, skills and agents: `flutter-developer` builds features the
way the workspace is built, and `architecture-reviewer`, `qa-reviewer` and `security-reviewer`
check a change before it is committed.
