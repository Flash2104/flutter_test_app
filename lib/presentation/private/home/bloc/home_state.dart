part of 'home_bloc.dart';

enum LogoutProcessStatus {
  initial,
  inProgress,
  success,
  failure,
}

enum HomeInitProcessStatus {
  initial,
  inProgress,
  success,
  failure,
}

class HomeState extends Equatable {
  const HomeState({
    this.initStatus = HomeInitProcessStatus.initial,
    this.isLoggedIn = false,
    this.logoutStatus = LogoutProcessStatus.initial,
  });

  final HomeInitProcessStatus initStatus;
  final LogoutProcessStatus logoutStatus;
  final bool isLoggedIn;

  HomeState copyWith({
    bool? isLoggedIn,
    HomeInitProcessStatus? initStatus,
    LogoutProcessStatus? logoutStatus,
  }) {
    return HomeState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      initStatus: initStatus ?? this.initStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object> get props => [
        logoutStatus,
        isLoggedIn,
        initStatus,
      ];
}
