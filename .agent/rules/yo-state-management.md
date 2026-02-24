# State Management Rules

## Prinsip

- **Satu state management per project** — cek `yo.yaml` sebelum koding
- **JANGAN pernah mix** Riverpod, GetX, dan Bloc dalam satu project
- **Konsisten** — setiap fitur menggunakan pattern yang sama

## Riverpod

```dart
// ✅ Benar
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    // ...
  }
}

// ❌ Salah — jangan pakai GetxController di project Riverpod
class AuthController extends GetxController { ... }
```

## GetX

```dart
// ✅ Benar
class AuthController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
}

class AuthPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ...);
  }
}

// ❌ Salah — jangan pakai ref.watch di project GetX
ref.watch(someProvider)
```

## BLoC

```dart
// ✅ Benar
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
  }
}

// BlocBuilder di page
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return const YoLoading();
    // ...
  },
)

// ❌ Salah — jangan pakai StateNotifierProvider di project Bloc
final provider = StateNotifierProvider<...>((ref) => ...);
```

## Checklist

- [ ] Cek `yo.yaml` → `state_management:` sebelum mulai
- [ ] Semua controller/provider/bloc mengikuti pattern dari state management yang dipilih
- [ ] Binding/injection sesuai: `ProviderScope` (Riverpod), `Get.lazyPut` (GetX), `BlocProvider` (Bloc)
- [ ] Test menggunakan tool yang sesuai: `ProviderContainer` / `Get.testMode` / `blocTest`
