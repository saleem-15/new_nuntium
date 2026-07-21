import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/errors/exceptions.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/core/network/network_info.dart';
import 'package:nuntium/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:nuntium/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nuntium/features/auth/domain/entities/user_entity.dart';

import 'auth_repository_impl_test.mocks.dart';
import '../../../../helpers/fake_crash_reporter.dart';

@GenerateMocks(
  [AuthRemoteDataSource, NetworkInfo],
  customMocks: [MockSpec<User>()],
)
void main() {
  setUpAll(() {
    if (!getIt.isRegistered<CrashReporter>()) {
      getIt.registerSingleton<CrashReporter>(FakeCrashReporter());
    }
  });
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockUser mockFirebaseUser;
  late AuthRepositoryImpl repository;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUid = 'uid_123';
  const tDisplayName = 'Test User';

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFirebaseUser = MockUser();
    repository = AuthRepositoryImpl(mockAuthRemoteDataSource, mockNetworkInfo);

    when(mockFirebaseUser.uid).thenReturn(tUid);
    when(mockFirebaseUser.email).thenReturn(tEmail);
    when(mockFirebaseUser.displayName).thenReturn(tDisplayName);
  });

  group('login', () {
    test('returns Left(OfflineFailure) when device is offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.login(tEmail, tPassword);

      expect(result, equals(Left(OfflineFailure())));
      verifyNever(mockAuthRemoteDataSource.signInWithEmail(any, any));
    });

    test(
      'returns Right(UserEntity) when online and signInWithEmail succeeds',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockAuthRemoteDataSource.signInWithEmail(tEmail, tPassword),
        ).thenAnswer((_) async => mockFirebaseUser);

        final result = await repository.login(tEmail, tPassword);

        expect(
          result,
          equals(
            const Right(
              UserEntity(uid: tUid, email: tEmail, displayName: tDisplayName),
            ),
          ),
        );
        verify(
          mockAuthRemoteDataSource.signInWithEmail(tEmail, tPassword),
        ).called(1);
      },
    );

    test(
      'returns Left(Failure) when remote data source throws AuthException',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockAuthRemoteDataSource.signInWithEmail(tEmail, tPassword),
        ).thenThrow(
          AuthException(message: 'User not found', code: 'user-not-found'),
        );

        final result = await repository.login(tEmail, tPassword);

        expect(
          result,
          equals(
            Left(AuthFailure('User not found', errorCode: 'user-not-found')),
          ),
        );
        verify(
          mockAuthRemoteDataSource.signInWithEmail(tEmail, tPassword),
        ).called(1);
      },
    );
  });

  group('signInWithGoogle', () {
    test('returns Left(OfflineFailure) when device is offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.signInWithGoogle();

      expect(result, equals(Left(OfflineFailure())));
      verifyNever(mockAuthRemoteDataSource.signInWithGoogle());
    });

    test(
      'returns Right(User) when online and signInWithGoogle succeeds',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockAuthRemoteDataSource.signInWithGoogle(),
        ).thenAnswer((_) async => mockFirebaseUser);

        final result = await repository.signInWithGoogle();

        expect(result, equals(Right(mockFirebaseUser)));
        verify(mockAuthRemoteDataSource.signInWithGoogle()).called(1);
      },
    );
  });

  group('signOut', () {
    test('returns Right(null) when signOut succeeds', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockAuthRemoteDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, equals(const Right(null)));
      verify(mockAuthRemoteDataSource.signOut()).called(1);
    });
  });
}
