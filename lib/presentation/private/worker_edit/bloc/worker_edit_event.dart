part of 'worker_edit_bloc.dart';

abstract class WorkerEditEvent extends Equatable {
  const WorkerEditEvent();

  @override
  List<Object?> get props => [];
}

class WorkerEditInitEvent extends WorkerEditEvent {
  const WorkerEditInitEvent({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}

class WorkerEditUpdatedDataEvent extends WorkerEditEvent {
  const WorkerEditUpdatedDataEvent({
    required this.data,
    required this.isValid,
  });

  final WorkerData? data;
  final bool isValid;

  @override
  List<Object?> get props => [data, isValid];
}

class WorkerEditSubmitEvent extends WorkerEditEvent {
  const WorkerEditSubmitEvent();

  @override
  List<Object> get props => [];
}
