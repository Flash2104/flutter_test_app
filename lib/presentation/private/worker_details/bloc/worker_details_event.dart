part of 'worker_details_bloc.dart';

abstract class WorkerDetailsEvent extends Equatable {
  const WorkerDetailsEvent();

  @override
  List<Object?> get props => [];
}

class WorkerDetailsInitEvent extends WorkerDetailsEvent {
  const WorkerDetailsInitEvent({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [
        id,
      ];
}

class WorkerDetailsDeleteEvent extends WorkerDetailsEvent {
  const WorkerDetailsDeleteEvent();

  @override
  List<Object> get props => [];
}
