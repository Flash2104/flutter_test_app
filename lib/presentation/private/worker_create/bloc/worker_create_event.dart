part of 'worker_create_bloc.dart';

abstract class WorkerCreateEvent extends Equatable {
  const WorkerCreateEvent();

  @override
  List<Object?> get props => [];
}

class WorkerCreateUpdatedDataEvent extends WorkerCreateEvent {
  const WorkerCreateUpdatedDataEvent({
    required this.data,
    required this.isValid,
  });

  final WorkerData? data;
  final bool isValid;

  @override
  List<Object?> get props => [data, isValid];
}

class WorkerCreateSubmitEvent extends WorkerCreateEvent {
  const WorkerCreateSubmitEvent();

  @override
  List<Object> get props => [];
}
