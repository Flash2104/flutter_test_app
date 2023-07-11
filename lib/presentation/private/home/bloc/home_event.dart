part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();

  @override
  List<Object> get props => [];
}

class HomeLogoutEvent extends HomeEvent {
  const HomeLogoutEvent();

  @override
  List<Object> get props => [];
}
