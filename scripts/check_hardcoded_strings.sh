#!/usr/bin/env bash
set -euo pipefail

# Fail (exit 1, listing file:line) on a hard-coded user-facing string: a quoted
# literal containing a letter passed to Text(…) / SelectableText(…), or to a
# `text:`, `title:`, `label:`, `labelText:`, `hintText:`, `tooltip:`, `message:`,
# `semanticLabel:` or `semanticsLabel:` argument (TextSpan(text: '…') included).
# Interpolations and escapes don't count as letters, so '$count' or ' · ' pass.
#
# Scans packages/**/presentation/lib, packages/composition/*/lib and app/lib,
# skipping generated files (*.g.dart, *.gr.dart, *.freezed.dart, *.gen.dart, …)
# and test/. Genuine non-copy (a log tag, a key) is allowed with a
# `// l10n-ignore: <reason>` comment on the literal's line.
#
# Syntactic, not semantic: a literal behind a ternary or a variable is missed.
# The logic lives in check_hardcoded_strings.dart — regex over whole files, so a
# literal the formatter moved to the line after `Text(` is still found.
#
# Usage: bash scripts/check_hardcoded_strings.sh [file-or-dir ...]
#   With no argument, scans the default set above. Run from anywhere.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

exec dart run scripts/check_hardcoded_strings.dart "$@"
