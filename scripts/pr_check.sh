#!/usr/bin/env bash
set -euo pipefail

# PR check (no mise). Orchestrates the full validation suite, stopping on the
# first failure with per-step timing. Each step is a melos script; this script
# just sequences them and maps flags/env to behaviour.
#
# Usage: bash scripts/pr_check.sh [--tests-only] [--verbose]
#   --tests-only   Run only the Tests step (skip format/analyze/cycles/generated)
#   --verbose      Print each step's output even when it succeeds
# Env equivalents: PRCHECK_TESTS_ONLY=1, PRCHECK_VERBOSE=1
#
# Also runnable via `melos run pr-check` (which just calls this script).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

VERBOSE=${PRCHECK_VERBOSE:-0}
TESTS_ONLY=${PRCHECK_TESTS_ONLY:-0}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tests-only)      TESTS_ONLY=1; shift ;;
    --verbose|--trace) VERBOSE=1; shift ;;
    -h|--help)
      echo "usage: bash scripts/pr_check.sh [--tests-only] [--verbose]"
      exit 0 ;;
    *) echo "Error: unknown option: $1" >&2; exit 1 ;;
  esac
done

# Avoid Dart's "pubspec newer than lock" staleness check triggering an auto pub get.
touch pubspec.lock

# run_step <num> <label> <cmd...> — run a step, print ✓/✗ with duration, and on
# failure (or when VERBOSE=1) echo its captured output. Exits 1 on failure.
run_step() {
  local n=$1 label=$2; shift 2
  echo "[$n/5] $label..."
  local start out ret el
  start=$(date +%s)
  # `if` guards the capture so `set -e` doesn't abort before we record the status.
  if out=$("$@" 2>&1); then ret=0; else ret=$?; fi
  el=$(( $(date +%s) - start ))
  if [ "$VERBOSE" -eq 1 ] || [ "$ret" -ne 0 ]; then
    echo "$out"
  fi
  if [ "$ret" -eq 0 ]; then
    echo "[$n/5] $label... ✓ (${el}s)"
  else
    echo "[$n/5] $label... ✗ (${el}s)"
    exit 1
  fi
}

if [ "$TESTS_ONLY" -eq 0 ]; then
  run_step 1 "Format"               bash scripts/format_check.sh
  run_step 2 "Analyze"              dart run melos run analyze
  run_step 3 "Cycling dependencies" dart run melos list --cycles
  run_step 4 "Generated up-to-date" bash scripts/check_generated.sh
fi
run_step 5 "Tests"                  dart run melos run test
