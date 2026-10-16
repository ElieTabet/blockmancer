#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# create_package.sh — scaffold a new package in the monorepo
#
# Feature packages are decomposed by layer: each of data / domain / presentation
# is its own Dart package under packages/features/<name>/<layer>, named
# <name>_<layer>. shared_domain / core are single flat packages under
# packages/<name>; design_system packages live under packages/dsm/<name>.
#
# Layout (all packages): the public barrel is lib/<pkg>.dart; everything else —
# implementation, package_name.dart, and the provider files — lives under lib/src/.
# Feature layers also get the provider files (providers.dart / providers_di.br /
# providers_internal.br), mirroring the flutter-front convention.
#
# Usage: bash scripts/create_package.sh --name <name> --type <feature|core|shared_domain|design_system>
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# --- Argument parsing -------------------------------------------------------
NAME=""
TYPE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    *) echo "Error: unknown argument: $1" >&2; exit 1 ;;
  esac
done

# --- Validation -------------------------------------------------------------
if [[ -z "$NAME" ]]; then
  echo "Error: --name is required" >&2
  echo "Usage: melos run create -- --name <name> --type <feature|core|shared_domain|design_system>" >&2
  exit 1
fi

if [[ ! "$NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Error: --name must be a valid Dart package name (lowercase letters, digits, underscores; must start with a letter)" >&2
  echo "Usage: melos run create -- --name <name> --type <feature|core|shared_domain|design_system>" >&2
  exit 1
fi

if [[ -z "$TYPE" ]]; then
  echo "Error: --type is required" >&2
  echo "Usage: melos run create -- --name <name> --type <feature|core|shared_domain|design_system>" >&2
  exit 1
fi

VALID_TYPES=("feature" "core" "shared_domain" "design_system")
VALID=false
for t in "${VALID_TYPES[@]}"; do
  [[ "$TYPE" == "$t" ]] && VALID=true && break
done
if [[ "$VALID" == false ]]; then
  echo "Error: --type must be one of: feature, core, shared_domain, design_system" >&2
  exit 1
fi

# --- Helpers ----------------------------------------------------------------
mkdirs() {
  local dir
  for dir in "$@"; do
    mkdir -p "$dir"
    touch "$dir/.gitkeep"
  done
}

# write_identity <lib_dir> <pkg_name> <barrel_comment>
# Emits the public barrel lib/<pkg_name>.dart and lib/src/package_name.dart.
write_identity() {
  local lib_dir="$1" pkg_name="$2" comment="$3"
  mkdir -p "$lib_dir/src"
  cat > "$lib_dir/$pkg_name.dart" <<BARREL
// $pkg_name — $comment
BARREL
  cat > "$lib_dir/src/package_name.dart" <<PKGN
const packageName = '$pkg_name';
PKGN
}

# write_providers <lib_dir> <pkg_name>
# Emits the provider files under lib/src/ and exports providers.dart from the barrel.
# providers.dart is pure glue (no codegen → no .br); providers_di/_internal host
# @riverpod providers (→ .br). Stubs are comment-only so codegen stays green.
write_providers() {
  local lib_dir="$1" pkg_name="$2"
  mkdir -p "$lib_dir/src"
  cat > "$lib_dir/src/providers.dart" <<EOF
// $pkg_name — public API of this layer's providers (mirrors flutter-front providers.dart).
//
// Pure glue: no @riverpod here (so no generated companion, no .br suffix).
// Expose a bindRoutingProviders(...) / bindProviders(...) helper returning
// List<Override> that binds the providers_di.br slots to concrete sources, e.g.:
//
//   import 'package:riverpod_annotation/riverpod_annotation.dart';
//   List<Override> bindRoutingProviders({required SomeRouting Function(Ref) routing}) =>
//       [someRoutingProvider.overrideWith(routing)];
EOF
  cat > "$lib_dir/src/providers_di.br.dart" <<EOF
// $pkg_name — inbound dependency-injection slots (mirrors flutter-front providers_di.br).
//
// Declare @riverpod providers here that expose this layer's external dependencies
// (throwing or returning defaults), to be overridden by the composition root or a
// wiring layer. Add the part directive once the first provider exists:
//
//   import 'package:riverpod_annotation/riverpod_annotation.dart';
//   part 'providers_di.br.g.dart';
//
//   @riverpod
//   SomeDependency someDependency(Ref ref) =>
//       throw UnimplementedError('override in composition root');
EOF
  cat > "$lib_dir/src/providers_internal.br.dart" <<EOF
// $pkg_name — internal providers, not exported from the package barrel
// (mirrors flutter-front providers_internal.br).
//
// Declare @riverpod providers used only inside this layer here. Add the part
// directive once the first provider exists:
//
//   import 'package:riverpod_annotation/riverpod_annotation.dart';
//   part 'providers_internal.br.g.dart';
EOF
  grep -q "export 'src/providers.dart';" "$lib_dir/$pkg_name.dart" \
    || printf "export 'src/providers.dart';\n" >> "$lib_dir/$pkg_name.dart"
}

guard_new_dir() {
  local dir="$1" label="$2"
  if [[ -d "$dir" ]]; then
    echo "Error: $label already exists" >&2
    exit 1
  fi
}

# --- Feature layer scaffolds ------------------------------------------------
scaffold_feature_domain() {
  local base="$1" pkg="${NAME}_domain" dir="$1/domain"
  mkdirs "$dir/lib/src/entities" "$dir/lib/src/repositories" "$dir/lib/src/use_cases" "$dir/test"
  write_identity "$dir/lib" "$pkg" "add exports here as you implement the domain layer"
  write_providers "$dir/lib" "$pkg"
  cat > "$dir/pubspec.yaml" <<PUBSPEC
name: $pkg
description: "${NAME} domain layer — entities, repository contracts, use cases."
publish_to: none
resolution: workspace

environment:
  sdk: ^3.11.0
  flutter: ^3.44.0

dependencies:
  flutter:
    sdk: flutter
  shared_domain: any
  riverpod_annotation: ^4.0.2
  freezed_annotation: ^3.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.15.3
  riverpod_generator: ^4.0.3
  freezed: ^3.2.5
  mocktail: ^1.0.4
PUBSPEC
}

scaffold_feature_data() {
  local base="$1" pkg="${NAME}_data" dir="$1/data"
  mkdirs "$dir/lib/src/datasources" "$dir/lib/src/mappers" "$dir/lib/src/models" "$dir/lib/src/repositories" "$dir/test"
  write_identity "$dir/lib" "$pkg" "add exports here as you implement the data layer"
  write_providers "$dir/lib" "$pkg"
  cat > "$dir/pubspec.yaml" <<PUBSPEC
name: $pkg
description: "${NAME} data layer — data sources, DTOs, mappers, repository implementations."
publish_to: none
resolution: workspace

environment:
  sdk: ^3.11.0
  flutter: ^3.44.0

dependencies:
  flutter:
    sdk: flutter
  ${NAME}_domain: any
  shared_domain: any
  riverpod_annotation: ^4.0.2
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.15.3
  riverpod_generator: ^4.0.3
  freezed: ^3.2.5
  json_serializable: ^6.9.4
  mocktail: ^1.0.4
PUBSPEC
}

scaffold_feature_presentation() {
  local base="$1" pkg="${NAME}_presentation" dir="$1/presentation"
  mkdirs "$dir/lib/src/routing" "$dir/lib/src/notifiers" "$dir/lib/src/widgets" "$dir/test"
  write_identity "$dir/lib" "$pkg" "add exports here (e.g. the feature router) as you implement widgets"
  write_providers "$dir/lib" "$pkg"
  cat > "$dir/pubspec.yaml" <<PUBSPEC
name: $pkg
description: "${NAME} presentation layer — widgets, view models, routing."
publish_to: none
resolution: workspace

environment:
  sdk: ^3.11.0
  flutter: ^3.44.0

dependencies:
  flutter:
    sdk: flutter
  ${NAME}_domain: any
  design_system: any
  l10n_application: any
  flutter_riverpod: ^3.3.1
  riverpod_annotation: ^4.0.2
  auto_route: ^11.1.0
  freezed_annotation: ^3.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.15.3
  riverpod_generator: ^4.0.3
  freezed: ^3.2.5
  auto_route_generator: ^10.4.0
  mocktail: ^1.0.4
PUBSPEC
}

scaffold_feature() {
  local base="$ROOT_DIR/packages/features/$NAME"
  guard_new_dir "$base" "packages/features/$NAME"
  echo "Scaffolding feature packages/features/$NAME (domain, data, presentation)..."
  scaffold_feature_domain "$base"
  scaffold_feature_data "$base"
  scaffold_feature_presentation "$base"
}

# --- Non-feature (single flat package) scaffolds ----------------------------
scaffold_core() {
  local dir="$ROOT_DIR/packages/$NAME"
  guard_new_dir "$dir" "packages/$NAME"
  mkdirs "$dir/lib/src/error" "$dir/lib/src/network" "$dir/test"
  write_identity "$dir/lib" "$NAME" "shared infrastructure — add exports here"
  cat > "$dir/pubspec.yaml" <<PUBSPEC
name: $NAME
description: "$NAME shared infrastructure package."
publish_to: none
resolution: workspace

environment:
  sdk: ^3.11.0
  flutter: ^3.44.0

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.1
  dio: ^5.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
PUBSPEC
}

scaffold_shared_domain() {
  local dir="$ROOT_DIR/packages/$NAME"
  guard_new_dir "$dir" "packages/$NAME"
  mkdirs "$dir/lib/src/entities" "$dir/lib/src/repositories" "$dir/lib/src/use_cases" "$dir/test"
  write_identity "$dir/lib" "$NAME" "shared domain entities and use cases"
  cat > "$dir/pubspec.yaml" <<PUBSPEC
name: $NAME
description: "$NAME shared domain entities and use cases."
publish_to: none
resolution: workspace

environment:
  sdk: ^3.11.0
  flutter: ^3.44.0

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
PUBSPEC
}

scaffold_design_system() {
  local dir="$ROOT_DIR/packages/dsm/$NAME"
  guard_new_dir "$dir" "packages/dsm/$NAME"
  mkdirs "$dir/lib/src/components" "$dir/lib/src/theme" "$dir/lib/src/tokens" "$dir/test"
  write_identity "$dir/lib" "$NAME" "design system — components, theme, and tokens"
  cat > "$dir/pubspec.yaml" <<PUBSPEC
name: $NAME
description: "$NAME design system — components, theme, and tokens."
publish_to: none
resolution: workspace

environment:
  sdk: ^3.11.0
  flutter: ^3.44.0

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
PUBSPEC
}

# --- Dispatch ---------------------------------------------------------------
case "$TYPE" in
  feature)       scaffold_feature ;;
  core)          scaffold_core ;;
  shared_domain) scaffold_shared_domain ;;
  design_system) scaffold_design_system ;;
  *)             echo "Error: internal — type '$TYPE' has no scaffold function" >&2; exit 1 ;;
esac

echo ""
case "$TYPE" in
  feature)       echo "Done: packages/features/$NAME (${NAME}_domain, ${NAME}_data, ${NAME}_presentation) created." ;;
  design_system) echo "Done: packages/dsm/$NAME ($TYPE) created." ;;
  *)             echo "Done: packages/$NAME ($TYPE) created." ;;
esac
echo "Auto-discovered via the workspace globs in pubspec.yaml — no manual registration needed."
echo "Run 'melos run prepare' to bootstrap the new package(s)."
