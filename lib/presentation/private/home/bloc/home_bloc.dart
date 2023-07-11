import 'package:test_web_app/domain/authentication_repository.dart';
import 'package:test_web_app/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeInitialEvent>(_onInitial);
    on<HomeLogoutEvent>(_onLogout);
  }

  final IAuthenticationRepository _authRepository = getIt<IAuthenticationRepository>();

  Future<void> _onInitial(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(initStatus: HomeInitProcessStatus.inProgress));
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      emit(state.copyWith(
          isLoggedIn: isLoggedIn, initStatus: HomeInitProcessStatus.success));
    } catch (_) {
      emit(state.copyWith(initStatus: HomeInitProcessStatus.failure));
    }
  }

  Future<void> _onLogout(
    HomeLogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(logoutStatus: LogoutProcessStatus.inProgress));
    try {
      final logouted = await _authRepository.logout();
      if (logouted == true) {
        emit(state.copyWith(logoutStatus: LogoutProcessStatus.success));
      } else {
        emit(state.copyWith(logoutStatus: LogoutProcessStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(logoutStatus: LogoutProcessStatus.failure));
    }
  }
}
