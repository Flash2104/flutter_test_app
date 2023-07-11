import 'dart:async';

import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/domain/staff_repository.dart';
import 'package:test_web_app/get_it.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'staff_list_event.dart';
part 'staff_list_state.dart';

class StaffListBloc extends Bloc<StaffListEvent, StaffListState> {
  StaffListBloc() : super(const StaffListState()) {
    on<StaffListInitialEvent>(_onInitial);
    on<StaffListDeleteEvent>(_onDelete);
  }

  final IStaffRepository _staffListRepository = getIt<IStaffRepository>();

  Future<void> _onInitial(
    StaffListInitialEvent event,
    Emitter<StaffListState> emit,
  ) async {
    try {
      emit(state.copyWith(loadStatus: () => LoadStaffListStatus.inProgress));

      await emit.forEach<List<WorkerData>>(
        _staffListRepository.listStaff(),
        onData: (list) {
          return state.copyWith(
            loadStatus: () => LoadStaffListStatus.success,
            list: () => list,
          );
        },
        onError: (_, __) => state.copyWith(
          loadStatus: () => LoadStaffListStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadStatus: () => LoadStaffListStatus.failure));
    }
  }

  FutureOr<void> _onDelete(
      StaffListDeleteEvent event, Emitter<StaffListState> emit) async {
    try {
      emit(state.copyWith(deleteStatus: () => StaffListDeleteStatus.inProgress));
      await _staffListRepository.delete(event.id);
      emit(state.copyWith(deleteStatus: () => StaffListDeleteStatus.success));
    } catch (_) {
      emit(state.copyWith(deleteStatus: () => StaffListDeleteStatus.failure));
    }
  }
}
