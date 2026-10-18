#!/usr/bin/env bash

# What: stop at the first failing command (-e), treat an unset variable as an
#       error (-u), and fail a pipeline if any command in it fails (pipefail).
# Why:  a release build that carries on after a failed step could produce a
#       broken or half-configured bundle without anyone noticing.
set -euo pipefail

# Release build of the Android app against production, as an App Bundle ready
# to upload to the Play Console, with its Dart symbols sent to Crashlytics.
#
# Usage: bash scripts/build_android_release.sh [--test-tools]
#   --test-tools  a test build (Play internal testing): TEST_TOOLS on, the
#                 testers' tools and Google's test ad units; placeholders
#                 only warn.
# Also runnable via `melos run build-android` (which just calls this script).
#
# Steps:
#   1. Check everything the build needs, before spending minutes on it.
#   2. Clean and re-resolve the workspace, so the bundle is built from nothing.
#   3. Build the obfuscated, signed .aab against production.
#   4. Upload the Dart symbols, so Crashlytics can read this build's crashes.

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

# What: the repo root, worked out from where this script lives (scripts/..).
# Why:  every path below is relative to the root, so the script behaves the
#       same whichever directory it is started from.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# What: the production configuration (ENV=prod), relative to app/.
# Why:  compiled into the app; without it the build is a dev build and
#       telemetry stays off.
ENV_FILE="env/prod.json"
TEST_TOOLS=false

if [ "${1:-}" = "--test-tools" ]; then
  TEST_TOOLS=true
fi

if [ "$TEST_TOOLS" = true ]; then
  bash "$ROOT_DIR/scripts/check_release_ids.sh" --warn
else
  bash "$ROOT_DIR/scripts/check_release_ids.sh"
fi

# What: the upload key's location and passwords (kept out of git).
# Why:  Gradle reads it to sign the release; see app/android/app/build.gradle.kts.
KEY_PROPERTIES="app/android/key.properties"

# What: the Firebase config the app is built with.
# Why:  the Crashlytics app id and project id are read from it below, so they
#       can never drift from the app that actually ships.
GOOGLE_SERVICES="app/android/app/google-services.json"

# ---------------------------------------------------------------------------
# 1. Checks — fail in seconds, not after the build
# ---------------------------------------------------------------------------

# What: stop if the production configuration is missing.
# Why:  without ENV=prod the store build would be a dev build, telemetry off.
if [ ! -f "app/$ENV_FILE" ]; then
  echo "Error: app/$ENV_FILE is missing — the build would not be marked production." >&2
  exit 1
fi

# What: stop if the upload key's properties file is missing.
# Why:  without it Gradle signs with the debug key, and Play refuses the upload.
if [ ! -f "$KEY_PROPERTIES" ]; then
  echo "Error: $KEY_PROPERTIES is missing — the bundle would be signed with the debug key." >&2
  exit 1
fi

# What: pull the app id ("mobilesdk_app_id") and the project id ("project_id")
#       out of google-services.json.
# Why:  the Crashlytics upload needs the app id; the access check needs both.
FIREBASE_APP_ID="$(sed -n 's/.*"mobilesdk_app_id": *"\([^"]*\)".*/\1/p' "$GOOGLE_SERVICES" | head -n 1)"
FIREBASE_PROJECT_ID="$(sed -n 's/.*"project_id": *"\([^"]*\)".*/\1/p' "$GOOGLE_SERVICES" | head -n 1)"

echo "==> Checking Crashlytics access ($FIREBASE_PROJECT_ID)"

# What: stop if the Firebase CLI isn't installed.
# Why:  it is what uploads the symbols at the end.
if ! command -v firebase >/dev/null 2>&1; then
  echo "Error: the Firebase CLI is missing — the symbols couldn't be uploaded." >&2
  echo "       Install it: npm install -g firebase-tools" >&2
  exit 1
fi

# What: list the project's Android apps and look for this app's id in the answer.
# Why:  proves the login is still valid, the account can reach the project, and
#       the app exists in it. `firebase login:list` isn't enough: it still names
#       an account whose credentials have expired. The CLI exits 0 even when the
#       call fails, so the app id in the output is the only reliable signal.
if ! firebase apps:list ANDROID --project "$FIREBASE_PROJECT_ID" --json 2>/dev/null |
  grep -q "\"$FIREBASE_APP_ID\""; then
  echo "Error: the Firebase CLI can't reach the app in $FIREBASE_PROJECT_ID." >&2
  echo "       Log in again with an account that has access to the project:" >&2
  echo "       firebase login --reauth" >&2
  exit 1
fi

# What: the app version from app/pubspec.yaml, e.g. 1.0.0+1 — the part before
#       `+` is the versionName users see, the part after is the versionCode.
# Why:  names this build's symbols folder, and Play refuses a versionCode it has
#       already accepted.
VERSION="$(sed -n 's/^version: *//p' app/pubspec.yaml)"

# What: where this build's Dart symbols go, one folder per version.
# Why:  symbols only decode the build that produced them. It sits under the
#       root's build/ (git-ignored), outside app/, so the `flutter clean` below
#       never deletes a shipped version's symbols. Keep a copy of each shipped
#       version's folder: without it, that version's crashes stay unreadable.
SYMBOLS_DIR="$ROOT_DIR/build/debug-info/android/$VERSION"

# What: stop if this version already has symbols.
# Why:  rebuilding would overwrite the symbols of a build that may already be on
#       Play, and its crashes could never be read again.
if [ -n "$(ls -A "$SYMBOLS_DIR" 2>/dev/null)" ]; then
  echo "Error: $SYMBOLS_DIR already holds symbols for $VERSION." >&2
  echo "       Bump the build number in app/pubspec.yaml, or delete that folder if" >&2
  echo "       that build never shipped." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 2. Clean and resolve
# ---------------------------------------------------------------------------

# What: delete app/'s build output and caches.
# Why:  the shipped bundle is built from nothing, not from whatever a day of
#       debug runs left behind — the one place a clean is warranted.
echo "==> flutter clean"
cd app
flutter clean

# What: resolve the packages from the workspace root.
# Why:  the clean deleted them, and resolving from app/ alone would miss the
#       workspace packages the app depends on.
echo "==> flutter pub get (workspace root)"
cd "$ROOT_DIR"
flutter pub get

# ---------------------------------------------------------------------------
# 3. Build
# ---------------------------------------------------------------------------

# What: print the version being built.
# Why:  the first line to check when Play rejects an upload as a duplicate.
echo "==> Building $VERSION"

# What: build the release App Bundle, from app/ where the Flutter app lives.
#   appbundle             an .aab, not an .apk: Play accepts only bundles for
#                         new apps, and builds each phone's APK from it.
#   --release             optimised, minified with R8, and signed with the
#                         upload key from key.properties.
#   --obfuscate           renames the Dart code (R8 only reaches Java/Kotlin),
#                         so the app is harder to reverse-engineer.
#   --split-debug-info    writes the symbols that undo the renaming to
#                         SYMBOLS_DIR instead of shipping them; required with
#                         --obfuscate, and makes the app a little smaller.
#   --dart-define-from-file  compiles the production configuration in.
echo "==> flutter build appbundle --release --obfuscate ($ENV_FILE)"
cd app
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info="$SYMBOLS_DIR" \
  --dart-define-from-file="$ENV_FILE" \
  --dart-define=TEST_TOOLS="$TEST_TOOLS"
cd "$ROOT_DIR"

# ---------------------------------------------------------------------------
# 4. Upload the symbols
# ---------------------------------------------------------------------------

# What: the upload command, kept as text.
# Why:  printed at the end if the upload fails, so it can be retried as is.
UPLOAD_COMMAND="firebase crashlytics:symbols:upload --app=$FIREBASE_APP_ID \"$SYMBOLS_DIR\""

# What: send this build's Dart symbols to Crashlytics.
# Why:  without them, crash reports from this build show renamed functions and
#       raw addresses instead of Dart files and lines. Access was checked in
#       step 1, so a failure here is the network — and it doesn't spoil the
#       bundle: the symbols stay on disk, and crashes already received become
#       readable once they land.
echo "==> Uploading Dart symbols to Crashlytics"
if firebase crashlytics:symbols:upload --app="$FIREBASE_APP_ID" "$SYMBOLS_DIR"; then
  SYMBOLS_STATUS="uploaded to Crashlytics"
else
  SYMBOLS_STATUS="NOT uploaded — retry with:
      $UPLOAD_COMMAND"
fi

# What: a summary of what was produced and where.
# Why:  the .aab is what goes to the Play Console; the symbols folder is what
#       to back up.
echo
echo "==> Built: app/build/app/outputs/bundle/release/app-release.aab  ($VERSION)"
echo "    Symbols: $SYMBOLS_DIR"
echo "             $SYMBOLS_STATUS"
echo "    Upload the .aab in the Play Console (Test and release)."
