#!/usr/bin/env bash
set -euo pipefail

# Builds the app against production for Android, iOS or both, asking for
# whatever isn't passed.
#
# Usage: bash scripts/build.sh [--platform android|ios|both]
#                              [--release | --test | --no-release]
#                              [--version x.y.z+build] [--dry-run]
# Also runnable via `melos run build` (which just calls this script).
#
# Release builds are the store artefacts — exactly `melos run build-android` /
# `build-ios`: cleaned, obfuscated, with their Dart symbols sent to Crashlytics.
# Test builds are the same with the testers' tools on — exactly
# `build-android-test` / `build-ios-test`, for Play internal testing and
# TestFlight — and are named `-test` so they're never taken for the store build.
#
# Installable builds are for sharing or sideloading: on Android a release APK
# signed with the upload key, on iOS an ad-hoc .ipa, which installs only on the
# devices in the provisioning profile. Neither is obfuscated, so their crashes
# need no symbols.
#
# Every artefact is copied to build/outputs/ (git-ignored), named after the
# version and commit: a release build's `flutter clean` would otherwise delete
# the previous platform's artefact from app/build/.
#
# The version (Enter keeps the current one) is written to app/pubspec.yaml
# before building, because the release scripts and their symbols folders read
# it there: commit the bump with the release.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ENV_FILE="env/prod.json"
OUT_DIR="$ROOT_DIR/build/outputs"

PLATFORM=""
MODE=""
VERSION=""
DRY_RUN=false
ARTEFACTS=()

usage() {
  sed -n '7,10p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    --platform)
      if [ $# -lt 2 ]; then
        echo "Error: --platform needs a value." >&2
        exit 64
      fi
      PLATFORM="$2"
      shift 2
      ;;
    --version)
      if [ $# -lt 2 ]; then
        echo "Error: --version needs a value." >&2
        exit 64
      fi
      VERSION="$2"
      shift 2
      ;;
    --release) MODE="release"; shift ;;
    --test) MODE="test"; shift ;;
    --no-release) MODE="installable"; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h | --help) usage; exit 0 ;;
    *)
      echo "Error: unknown option $1." >&2
      usage >&2
      exit 64
      ;;
  esac
done

# The prompts read and write the terminal itself rather than stdin/stdout, so
# they work however the script is started — melos included.
has_terminal() { { : </dev/tty; } 2>/dev/null; }

# choose <variable> <question> <option>... — sets the variable to the first
# word of the option picked from a numbered menu.
choose() {
  local variable="$1" question="$2"
  shift 2
  local options=("$@") answer i

  if ! has_terminal; then
    echo "Error: no terminal to ask \"$question\" — pass it as an option." >&2
    usage >&2
    exit 64
  fi

  echo "$question" >/dev/tty
  for i in "${!options[@]}"; do
    echo "  $((i + 1))) ${options[$i]}" >/dev/tty
  done

  while true; do
    printf '> ' >/dev/tty
    read -r answer </dev/tty

    if [[ "$answer" =~ ^[0-9]+$ ]] && [ "$answer" -ge 1 ] && [ "$answer" -le "${#options[@]}" ]; then
      printf -v "$variable" '%s' "${options[$((answer - 1))]%% *}"
      echo >/dev/tty
      return
    fi

    echo "  Pick a number from 1 to ${#options[@]}." >/dev/tty
  done
}

is_version() { [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$ ]]; }

# Sets VERSION, asking again until it reads x.y.z+build; Enter keeps the
# current one.
ask_version() {
  local answer

  echo "Version? (x.y.z+build — Enter keeps $CURRENT_VERSION)" >/dev/tty

  while true; do
    printf '> ' >/dev/tty
    read -r answer </dev/tty
    answer="${answer:-$CURRENT_VERSION}"

    if is_version "$answer"; then
      VERSION="$answer"
      echo >/dev/tty
      return
    fi

    echo "  Write it as x.y.z+build, e.g. 1.2.0+7." >/dev/tty
  done
}

if [ -z "$PLATFORM" ]; then
  choose PLATFORM "Which platform?" "android" "ios" "both"
fi

case "$PLATFORM" in
  android | ios | both) ;;
  *)
    echo "Error: --platform must be android, ios or both, not \"$PLATFORM\"." >&2
    exit 64
    ;;
esac

if [ -z "$MODE" ]; then
  choose MODE "Which build?" \
    "installable  an APK / .ipa to share or sideload" \
    "test         the store build with the testers' tools, for Play internal testing / TestFlight" \
    "release      the store build (.aab / .ipa), obfuscated, symbols to Crashlytics"
fi

CURRENT_VERSION="$(sed -n 's/^version: *//p' app/pubspec.yaml)"

# With no terminal to ask, the current version is built.
if [ -z "$VERSION" ] && has_terminal; then
  ask_version
fi
VERSION="${VERSION:-$CURRENT_VERSION}"

if ! is_version "$VERSION"; then
  echo "Error: --version must read x.y.z+build (e.g. 1.2.0+7), not \"$VERSION\"." >&2
  exit 64
fi

if [ "$PLATFORM" != "android" ] && [ "$(uname -s)" != "Darwin" ]; then
  echo "Error: an iOS build needs macOS with Xcode; this is $(uname -s)." >&2
  exit 1
fi

# The release scripts refuse a placeholder id themselves; an installable build
# never reaches a store, so it only lists them.
if [ "$MODE" = "installable" ]; then
  bash scripts/check_release_ids.sh --warn
fi

# Read before the version is written, so the bump alone doesn't mark it dirty.
COMMIT="$(git rev-parse --short HEAD)"
if [ -n "$(git status --porcelain)" ]; then
  COMMIT="$COMMIT-dirty"
fi

if [ "$VERSION" != "$CURRENT_VERSION" ]; then
  echo "+ app/pubspec.yaml: version $CURRENT_VERSION -> $VERSION"
  if ! $DRY_RUN; then
    sed "s/^version: .*/version: $VERSION/" app/pubspec.yaml >app/pubspec.yaml.tmp
    mv app/pubspec.yaml.tmp app/pubspec.yaml
  fi
fi

NAME="blockmancer-${VERSION/+/-}-prod-$COMMIT"
if [ "$MODE" = "test" ]; then
  NAME="$NAME-test"
fi

run() {
  echo "+ $*"
  if ! $DRY_RUN; then "$@"; fi
}

run_in_app() {
  echo "+ (app) $*"
  if ! $DRY_RUN; then (cd app && "$@"); fi
}

# collect <built path> <extension> — copies an artefact out of app/build/.
collect() {
  local from="$1" to="$OUT_DIR/$NAME.$2"

  echo "+ cp $from $to"
  if ! $DRY_RUN; then
    if [ ! -f "$from" ]; then
      echo "Error: the build reported success, but \"$from\" isn't there." >&2
      exit 1
    fi
    mkdir -p "$OUT_DIR"
    cp "$from" "$to"
  fi
  ARTEFACTS+=("$to")
}

# release_script <script> — the store build, with the testers' tools on for a
# test build.
release_script() {
  if [ "$MODE" = "test" ]; then
    run bash "$1" --test-tools
  else
    run bash "$1"
  fi
}

# The .ipa is named after the app's display name, so it is found, not spelled.
built_ipa() {
  if $DRY_RUN; then
    echo "app/build/ios/ipa/<App>.ipa"
  else
    find app/build/ios/ipa -maxdepth 1 -name '*.ipa' 2>/dev/null | head -n 1
  fi
}

build_android() {
  echo "==> Android ($MODE)"

  if [ "$MODE" != "installable" ]; then
    release_script scripts/build_android_release.sh
    collect app/build/app/outputs/bundle/release/app-release.aab aab
    return
  fi

  if [ ! -f app/android/key.properties ]; then
    echo "Warning: app/android/key.properties is missing — the APK is signed with the debug key." >&2
  fi
  run_in_app flutter build apk --release --dart-define-from-file="$ENV_FILE"
  collect app/build/app/outputs/flutter-apk/app-release.apk apk
}

build_ios() {
  echo "==> iOS ($MODE)"

  if [ "$MODE" != "installable" ]; then
    release_script scripts/build_ios_release.sh
  else
    run_in_app flutter build ipa --release --export-method ad-hoc --dart-define-from-file="$ENV_FILE"
  fi
  collect "$(built_ipa)" ipa
}

case "$PLATFORM" in
  android) build_android ;;
  ios) build_ios ;;
  both)
    build_android
    build_ios
    ;;
esac

echo
echo "==> Built against prod ($VERSION, $COMMIT):"
for artefact in "${ARTEFACTS[@]}"; do
  echo "    $artefact"
done
