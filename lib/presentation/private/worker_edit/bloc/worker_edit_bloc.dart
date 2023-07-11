import 'dart:async';
import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/domain/staff_repository.dart';
import 'package:test_web_app/get_it.dart';

import 'package:equatable/equatable.dart';
part 'worker_edit_event.dart';
part 'worker_edit_state.dart';

class WorkerEditBloc extends Bloc<WorkerEditEvent, WorkerEditState> {
  WorkerEditBloc() : super(const WorkerEditState()) {
    on<WorkerEditInitEvent>(_onInit);
    on<WorkerEditUpdatedDataEvent>(_onDataUpdated);
    on<WorkerEditSubmitEvent>(
      _onSubmit,
      transformer: (events, mapper) =>
          events.throttleTime(const Duration(milliseconds: 200)).switchMap(mapper),
    );
  }

  final IStaffRepository _staffRepository = getIt<IStaffRepository>();

  FutureOr<void> _onDataUpdated(
      WorkerEditUpdatedDataEvent event, Emitter<WorkerEditState> emit) {
    emit(state.copyWith(
      editData: event.data,
      isValid: event.isValid,
    ));
  }

  Future<void> _onSubmit(
    WorkerEditSubmitEvent event,
    Emitter<WorkerEditState> emit,
  ) async {
    try {
      if (!state.isValid) {
        return;
      }
      emit(state.copyWith(editStatus: EditWorkerStatus.inProgress));
      final edited = await _staffRepository.saveWorker(state.editData!);
      emit(state.copyWith(editStatus: EditWorkerStatus.success, editData: edited));
    } catch (_) {
      log('Error', error: _);
      emit(state.copyWith(editStatus: EditWorkerStatus.failure));
    }
  }

  FutureOr<void> _onInit(WorkerEditInitEvent event, Emitter<WorkerEditState> emit) async {
    try {
      emit(state.copyWith(loadStatus: LoadEditWorkerInitStatus.inProgress));
      final worker = await _staffRepository.getWorker(event.id);
      if (worker == null) {
        emit(state.copyWith(loadStatus: LoadEditWorkerInitStatus.failure));
      }
      emit(state.copyWith(
        loadStatus: LoadEditWorkerInitStatus.success,
        editData: worker,
      ));
    } catch (_) {
      log('Error', error: _);
      emit(state.copyWith(loadStatus: LoadEditWorkerInitStatus.failure));
    }
  }
}
