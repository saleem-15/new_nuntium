import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/features/auth/domain/entities/user_entity.dart';
import 'package:nuntium/features/auth/domain/use_cases/login_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:nuntium/features/auth/presentation/cubit/login_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/login_state.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks(
  [
    LoginUseCase,
    SignInWithGoogleUseCase,
  ],
  customMocks: [
    MockSpec<User>(),
  ],
)
void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockUser mockUser;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUserEntity = UserEntity(
    uid: '123',
    email: tEmail,
    displayName: 'Test User',
  );

  LoginCubit buildCubit() => LoginCubit(
        loginUseCase: mockLoginUseCase,
        signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockUser = MockUser();
  });

  group('signIn', () {
    blocTest<LoginCubit, LoginState>(
      'Emits [LoginLoading, LoginSuccess] and trims inputs when signIn succeeds',
      setUp: () {
        when(mockLoginUseCase.call(tEmail, tPassword))
            .thenAnswer((_) async => const Right(tUserEntity));
      },
      build: buildCubit,
      act: (cubit) => cubit.signIn(
        email: '  test@example.com  ',
        password: '  password123  ',
      ),
      expect: () => [
        const LoginLoading(),
        const LoginSuccess(),
      ],
      verify: (_) {
        verify(mockLoginUseCase.call(tEmail, tPassword)).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'Emits [LoginLoading, LoginError] when signIn fails',
      setUp: () {
        when(mockLoginUseCase.call(tEmail, tPassword)).thenAnswer(
          (_) async => const Left(AuthFailure('Invalid credentials')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.signIn(email: tEmail, password: tPassword),
      expect: () => [
        const LoginLoading(),
        const LoginError('Invalid credentials'),
      ],
      verify: (_) {
        verify(mockLoginUseCase.call(tEmail, tPassword)).called(1);
      },
    );
  });

  group('signInWithGoogle', () {
    blocTest<LoginCubit, LoginState>(
      'Emits [LoginLoading, LoginSuccess] when signInWithGoogle succeeds',
      setUp: () {
        when(mockSignInWithGoogleUseCase.call())
            .thenAnswer((_) async => Right(mockUser));
      },
      build: buildCubit,
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        const LoginLoading(),
        const LoginSuccess(),
      ],
      verify: (_) {
        verify(mockSignInWithGoogleUseCase.call()).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'Emits [LoginLoading, LoginError] when signInWithGoogle fails',
      setUp: () {
        when(mockSignInWithGoogleUseCase.call()).thenAnswer(
          (_) async => const Left(AuthFailure('Google Sign-In canceled')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.signInWithGoogle(),
      expect: () => [
        const LoginLoading(),
        const LoginError('Google Sign-In canceled'),
      ],
      verify: (_) {
        verify(mockSignInWithGoogleUseCase.call()).called(1);
      },
    );
  });
}
