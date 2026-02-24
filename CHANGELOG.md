# Changelog

All notable changes to **YoDev Monorepo** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-24

### Added

#### Monorepo Consolidation
- Restructured as Dart Workspace monorepo with `packages/yo_ui` and `packages/yo_generator`
- Added `melos.yaml` for multi-package management
- Root `pubspec.yaml` as workspace configuration

#### YoUI Integration into Generator
- All generator templates now automatically use YoUI components
- Template mapping:
  - `Scaffold` → `YoScaffold`
  - `Text` → `YoText` / `YoText.heading()`
  - `ElevatedButton` → `YoButton.primary()`
  - `CircularProgressIndicator` → `YoLoading()`
  - Error handling → `YoErrorState(message:, onRetry:)`
  - `AlertDialog` → `YoConfirmDialog(title:, content:)`
  - `ThemeData` → `YoTheme.light()` / `YoTheme.dark()`
- `yo_ui` added as default dependency in generated projects

#### AI Agent Integration
- `.agent/workflows/yo-init.md` — Project initialization workflow
- `.agent/workflows/yo-feature.md` — Full feature generation workflow
- `.agent/workflows/yo-page.md` — Single page generation workflow
- `.agent/rules/yo-architecture.md` — Clean Architecture enforcement rules

### Fixed
- `bloc_test` dependency leak — moved from common to bloc-specific dev_dependencies

---

## [1.0.0] - 2026-01-03

### Added
- Initial release with `yo_ui` v0.0.4 and `yo_generator` v1.0.0
- See individual package CHANGELOGs for details:
  - [yo_ui CHANGELOG](packages/yo_ui/CHANGELOG.md)
  - [yo_generator CHANGELOG](packages/yo_generator/CHANGELOG.md)
