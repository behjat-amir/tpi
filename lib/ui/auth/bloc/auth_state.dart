part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState(this.isRememberMe);

   final bool isRememberMe;

  @override
  List<Object> get props => [isRememberMe];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.isRememberMe);
}

class AuthError extends AuthState {
  final AppException exception;
  const AuthError(super.isRememberMe, this.exception);
}

class AuthLoading extends AuthState {
  const AuthLoading(super.isRememberMe);
}

class AuthSuccess extends AuthState {
  const AuthSuccess(super.isRememberMe);
}
