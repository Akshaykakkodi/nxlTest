import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/application/core/utils/enums.dart';

class AuthState extends Equatable {
  final ApiState authState;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.authState = ApiState.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({ApiState? authState, User? user, String? errorMessage}) {
    return AuthState(
      authState: authState ?? this.authState,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [authState, user, errorMessage];
}
