import 'package:test_web_app/domain/authentication_repository.dart';
import 'package:test_web_app/domain/models/user_data.dart';
import 'package:test_web_app/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:test_web_app/presentation/public/login/view/inputs/password_input.dart';
import 'package:test_web_app/presentation/shared/formz_input/email_input.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final IAuthenticationRepository _authRepository = getIt<IAuthenticationRepository>();

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.password, email]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: LoginProcessStatus.inProgress));
      try {
        final loggedIn = await _authRepository.login(
          user: AuthUserRequest(email: state.email.value, password: state.password.value),
        );
        if (loggedIn == true) {
          emit(state.copyWith(status: LoginProcessStatus.success));
        } else {
          emit(state.copyWith(status: LoginProcessStatus.failure));
        }
      } catch (_) {
        emit(state.copyWith(status: LoginProcessStatus.failure));
      }
    }
  }
}
