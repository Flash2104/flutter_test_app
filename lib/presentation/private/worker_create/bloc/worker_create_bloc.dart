import 'dart:async';
import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/domain/staff_repository.dart';
import 'package:test_web_app/get_it.dart';

import 'package:equatable/equatable.dart';
part 'worker_create_event.dart';
part 'worker_create_state.dart';

class WorkerCreateBloc extends HydratedBloc<WorkerCreateEvent, WorkerCreateState> {
  WorkerCreateBloc() : super(const WorkerCreateState()) {
    on<WorkerCreateUpdatedDataEvent>(_onDataUpdated);
    on<WorkerCreateSubmitEvent>(
      _onSubmit,
      transformer: (events, mapper) =>
          events.throttleTime(const Duration(milliseconds: 200)).switchMap(mapper),
    );
  }

  final IStaffRepository _staffRepository = getIt<IStaffRepository>();

  FutureOr<void> _onDataUpdated(
      WorkerCreateUpdatedDataEvent event, Emitter<WorkerCreateState> emit) {
    emit(state.copyWith(
      createData: event.data,
      isValid: event.isValid,
    ));
  }

  Future<void> _onSubmit(
    WorkerCreateSubmitEvent event,
    Emitter<WorkerCreateState> emit,
  ) async {
    try {
      if (!state.isValid) {
        return;
      }
      emit(state.copyWith(createStatus: CreateWorkerStatus.inProgress));
      final created = await _staffRepository.saveWorker(state.createData!);
      emit(state.copyWith(createStatus: CreateWorkerStatus.success, createData: created));
      await clear();
    } catch (_) {
      log('Error', error: _);
      emit(state.copyWith(createStatus: CreateWorkerStatus.failure));
    }
  }

  @override
  WorkerCreateState? fromJson(Map<String, dynamic> json) {
    return WorkerCreateState(
      createStatus: json['status'] != null
          ? CreateWorkerStatus.values[json['status']]
          : CreateWorkerStatus.initial,
      createData: json['data'] != null ? WorkerData.fromJson(json['data']) : null,
      isValid: json['isValid'] == null ? false : json['isValid'] as bool,
    );
  }

  @override
  Map<String, dynamic>? toJson(WorkerCreateState state) {
    return {
      'status': state.createStatus.index,
      'data': state.createData?.toJson(),
      'isValid': state.isValid,
    };
  }
}
