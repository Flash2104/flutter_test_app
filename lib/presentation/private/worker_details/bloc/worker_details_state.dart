part of 'worker_details_bloc.dart';

enum LoadWorkerStatus {
  initial,
  inProgress,
  success,
  failure,
}

class WorkerDetailsState extends Equatable {
  const WorkerDetailsState({
    this.loadStatus = LoadWorkerStatus.initial,
    this.workerData,
  });

  final LoadWorkerStatus loadStatus;
  final WorkerData? workerData;

  WorkerDetailsState copyWith({
    LoadWorkerStatus? loadStatus,
    WorkerData? workerData,
  }) {
    return WorkerDetailsState(
      loadStatus: loadStatus ?? this.loadStatus,
      workerData: workerData ?? this.workerData,
    );
  }

  @override
  List<Object?> get props => [
        loadStatus,
        workerData,
      ];
}
