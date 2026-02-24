# Naming Convention Rules

## File Naming

| Tipe | Format | Contoh |
|------|--------|--------|
| Page | `<name>_page.dart` | `login_page.dart` |
| Screen | `<name>_screen.dart` | `profile_screen.dart` |
| Widget | `<name>_widget.dart` | `avatar_widget.dart` |
| Model | `<name>_model.dart` | `user_model.dart` |
| Entity | `<name>_entity.dart` | `user_entity.dart` |
| Controller | `<name>_controller.dart` | `auth_controller.dart` |
| Provider | `<name>_provider.dart` | `auth_provider.dart` |
| BLoC | `<name>_bloc.dart` | `auth_bloc.dart` |
| Repository | `<name>_repository.dart` | `auth_repository.dart` |
| Repository Impl | `<name>_repository_impl.dart` | `auth_repository_impl.dart` |
| Datasource | `<name>_datasource.dart` | `auth_remote_datasource.dart` |
| Usecase | `<name>_usecase.dart` | `login_usecase.dart` |
| Service | `<name>_service.dart` | `notification_service.dart` |
| Test | `<name>_test.dart` | `login_usecase_test.dart` |

## Class Naming

| Tipe | Format | Contoh |
|------|--------|--------|
| Page | `<Name>Page` | `LoginPage` |
| Controller | `<Name>Controller` | `AuthController` |
| BLoC | `<Name>Bloc` | `AuthBloc` |
| Provider | `<name>Provider` | `authProvider` |
| Model | `<Name>Model` | `UserModel` |
| Entity | `<Name>Entity` | `UserEntity` |
| Usecase | `<Name>Usecase` | `LoginUsecase` |

## Dot Notation → Folder & Class

| Input | Feature Folder | Class |
|-------|----------------|-------|
| `home` | `features/home/` | `Home` |
| `auth.login` | `features/auth/` | `AuthLogin` |
| `cart.checkout` | `features/cart/` | `CartCheckout` |
| `user.setting.profile` | `features/user/` | `UserSettingProfile` |

## Rules

1. SELALU gunakan `snake_case` untuk file dan folder
2. SELALU gunakan `PascalCase` untuk class
3. SELALU gunakan `camelCase` untuk variable dan function
4. Feature folder = segment pertama dari dot notation
5. JANGAN gunakan singkatan yang ambigu (`usr` ❌, `user` ✅)
6. Prefix file test dengan nama file asli + `_test`
