#!/usr/bin/env bash
set -euo pipefail

# Release build of the iOS app against production, obfuscated and exported as
# an .ipa ready to upload to TestFlight, with its Dart symbols sent to
# Crashlytics.
#
# Usage: bash scripts/build_ios_release.sh
# Also runnable via `melos run build-ios` (which just calls this script).
#
# `build ipa` rather than `build ios`: the latter stops at a .app, which nothing
# can upload. This archives and exports in one step, using the automatic signing
# already configured on the Runner target.
#
# `flutter clean` first, deliberately: this is the artefact that ships, so it is
# built from nothing rather than from whatever a day of debug runs left behind.
# That is the one context where clearing the build directory is the right call —
# everyday work should never need it.
#
# The clean takes the workspace's resolved packages with it, so `pub get` is run
# from the root before building. `flutter build` would otherwise resolve `app`
# on its own and miss the workspace members it depends on.
#
# Two kinds of symbols reach Crashlytics, and this script owns only one. The
# dSYMs (native frames) are uploaded by the Runner target's "Upload Crashlytics
# symbols" build phase. The Dart symbols that undo --obfuscate are uploaded
# here — without them, Dart errors from this build show only renamed frames.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ENV_FILE="env/prod.json"
GOOGLE_SERVICE_INFO="app/ios/Runner/GoogleService-Info.plist"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Error: an iOS build needs macOS with Xcode; this is $(uname -s)." >&2
  exit 1
fi

if [ ! -f "app/$ENV_FILE" ]; then
  echo "Error: app/$ENV_FILE is missing — the build would not be marked production." >&2
  exit 1
fi

# Read from the plist the app is built with, so the upload can never target a
# different app than the one that ships.
FIREBASE_APP_ID="$(/usr/libexec/PlistBuddy -c 'Print :GOOGLE_APP_ID' "$GOOGLE_SERVICE_INFO")"
FIREBASE_PROJECT_ID="$(/usr/libexec/PlistBuddy -c 'Print :PROJECT_ID' "$GOOGLE_SERVICE_INFO")"

echo "==> Checking Crashlytics access ($FIREBASE_PROJECT_ID)"

if ! command -v firebase >/dev/null 2>&1; then
  echo "Error: the Firebase CLI is missing — the symbols couldn't be uploaded." >&2
  echo "       Install it: npm install -g firebase-tools" >&2
  exit 1
fi

# `firebase login:list` still names an account whose credentials have expired,
# and the CLI exits 0 when the call fails, so the app id in the answer is the
# only reliable proof that the upload at the end will be accepted.
if ! firebase apps:list IOS --project "$FIREBASE_PROJECT_ID" --json 2>/dev/null |
  grep -q "\"$FIREBASE_APP_ID\""; then
  echo "Error: the Firebase CLI can't reach the app in $FIREBASE_PROJECT_ID." >&2
  echo "       Log in again with an account that has access to the project:" >&2
  echo "       firebase login --reauth" >&2
  exit 1
fi

# App Store Connect refuses a build number it has already accepted for this
# version, so this is the line to check when an upload comes back as a duplicate.
VERSION="$(sed -n 's/^version: *//p' app/pubspec.yaml)"

# Under the root's build/ (git-ignored), outside app/, so the clean below never
# deletes a shipped version's symbols. They only decode the build that produced
# them: keep a copy of each shipped version's folder.
SYMBOLS_DIR="$ROOT_DIR/build/debug-info/ios/$VERSION"

if [ -n "$(ls -A "$SYMBOLS_DIR" 2>/dev/null)" ]; then
  echo "Error: $SYMBOLS_DIR already holds symbols for $VERSION." >&2
  echo "       Bump the build number in app/pubspec.yaml, or delete that folder if" >&2
  echo "       that build never shipped." >&2
  exit 1
fi

echo "==> flutter clean"
cd app
flutter clean

echo "==> flutter pub get (workspace root)"
cd "$ROOT_DIR"
flutter pub get

echo "==> Building $VERSION"

echo "==> flutter build ipa --release --obfuscate ($ENV_FILE)"
cd app
flutter build ipa --release \
  --export-method app-store \
  --obfuscate \
  --split-debug-info="$SYMBOLS_DIR" \
  --dart-define-from-file="$ENV_FILE"
cd "$ROOT_DIR"

UPLOAD_COMMAND="firebase crashlytics:symbols:upload --app=$FIREBASE_APP_ID \"$SYMBOLS_DIR\""

# Access was checked up front, so a failure here is the network — and it doesn't
# spoil the .ipa: the symbols stay on disk, and crashes already received become
# readable once they land.
echo "==> Uploading Dart symbols to Crashlytics"
if firebase crashlytics:symbols:upload --app="$FIREBASE_APP_ID" "$SYMBOLS_DIR"; then
  SYMBOLS_STATUS="uploaded to Crashlytics"
else
  SYMBOLS_STATUS="NOT uploaded — retry with:
      $UPLOAD_COMMAND"
fi

echo
echo "==> Built: app/build/ios/ipa/*.ipa  ($VERSION)"
echo "    Symbols: $SYMBOLS_DIR"
echo "             $SYMBOLS_STATUS"
echo "    Upload with Transporter, or open app/build/ios/archive/Runner.xcarchive"
echo "    in Xcode's Organizer and choose Distribute App."
