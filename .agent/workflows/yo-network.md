---
description: Setup networking layer (Dio + interceptors) dengan yo.dart
---

# Setup Network Layer

// turbo-all

## Steps

1. Generate network infrastructure:
```bash
dart run yo.dart network
```

2. Generate dependency injection setup:
```bash
dart run yo.dart di
```

3. Install dependencies jika belum:
```bash
flutter pub get
```

4. Review file yang dihasilkan:
```bash
# Network files
ls lib/core/network/

# DI files
ls lib/core/di/
```

5. Konfigurasi base URL di environment config:
```bash
grep -rn "baseUrl\|BASE_URL" lib/core/
```

6. Implement interceptors sesuai kebutuhan project:
   - **Auth interceptor**: Token refresh logic
   - **Retry interceptor**: Retry pada 5xx errors
   - **Logging interceptor**: Request/response logging (dev only)

7. Verifikasi:
```bash
flutter analyze
```

## Output

```
lib/core/
├── network/
│   ├── api_client.dart         # Dio instance + config
│   ├── api_interceptor.dart    # Auth + Retry + Logging
│   └── api_exception.dart      # Custom exception classes
└── di/
    └── injection.dart          # Service locator / provider setup
```

## Best Practices
- Set timeout ke 15 detik (bukan default 30)
- Auth interceptor: auto-refresh token saat 401
- Retry interceptor: max 3x untuk error 5xx
- Logging interceptor: hanya aktif di debug mode
- Centralized error mapper: `DioException` → `AppException`
