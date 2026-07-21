import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuntium/features/auth/domain/use_cases/send_email_verification_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/signup_use_case.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignupUseCase _signUpUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;

  SignUpCubit({
    required SignupUseCase signUpUseCase,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
  })  : _signUpUseCase = signUpUseCase,
        _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
        super(const SignUpInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const SignUpLoading());

    final result = await _signUpUseCase.call(
      email.trim(),
      password.trim(),
      name.trim(),
    );

    result.fold(
      (failure) => emit(SignUpError(failure.message)),
      (_) async {
        final emailResult = await _sendEmailVerificationUseCase.call();
        emailResult.fold(
          (failure) => emit(SignUpError(failure.message)),
          (_) => emit(const SignUpSuccess()),
        );
      },
    );
  }
}
