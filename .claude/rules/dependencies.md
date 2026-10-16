# Dependencies

The **root `pubspec.yaml`** is the single source of dependency versions. Versions live under
Melos's `command.bootstrap` (`environment` / `dependencies` / `dev_dependencies`), and
`dart run melos bootstrap` syncs each version down into the packages: **external/hosted** deps
end up carrying the root's version constraint (a caret `^x.y.z`, or an exact pin where the root
pins one), while **internal/workspace** deps stay version-less (`any`). So a committed package
`pubspec.yaml` normally shows external deps *with* a version and internal deps as `any` — both
are correct, and both are owned by bootstrap, not hand-edited.

## Rules

- **The root is the single source of the version.** New dependency → add it under
  `melos.command.bootstrap.dependencies` (or `dev_dependencies`) in the **root** `pubspec.yaml`
  with a version (caret `^x.y.z` unless a pin is required), and declare it in the consuming
  package (version-less `any` is fine). Then `dart run melos bootstrap`, which stamps the root's
  version into the package's external deps.
- **Don't hand-manage a package-level version.** Don't add, remove, or "fix" the version on a
  package dependency by hand — `melos bootstrap` owns it (it re-applies the root's version to
  external deps and leaves internal/workspace deps version-less). Editing a package version
  directly is reverted on the next bootstrap.
- **Version conflicts that can't be expressed as constraints go in `dependency_overrides`** (root
  only). Today that's the `analyzer` / `dart_style` / `riverpod_analyzer_utils` pins that let the
  `custom_lints` analyzer-plugin coexist with the codegen stack. Keep overrides minimal — they
  bypass constraint checking entirely.
- **No new dependency without justification.** Prefer the existing dependency set; if a new dep is
  genuinely required, **call it out explicitly in the PR description**.
- **Declare what you use; use what you declare.** Every imported package must be in that package's
  `pubspec.yaml`, and removing the last import of a package means removing the dep.
- **Never hand-edit lockfiles.** Let `melos bootstrap` resolve `pubspec.lock`.
