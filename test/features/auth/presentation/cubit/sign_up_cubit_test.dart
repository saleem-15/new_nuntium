import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuntium/core/errors/failures.dart';
import 'package:nuntium/features/auth/domain/entities/user_entity.dart';
import 'package:nuntium/features/auth/domain/use_cases/send_email_verification_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:nuntium/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/sign_up_state.dart';

import 'sign_up_cubit_test.mocks.dart';

@GenerateMocks([SignupUseCase, SendEmailVerificationUseCase])
void main() {
  late MockSignupUseCase mockSignupUseCase;
  late MockSendEmailVerificationUseCase mockSendEmailVerificationUseCase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'John Doe';
  const tUserEntity = UserEntity(
    uid: '123',
    email: tEmail,
    displayName: tName,
  );

  SignUpCubit buildCubit() => SignUpCubit(
        signUpUseCase: mockSignupUseCase,
        sendEmailVerificationUseCase: mockSendEmailVerificationUseCase,
      );

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    mockSendEmailVerificationUseCase = MockSendEmailVerificationUseCase();
  });

  group('signUp', () {
    blocTest<SignUpCubit, SignUpState>(
      'Emits [SignUpLoading, SignUpSuccess] and triggers sendEmailVerification when signUp succeeds',
      setUp: () {
        when(mockSignupUseCase.call(tEmail, tPassword, tName))
            .thenAnswer((_) async => const Right(tUserEntity));
        when(mockSendEmailVerificationUseCase.call())
            .thenAnswer((_) async => const Right(null));
      },
      build: buildCubit,
      act: (cubit) => cubit.signUp(
        email: '  test@example.com  ',
        password: '  password123  ',
        name: '  John Doe  ',
      ),
      expect: () => [
        const SignUpLoading(),
        const SignUpSuccess(),
      ],
      verify: (_) {
        verify(mockSignupUseCase.call(tEmail, tPassword, tName)).called(1);
        verify(mockSendEmailVerificationUseCase.call()).called(1);
      },
    );

    blocTest<SignUpCubit, SignUpState>(
      'Emits [SignUpLoading, SignUpError] when signUp fails',
      setUp: () {
        when(mockSignupUseCase.call(tEmail, tPassword, tName)).thenAnswer(
          (_) async => const Left(ServerFailure('Email already in use')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.signUp(
        email: tEmail,
        password: tPassword,
        name: tName,
      ),
      expect: () => [
        const SignUpLoading(),
        const SignUpError('Email already in use'),
      ],
      verify: (_) {
        verify(mockSignupUseCase.call(tEmail, tPassword, tName)).called(1);
        verifyNever(mockSendEmailVerificationUseCase.call());
      },
    );
  });
}
