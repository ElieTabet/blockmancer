#!/usr/bin/env bash
set -euo pipefail

# Regenerate build_runner outputs and fail if the committed generated files are
# stale (i.e. regeneration produced a diff). Run from the workspace root.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

melos run generate

# --porcelain catches both modified and newly-created generated files.
DRIFT=$(git status --porcelain -- '*.g.dart' '*.gr.dart' '*.freezed.dart')

if [ -n "$DRIFT" ]; then
  echo "Generated files are out of date — regeneration changed:" >&2
  echo "$DRIFT" >&2
  echo "" >&2
  echo "Run 'melos run generate' and commit the updated generated files." >&2
  exit 1
fi

echo "Generated files are up to date."
