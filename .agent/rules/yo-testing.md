# Testing Rules

## Wajib Test

Setiap fitur yang di-generate HARUS punya test minimal:

1. **Unit test** untuk usecase dan repository
2. **Widget test** untuk page utama
3. **Provider/Controller test** untuk state management

## Naming Convention

```
test/
├── features/<feature>/
│   ├── data/
│   │   ├── datasources/<name>_datasource_test.dart
│   │   ├── models/<name>_model_test.dart
│   │   └── repositories/<name>_repository_impl_test.dart
│   ├── domain/
│   │   └── usecases/<name>_usecase_test.dart
│   └── presentation/
│       ├── pages/<name>_page_test.dart
│       └── providers/<name>_provider_test.dart
```

## Pattern

```dart
// ✅ Benar — descriptive test name
test('should return user when login is successful', () {
  // arrange
  when(() => mockRepo.login(email, password)).thenAnswer((_) async => user);

  // act
  final result = await usecase(LoginParams(email: email, password: password));

  // assert
  expect(result, equals(user));
  verify(() => mockRepo.login(email, password)).called(1);
});

// ❌ Salah — test name tidak jelas
test('test 1', () { ... });
```

## Rules

1. **Gunakan generator**: `dart run yo.dart test:<name>` — jangan tulis manual
2. **Mock dependencies**: gunakan `mockito` atau `mocktail`
3. **Test semua state**: loading, success, error, empty
4. **Arrange-Act-Assert**: selalu ikuti pola AAA
5. **Isolasi**: setiap test independen, tidak bergantung test lain
6. **Target coverage**: minimal 80% untuk domain layer
