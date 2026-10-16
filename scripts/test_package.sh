#!/usr/bin/env bash
set -euo pipefail

# Run the current package's tests only when it actually contains test files.
# Invoked per-package by the melos `test` script (CWD = package root). Packages
# with no *_test.dart files (e.g. freshly scaffolded layer packages) are skipped
# instead of failing with "Test directory does not appear to contain any test files".
#
# A package that doesn't depend on the Flutter SDK (blockmancer_engine) runs on
# the plain Dart VM with `dart test`: flutter_test can't load it, and the VM is
# where its determinism is meant to hold.

if ! find test -name '*_test.dart' -print -quit 2>/dev/null | grep -q .; then
  echo "no tests — skipping ${MELOS_PACKAGE_NAME:-$(basename "$PWD")}"
  exit 0
fi

if grep -Eq '^[[:space:]]+sdk:[[:space:]]+flutter' pubspec.yaml; then
  exec flutter test
else
  exec dart test
fi
