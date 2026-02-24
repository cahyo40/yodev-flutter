# YO.DART - AI Vibe Coding Skill for Flutter

> **🤖 AI Skill untuk Flutter Development dengan Clean Architecture**  
> Gunakan dokumentasi ini saat melakukan **Vibe Coding** - pair programming dengan AI untuk membangun aplikasi Flutter.

---

## Quick Reference

### Kapan Gunakan yo.dart?

✅ User minta buat aplikasi Flutter baru  
✅ User minta tambah fitur/halaman  
✅ Proyek memiliki file `yo.yaml`  
✅ Diskusi tentang Riverpod, GetX, atau Bloc  
✅ Butuh Clean Architecture di Flutter  

### Command Cheatsheet

```bash
# INTERACTIVE MODE (WIZARD)
dart run yo.dart --interactive        # ✨ Start Here!

# GLOBAL FLAGS
--dry-run                             # 🔍 Preview changes
--force                               # 💪 Overwrite existing
--interactive                         # 🧙 Wizard mode

# INIT
dart run yo.dart init --state=riverpod

# FEATURES
dart run yo.dart page:home --dry-run
dart run yo.dart page:auth.login

# ORGANIZE
dart run yo.dart barrel               # 🧱 Create export files
dart run yo.dart barrel feature:home  # 🧱 Only home feature


# COMPONENTS
dart run yo.dart model:user --feature=auth
dart run yo.dart entity:product --feature=shop
dart run yo.dart controller:cart --cubit
dart run yo.dart datasource:payment --both

# INFRASTRUCTURE
dart run yo.dart network                    # Dio + interceptors
dart run yo.dart di                         # DI setup

# UI
dart run yo.dart widget:button --global
dart run yo.dart dialog:confirm --feature=order

# TESTING
dart run yo.dart test:home                  # All tests
dart run yo.dart test:auth --unit           # Unit tests only
dart run yo.dart test:cart --widget         # Widget tests only

# UTILITIES
dart run yo.dart delete:old_feature --delete-feature
```

---

## 1. AI Workflow

### Step 1: Cek Konfigurasi

```bash
cat yo.yaml
```

```yaml
state_management: riverpod
package_name: com.example.app
features:
  - home
  - auth
```

### Step 2: Generate Structure

```bash
dart run yo.dart page:<feature_name>
```

### Step 3: Implementasi Logic

Buka file yang di-generate, cari marker `// TODO`:

| Layer | File | Implementasi |
| :--- | :--- | :--- |
| Domain | `*_usecase.dart` | Business logic |
| Data | `*_repository_impl.dart` | API calls |
| Data | `*_remote_datasource.dart` | HTTP requests |
| Presentation | `*_provider.dart` / `*_controller.dart` / `*_bloc.dart` | UI state |

### Step 4: Post-Generation

```bash
flutter pub get
flutter gen-l10n                              # If translations updated
dart run build_runner build                   # If using freezed/bloc
```

---

## 2. Naming Convention

| Input | Class | File | Feature |
| :--- | :--- | :--- | :--- |
| `home` | `Home` | `home.dart` | `features/home/` |
| `setting.profile` | `SettingProfile` | `setting_profile.dart` | `features/setting/` |
| `user.auth.login` | `UserAuthLogin` | `user_auth_login.dart` | `features/user/` |

**Rule:** Bagian pertama dot notation = folder feature

---

## 3. Architecture Structure

```text
lib/
├── core/
│   ├── config/          # Router
│   ├── di/              # Dependency Injection
│   ├── network/         # Dio client + interceptors
│   │   ├── api_client.dart
│   │   ├── dio_client.dart
│   │   ├── network_info.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── logging_interceptor.dart
│   │       └── error_interceptor.dart
│   ├── themes/          # Material 3
│   └── widgets/         # Global widgets
│
├── features/<name>/
│   ├── data/
│   │   ├── datasources/     # API calls
│   │   ├── models/          # JSON models
│   │   └── repositories/    # Implementation
│   ├── domain/
│   │   ├── entities/        # Pure objects
│   │   ├── repositories/    # Interfaces
│   │   └── usecases/        # Business logic
│   └── presentation/
│       ├── pages/           # UI screens
│       ├── providers/       # Riverpod
│       ├── controllers/     # GetX
│       └── bloc/            # Bloc
│
└── l10n/                    # Translations
```

---

## 4. State Management Patterns

### Riverpod (Recommended)

```dart
// Provider
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

// Notifier
class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();
  
  Future<void> fetchData() async {
    state = state.copyWith(isLoading: true);
    // ... implementation
  }
}

// Page
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    return Scaffold(...);
  }
}
```

### GetX

```dart
// Controller
class HomeController extends GetxController {
  final isLoading = false.obs;
  final data = Rxn<dynamic>();
  
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}

// Page
class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading.value 
        ? LoadingWidget() 
        : ContentWidget()
      ),
    );
  }
}
```

### Bloc

```dart
// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeFetched>(_onFetched);
  }
  
  Future<void> _onFetched(HomeFetched event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    // ... implementation
    emit(HomeLoaded(data: result));
  }
}

// Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeFetched()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => Scaffold(...),
      ),
    );
  }
}
```

---

## 5. Network Layer

Generate dengan:

```bash
dart run yo.dart network
```

Menghasilkan:

- `api_client.dart` - HTTP wrapper
- `dio_client.dart` - Dio configuration
- `network_info.dart` - Connectivity check
- `interceptors/` - Auth, Logging, Error handling

---

## 6. Dependency Injection

Generate dengan:

```bash
dart run yo.dart di
```

Auto-detect state management:

- **Riverpod** → `providers.dart`
- **GetX** → `injection_container.dart` (Get.lazyPut)
- **Bloc** → `injection_container.dart` (get_it)

---

## 7. Vibe Coding Scenarios

### Scenario 1: "Buat fitur authentication"

```bash
dart run yo.dart page:auth.login
dart run yo.dart page:auth.register
dart run yo.dart model:user --feature=auth
dart run yo.dart datasource:auth --both --feature=auth
```

### Scenario 2: "Tambahkan shopping cart"

```bash
dart run yo.dart page:cart
dart run yo.dart page:cart.checkout
dart run yo.dart model:cart.item --feature=cart
dart run yo.dart model:product --feature=cart
```

### Scenario 3: "Generate network layer for API"

```bash
dart run yo.dart network
dart run yo.dart di
# AI implements API endpoints in generated files
```

### Scenario 4: "Generate tests for feature"

```bash
dart run yo.dart test:auth                  # Generate all test types
dart run yo.dart test:auth --unit           # Only usecase + repository tests
dart run yo.dart test:auth --widget         # Only page widget tests
dart run yo.dart test:auth --provider       # Only provider/controller tests
dart run yo.dart test:auth --force          # Overwrite existing tests

# After generating tests:
dart run build_runner build                 # Generate mocks
flutter test                                # Run tests
```

### Scenario 5: "Delete old feature"

```bash
dart run yo.dart delete:old_feature --delete-feature
```

---

## 8. Dependencies Added by Init

### Common (All)

- equatable, dartz, uuid, intl
- connectivity_plus, shared_preferences
- flutter_svg, cached_network_image
- go_router

### Riverpod (Dependencies)

- flutter_riverpod, riverpod_annotation
- hooks_riverpod, flutter_hooks

### GetX (Dependencies)

- get, get_storage

### Bloc (Dependencies)

- flutter_bloc, bloc, get_it
- bloc_concurrency, hydrated_bloc

---

## 9. Tips untuk AI

1. **Selalu cek `yo.yaml` dulu** - untuk tahu state management aktif
2. **Generate dulu, implement kemudian** - jangan tulis kode dari nol
3. **Generate tests untuk feature** - `dart run yo.dart test:<feature>`
4. **Gunakan `--force`** untuk overwrite file yang sudah ada
5. **Jalankan post-generation tasks** - pub get, build_runner, gen-l10n
6. **Cari `// TODO`** di file generated sebagai panduan
7. **Konsisten dengan naming** - gunakan dot notation untuk sub-features

---

## 10. Troubleshooting

| Error | Solution |
| :--- | :--- |
| "Feature does not exist" | Generate page dulu: `page:<feature>` |
| "Page already exists" | Gunakan `--force` untuk overwrite |
| "Unknown command" | Cek typo di command name |
| Lint errors | Run `dart analyze` dan fix manually |

---

## 11. Advanced Features

### 🧙 Interactive Mode (Wizard)

Jika Anda lupa command, gunakan mode interaktif:

```bash
dart run yo.dart --interactive
# atau
dart run yo.dart -i
```

Anda akan dipandu untuk:

1. Inisialisasi proyek
2. Membuat fitur/halaman
3. Memilih command lain

### 🔍 Dry-run Mode

Sebelum menjalankan command yang merubah banyak file, gunakan `--dry-run` untuk melihat apa yang akan terjadi:

```bash
dart run yo.dart page:profile --dry-run
```

Output:

```text
[DRY-RUN] Will create: lib/features/profile/presentation/pages/profile_page.dart
[DRY-RUN] Will create: lib/features/profile/data/models/profile_model.dart
...
Summary: 12 files would be created.
```

### 🧱 Barrel File Generator

Untuk merapikan imports, generate barrel files (`export '...';`) secara otomatis:

```bash
# Generate untuk semua features dan core
dart run yo.dart barrel

# Generate untuk feature spesifik
dart run yo.dart barrel feature:home
```

### 🧩 Plugin System

`yo.dart` mendukung custom generator melalui plugins. Buat folder `yo_plugins/` di root proyek Anda dan tambahkan script dart yang extend `GeneratorPlugin`.

---

**Built for AI Vibe Coding** 🤖✨
