import '../config.dart';
import '../utils.dart';

/// Templates for generating test files
class TestTemplates {
  TestTemplates(this.config);
  final YoConfig config;

  /// Generate unit test for usecase
  String usecaseTest(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);
    final featureName = YoUtils.getFeatureName(name);

    return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:${config.packageName}/features/$featureName/domain/repositories/${fileName}_repository.dart';
import 'package:${config.packageName}/features/$featureName/domain/usecases/${fileName}_usecase.dart';

import '${fileName}_usecase_test.mocks.dart';

@GenerateMocks([${className}Repository])
void main() {
  late ${className}Usecase usecase;
  late Mock${className}Repository mockRepository;

  setUp(() {
    mockRepository = Mock${className}Repository();
    usecase = ${className}Usecase(mockRepository);
  });

  group('${className}Usecase', () {
    test('should get data from repository', () async {
      // arrange
      when(mockRepository.getData())
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase.call();

      // assert
      expect(result, const Right(null));
      verify(mockRepository.getData()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      when(mockRepository.getData())
          .thenAnswer((_) async => const Left('Server error'));

      // act
      final result = await usecase.call();

      // assert
      expect(result.isLeft(), true);
      verify(mockRepository.getData()).called(1);
    });
  });
}
''';
  }

  /// Generate unit test for repository implementation
  String repositoryTest(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);
    final featureName = YoUtils.getFeatureName(name);

    return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:${config.packageName}/features/$featureName/data/datasources/${fileName}_remote_datasource.dart';
import 'package:${config.packageName}/features/$featureName/data/repositories/${fileName}_repository_impl.dart';

import '${fileName}_repository_impl_test.mocks.dart';

@GenerateMocks([${className}RemoteDatasource])
void main() {
  late ${className}RepositoryImpl repository;
  late Mock${className}RemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = Mock${className}RemoteDatasource();
    repository = ${className}RepositoryImpl(mockRemoteDatasource);
  });

  group('${className}Repository', () {
    test('should return data when remote call is successful', () async {
      // arrange
      when(mockRemoteDatasource.getData())
          .thenAnswer((_) async => null);

      // act
      final result = await repository.getData();

      // assert
      expect(result.isRight(), true);
      verify(mockRemoteDatasource.getData()).called(1);
    });

    test('should return failure when remote call fails', () async {
      // arrange
      when(mockRemoteDatasource.getData())
          .thenThrow(Exception('Server error'));

      // act
      final result = await repository.getData();

      // assert
      expect(result.isLeft(), true);
      verify(mockRemoteDatasource.getData()).called(1);
    });
  });
}
''';
  }

  /// Generate widget test for page
  String pageTest(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);
    final featureName = YoUtils.getFeatureName(name);

    switch (config.stateManagement) {
      case StateManagement.riverpod:
        return _riverpodPageTest(className, fileName, featureName);
      case StateManagement.getx:
        return _getxPageTest(className, fileName, featureName);
      case StateManagement.bloc:
        return _blocPageTest(className, fileName, featureName);
    }
  }

  String _riverpodPageTest(
    String className,
    String fileName,
    String featureName,
  ) =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:${config.packageName}/features/$featureName/presentation/pages/${fileName}_page.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: ${className}Page(),
      ),
    );
  }

  group('${className}Page', () {
    testWidgets('should render correctly', (tester) async {
      // arrange & act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(${className}Page), findsOneWidget);
    });

    testWidgets('should show loading indicator initially', (tester) async {
      // arrange & act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Add more widget tests here
  });
}
''';

  String _getxPageTest(String className, String fileName, String featureName) =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:${config.packageName}/features/$featureName/presentation/pages/${fileName}_page.dart';
import 'package:${config.packageName}/features/$featureName/presentation/controllers/${fileName}_controller.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(${className}Controller());
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest() {
    return const GetMaterialApp(
      home: ${className}Page(),
    );
  }

  group('${className}Page', () {
    testWidgets('should render correctly', (tester) async {
      // arrange & act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(${className}Page), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // arrange
      final controller = Get.find<${className}Controller>();
      controller.isLoading.value = true;

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Add more widget tests here
  });
}
''';

  String _blocPageTest(String className, String fileName, String featureName) =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:${config.packageName}/features/$featureName/presentation/pages/${fileName}_page.dart';
import 'package:${config.packageName}/features/$featureName/presentation/bloc/${fileName}_bloc.dart';

class Mock${className}Bloc extends MockBloc<${className}Event, ${className}State>
    implements ${className}Bloc {}

void main() {
  late Mock${className}Bloc mockBloc;

  setUp(() {
    mockBloc = Mock${className}Bloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<${className}Bloc>.value(
      value: mockBloc,
      child: const MaterialApp(
        home: ${className}Page(),
      ),
    );
  }

  group('${className}Page', () {
    testWidgets('should render correctly', (tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(${className}Initial());

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(${className}Page), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(${className}Loading());

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Add more widget tests here
  });
}
''';

  /// Generate provider/controller test
  String providerTest(String name) {
    final className = YoUtils.toClassName(name);
    final fileName = YoUtils.toFileName(name);
    final featureName = YoUtils.getFeatureName(name);

    switch (config.stateManagement) {
      case StateManagement.riverpod:
        return _riverpodProviderTest(className, fileName, featureName);
      case StateManagement.getx:
        return _getxControllerTest(className, fileName, featureName);
      case StateManagement.bloc:
        return _blocTest(className, fileName, featureName);
    }
  }

  String _riverpodProviderTest(
    String className,
    String fileName,
    String featureName,
  ) =>
      '''
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:${config.packageName}/features/$featureName/domain/usecases/${fileName}_usecase.dart';
import 'package:${config.packageName}/features/$featureName/presentation/providers/${fileName}_provider.dart';

import '${fileName}_provider_test.mocks.dart';

@GenerateMocks([${className}Usecase])
void main() {
  late ProviderContainer container;
  late Mock${className}Usecase mockUsecase;

  setUp(() {
    mockUsecase = Mock${className}Usecase();
    container = ProviderContainer(
      overrides: [
        // Add provider overrides here
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('${className}Provider', () {
    test('should return data when usecase succeeds', () async {
      // arrange
      when(mockUsecase.call())
          .thenAnswer((_) async => const Right(null));

      // act
      // final result = await container.read(${YoUtils.toCamelCase(className)}Provider.future);

      // assert
      // expect(result, isNotNull);
      verify(mockUsecase.call()).called(1);
    });

    test('should throw when usecase fails', () async {
      // arrange
      when(mockUsecase.call())
          .thenAnswer((_) async => const Left('Error'));

      // act & assert
      // expect(
      //   () => container.read(${YoUtils.toCamelCase(className)}Provider.future),
      //   throwsException,
      // );
    });
  });
}
''';

  String _getxControllerTest(
    String className,
    String fileName,
    String featureName,
  ) =>
      '''
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:${config.packageName}/features/$featureName/domain/usecases/${fileName}_usecase.dart';
import 'package:${config.packageName}/features/$featureName/presentation/controllers/${fileName}_controller.dart';

import '${fileName}_controller_test.mocks.dart';

@GenerateMocks([${className}Usecase])
void main() {
  late ${className}Controller controller;
  late Mock${className}Usecase mockUsecase;

  setUp(() {
    Get.testMode = true;
    mockUsecase = Mock${className}Usecase();
    controller = ${className}Controller();
    // Inject mock usecase if needed
  });

  tearDown(() {
    Get.reset();
  });

  group('${className}Controller', () {
    test('should set loading to true when fetching data', () async {
      // arrange
      when(mockUsecase.call())
          .thenAnswer((_) async => const Right(null));

      // act
      // controller.fetchData();

      // assert
      expect(controller.isLoading.value, true);
    });

    test('should set loading to false after data is fetched', () async {
      // arrange
      when(mockUsecase.call())
          .thenAnswer((_) async => const Right(null));

      // act
      // await controller.fetchData();

      // assert
      expect(controller.isLoading.value, false);
    });

    test('should set error when usecase fails', () async {
      // arrange
      when(mockUsecase.call())
          .thenAnswer((_) async => const Left('Error'));

      // act
      // await controller.fetchData();

      // assert
      expect(controller.error.value, 'Error');
    });
  });
}
''';

  String _blocTest(String className, String fileName, String featureName) => '''
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:${config.packageName}/features/$featureName/domain/usecases/${fileName}_usecase.dart';
import 'package:${config.packageName}/features/$featureName/presentation/bloc/${fileName}_bloc.dart';

import '${fileName}_bloc_test.mocks.dart';

@GenerateMocks([${className}Usecase])
void main() {
  late ${className}Bloc bloc;
  late Mock${className}Usecase mockUsecase;

  setUp(() {
    mockUsecase = Mock${className}Usecase();
    bloc = ${className}Bloc(mockUsecase);
  });

  tearDown(() {
    bloc.close();
  });

  group('${className}Bloc', () {
    test('initial state should be ${className}Initial', () {
      expect(bloc.state, equals(${className}Initial()));
    });

    blocTest<${className}Bloc, ${className}State>(
      'should emit [Loading, Loaded] when data is fetched successfully',
      build: () {
        when(mockUsecase.call())
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(Fetch$className()),
      expect: () => [
        ${className}Loading(),
        ${className}Loaded(data: null),
      ],
      verify: (_) {
        verify(mockUsecase.call()).called(1);
      },
    );

    blocTest<${className}Bloc, ${className}State>(
      'should emit [Loading, Error] when fetching data fails',
      build: () {
        when(mockUsecase.call())
            .thenAnswer((_) async => const Left('Server error'));
        return bloc;
      },
      act: (bloc) => bloc.add(Fetch$className()),
      expect: () => [
        ${className}Loading(),
        const ${className}Error(message: 'Server error'),
      ],
    );
  });
}
''';
}
