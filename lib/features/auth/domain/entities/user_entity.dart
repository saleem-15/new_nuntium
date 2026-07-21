import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}