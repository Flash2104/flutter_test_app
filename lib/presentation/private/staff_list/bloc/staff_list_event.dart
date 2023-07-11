part of 'staff_list_bloc.dart';

abstract class StaffListEvent extends Equatable {
  const StaffListEvent();

  @override
  List<Object> get props => [];
}

class StaffListInitialEvent extends StaffListEvent {
  const StaffListInitialEvent();

  @override
  List<Object> get props => [];
}

class StaffListDeleteEvent extends StaffListEvent {
  const StaffListDeleteEvent(this.id);
  final String id;

  @override
  List<Object> get props => [id];
}
