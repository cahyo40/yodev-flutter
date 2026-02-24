# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-03

### Added

#### Core Features
- Initial release of yo.dart Flutter Code Generator CLI
- Support for 3 state management solutions: **Riverpod**, **GetX**, and **Bloc**
- Clean Architecture folder structure generation
- Configuration file (`yo.yaml`) for project settings

#### Generators
- **`init`** - Initialize project with selected state management
  - Adds required dependencies to `pubspec.yaml`
  - Creates core folder structure
  - Generates Material 3 theme (light/dark mode)
  - Creates L10n translation files (English & Indonesian)
  - Generates default home page
  - Creates `main.dart` with proper setup
  - Generates VSCode `tasks.json` for quick access

- **`page`** - Generate full page with clean architecture
  - Presentation layer (pages, controllers/providers/blocs)
  - Data layer (models, datasources, repositories)
  - Domain layer (entities, repository interfaces, usecases)
  - Auto-updates router configuration
  - `--presentation-only` flag for UI-only generation

- **`controller`** - Generate state management files
  - Riverpod: StateNotifier + Provider
  - GetX: Controller + Binding
  - Bloc: Bloc + Events + States (or Cubit with `--cubit` flag)

- **`model`** - Generate data models
  - Standard model with Equatable
  - Freezed support with `--freezed` flag
  - Auto-generates corresponding entity

- **`datasource`** - Generate datasources
  - Remote datasource (`--remote`)
  - Local datasource (`--local`)
  - Both (`--both`)

- **`usecase`** - Generate domain usecases
- **`repository`** - Generate repository interface and implementation
- **`screen`** - Generate screen widgets
- **`dialog`** - Generate dialog widgets
- **`widget`** - Generate custom widgets (feature-specific or global)
- **`service`** - Generate global services
- **`translation`** - Update L10n ARB files
- **`package-name`** - Update Android/iOS package name
- **`app-name`** - Update app display name across platforms

#### Naming Convention
- Dot notation support: `setting.profile` → `SettingProfile` class, `setting_profile.dart` file
- Automatic feature extraction from name

#### Templates
- Riverpod templates with StateNotifier pattern
- GetX templates with Controller and Binding
- Bloc templates with Events and States
- Common templates for models, datasources, repositories, usecases

#### Developer Experience
- Colored console output with emojis
- VSCode tasks.json integration
- Comprehensive help command (`--help`)
- Version command (`--version`)

### Dependencies
- `args: ^2.4.2` - Command line argument parsing
- `yaml: ^3.1.2` - YAML file handling
- `path: ^1.8.3` - Path manipulation
- `recase: ^4.1.0` - String case conversion

---

## [1.1.0] - 2026-02-24

### Added

#### YoUI Integration
- All generated templates now automatically use YoUI components
- Page templates: `YoScaffold` + `YoText.heading()` + `YoLoading()` + `YoErrorState()`
- Dialog templates: `YoConfirmDialog`
- Widget templates: `YoCard` + `YoText`
- Theme templates: `YoTheme.light()` / `YoTheme.dark()` with `YoColorScheme` and `YoFonts`
- `yo_ui` added as default dependency in generated projects

#### Monorepo
- Restructured as part of YoDev monorepo (`packages/yo_generator/`)
- Path dependency to `yo_ui` for development

### Fixed
- `bloc_test` dependency leak — moved from common `dev_dependencies` to bloc-specific section
- Dependency isolation verified: Riverpod, GetX, and Bloc dependencies no longer cross-contaminate

### Completed (from Planned)
- [x] Test file generation (`dart run yo.dart test:<name>`)
- [x] Interactive mode (`dart run yo.dart --interactive`)

---

## [Unreleased]

### Planned
- [ ] Support for more languages in translations
- [ ] Custom template support
- [ ] Watch mode for continuous generation
- [ ] Documentation generation
- [ ] Migration helpers between state managements
