part of 'worker_create_bloc.dart';

enum CreateWorkerStatus {
  initial,
  inProgress,
  success,
  failure,
}

class WorkerCreateState extends Equatable {
  const WorkerCreateState({
    this.createStatus = CreateWorkerStatus.initial,
    this.createData,
    this.isValid = false,
  });

  final CreateWorkerStatus createStatus;
  final WorkerData? createData;
  final bool isValid;

  WorkerCreateState copyWith({
    CreateWorkerStatus? createStatus,
    WorkerData? createData,
    bool? isValid,
  }) {
    return WorkerCreateState(
      createStatus: createStatus ?? this.createStatus,
      createData: createData ?? this.createData,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        createStatus,
        createData,
        isValid,
      ];
}
