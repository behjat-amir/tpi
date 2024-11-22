import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tpi/common/exceptions.dart';
import 'package:tpi/data/repo/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  bool isRememberMe;
  AuthBloc(this.authRepository, {this.isRememberMe = false}) : super(AuthInitial(isRememberMe)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthButtonIsClicked) {
          emit(AuthLoading(isRememberMe));
          await authRepository.login(event.username, event.password);
          emit(AuthSuccess(isRememberMe));
        } else if(event is AuthRememberMeIsClicked) {
          isRememberMe = !isRememberMe;
          await authRepository.setIsRememberMe(isRememberMe);
          emit(AuthInitial(isRememberMe));
        }
      } catch (e) {
        emit(AuthError(isRememberMe, AppException()));
      }
    });
  }
}
