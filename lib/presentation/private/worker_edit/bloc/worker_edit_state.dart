part of 'worker_edit_bloc.dart';

enum EditWorkerStatus {
  initial,
  inProgress,
  success,
  failure,
}

enum LoadEditWorkerInitStatus {
  initial,
  inProgress,
  success,
  failure,
}

class WorkerEditState extends Equatable {
  const WorkerEditState({
    this.loadStatus = LoadEditWorkerInitStatus.initial,
    this.editStatus = EditWorkerStatus.initial,
    this.editData,
    this.isValid = false,
  });

  final LoadEditWorkerInitStatus loadStatus;
  final EditWorkerStatus editStatus;
  final WorkerData? editData;
  final bool isValid;

  WorkerEditState copyWith({
    LoadEditWorkerInitStatus? loadStatus,
    EditWorkerStatus? editStatus,
    WorkerData? editData,
    bool? isValid,
  }) {
    return WorkerEditState(
      loadStatus: loadStatus ?? this.loadStatus,
      editStatus: editStatus ?? this.editStatus,
      editData: editData ?? this.editData,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        editStatus,
        loadStatus,
        editData,
        isValid,
      ];
}
