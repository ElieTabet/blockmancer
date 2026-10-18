#!/usr/bin/env bash
set -euo pipefail

# Refuses a release build while app/env/prod.json still holds a placeholder
# ID: a store build with one would ship without its ads, store link or
# leaderboards. docs/console-setup.md says where each real ID comes from.
#
# Usage: bash scripts/check_release_ids.sh [--warn]
#   --warn  lists the placeholders without failing (test builds, which play
#           Google's test ad units and need no store link to be tested).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IDS_FILE="$ROOT_DIR/app/env/prod.json"
LEFT="$(grep -o '"[A-Z_]*": *"PLACEHOLDER_[A-Z_]*"' "$IDS_FILE" | sed 's/:.*//' | tr -d '"' || true)"

if [ -z "$LEFT" ]; then
  exit 0
fi

if [ "${1:-}" = "--warn" ]; then
  echo "Warning: app/env/prod.json still holds placeholders (fine for a test build):" >&2
  echo "$LEFT" | sed 's/^/  - /' >&2
  exit 0
fi

echo "Error: app/env/prod.json still holds placeholders; a release build needs the real IDs:" >&2
echo "$LEFT" | sed 's/^/  - /' >&2
echo "       See docs/console-setup.md, section Placeholders." >&2
exit 1
