#!/usr/bin/env bash
set -euo pipefail

# Run `flutter test` only when the current package actually contains test files.
# Invoked per-package by the melos `test` script (CWD = package root). Packages
# with no *_test.dart files (e.g. freshly scaffolded layer packages) are skipped
# instead of failing with "Test directory does not appear to contain any test files".

if find test -name '*_test.dart' -print -quit 2>/dev/null | grep -q .; then
  exec flutter test
else
  echo "no tests — skipping ${MELOS_PACKAGE_NAME:-$(basename "$PWD")}"
fi
