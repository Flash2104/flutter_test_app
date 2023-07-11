part of 'staff_list_bloc.dart';

enum LoadStaffListStatus {
  initial,
  inProgress,
  success,
  failure,
}

enum StaffListDeleteStatus {
  initial,
  inProgress,
  success,
  failure,
}

class StaffListState extends Equatable {
  const StaffListState({
    this.loadStatus = LoadStaffListStatus.initial,
    this.deleteStatus = StaffListDeleteStatus.initial,
    this.list = const [],
  });

  final LoadStaffListStatus loadStatus;
  final StaffListDeleteStatus deleteStatus;
  final List<WorkerData> list;

  StaffListState copyWith({
    LoadStaffListStatus Function()? loadStatus,
    StaffListDeleteStatus Function()? deleteStatus,
    List<WorkerData> Function()? list,
  }) {
    return StaffListState(
      loadStatus: loadStatus != null ? loadStatus() : this.loadStatus,
      deleteStatus: deleteStatus != null ? deleteStatus() : this.deleteStatus,
      list: list != null ? list() : this.list,
    );
  }

  @override
  List<Object> get props => [
        loadStatus,
        deleteStatus,
        list,
      ];
}
