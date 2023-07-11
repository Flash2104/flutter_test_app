import 'dart:async';
import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/domain/staff_repository.dart';
import 'package:test_web_app/get_it.dart';

import 'package:equatable/equatable.dart';
part 'worker_details_event.dart';
part 'worker_details_state.dart';

class WorkerDetailsBloc extends Bloc<WorkerDetailsEvent, WorkerDetailsState> {
  WorkerDetailsBloc() : super(const WorkerDetailsState()) {
    on<WorkerDetailsInitEvent>(_onInit);
  }

  final IStaffRepository _staffRepository = getIt<IStaffRepository>();

  FutureOr<void> _onInit(
      WorkerDetailsInitEvent event, Emitter<WorkerDetailsState> emit) async {
    try {
      emit(state.copyWith(loadStatus: LoadWorkerStatus.inProgress));
      final worker = await _staffRepository.getWorker(event.id);
      if (worker == null) {
        emit(state.copyWith(loadStatus: LoadWorkerStatus.failure));
      }
      emit(state.copyWith(
        loadStatus: LoadWorkerStatus.success,
        workerData: worker,
      ));
    } catch (_) {
      log('Error', error: _);
      emit(state.copyWith(loadStatus: LoadWorkerStatus.failure));
    }
  }
}
