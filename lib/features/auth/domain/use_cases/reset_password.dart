import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);


  
  Future<void> call(String email) async {
    return await _authRepository.resetPassword(email);
  }
}
