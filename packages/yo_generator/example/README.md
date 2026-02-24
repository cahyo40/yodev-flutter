# Example Usage

This folder demonstrates how to use `yo_generator` in a real Flutter project.

## Quick Start

1. Create a new Flutter project:

   ```bash
   flutter create my_app
   cd my_app
   ```

2. Copy `yo.dart` and `src/` folder to your project root

3. Initialize with your preferred state management:

   ```bash
   # With Riverpod (recommended)
   dart run yo.dart init --state=riverpod
   
   # With GetX
   dart run yo.dart init --state=getx
   
   # With Bloc
   dart run yo.dart init --state=bloc
   ```

4. Run Flutter pub get:

   ```bash
   flutter pub get
   ```

5. Generate l10n files:

   ```bash
   flutter gen-l10n
   ```

6. Start generating features:

   ```bash
   dart run yo.dart page:product
   dart run yo.dart page:product.detail --presentation-only
   dart run yo.dart model:category --freezed --feature=product
   ```

## Generated Structure

After running `init`, your project will have:

```
lib/
├── core/
│   ├── config/        # Router configuration
│   ├── constants/     # App constants
│   ├── extensions/    # Dart extensions
│   ├── services/      # Global services
│   ├── themes/        # App theme (light/dark)
│   ├── utils/         # Utility functions
│   └── widgets/       # Global widgets
├── features/
│   └── home/          # Default home feature
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           ├── providers/  # or controllers/bloc
│           └── widgets/
├── l10n/
│   ├── app_en.arb
│   └── app_id.arb
└── main.dart
```

## Commands Reference

| Command | Description |
|---------|-------------|
| `page:<name>` | Generate full feature with clean architecture |
| `model:<name>` | Generate data model |
| `controller:<name>` | Generate state management controller |
| `datasource:<name>` | Generate datasource (remote/local) |
| `usecase:<name>` | Generate domain usecase |
| `repository:<name>` | Generate repository interface + implementation |
| `screen:<name>` | Generate screen widget |
| `dialog:<name>` | Generate dialog widget |
| `widget:<name>` | Generate custom widget |
| `service:<name>` | Generate global service |
| `test:<name>` | Generate test files (unit, widget, provider) |
| `network` | Generate Dio network layer |
| `di` | Generate dependency injection setup |
| `delete:<name>` | Delete page and related files |

### Common Flags

| Flag | Description |
|------|-------------|
| `--force` | Overwrite existing files |
| `--feature=<name>` | Specify target feature |
| `--presentation-only` | Generate UI layer only (page command) |

See [README.md](../README.md) for full documentation.
