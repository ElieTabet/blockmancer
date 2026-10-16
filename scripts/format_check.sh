#!/usr/bin/env bash
set -euo pipefail

# Check Dart formatting across hand-written sources, excluding generated files.
# Fails (exit 1) if any file is not formatted. Run from the workspace root.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Collect non-generated .dart files under app/ and packages/.
FILES=$(find app packages -type f -name '*.dart' \
  -not -path '*/.dart_tool/*' \
  -not -path '*/build/*' \
  -not -name '*.g.dart' \
  -not -name '*.gr.dart' \
  -not -name '*.freezed.dart' \
  -not -name '*.config.dart' \
  -not -name '*.mocks.dart')

if [ -z "$FILES" ]; then
  echo "No Dart files to format-check."
  exit 0
fi

# --set-exit-if-changed makes dart format exit non-zero when a file would change.
printf '%s\n' "$FILES" | xargs dart format --output none --set-exit-if-changed
