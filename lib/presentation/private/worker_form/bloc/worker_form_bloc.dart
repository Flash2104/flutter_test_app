import 'dart:async';
import 'package:test_web_app/domain/models/worker_data.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:test_web_app/presentation/private/worker_form/view/inputs/date_input.dart';
import 'package:test_web_app/presentation/private/worker_form/view/inputs/name_input.dart';
import 'package:test_web_app/presentation/private/worker_form/view/inputs/note_input.dart';
import 'package:test_web_app/presentation/private/worker_form/view/worker_form_view.dart';
import 'package:test_web_app/presentation/shared/formz_input/email_input.dart';

part 'worker_form_event.dart';
part 'worker_form_state.dart';

class WorkerFormBloc extends Bloc<WorkerFormEvent, WorkerFormState> {
  WorkerFormBloc() : super(const WorkerFormState()) {
    on<WorkerFormInitEvent>(_onInit);
    on<WorkerFormStringValueChanged>(_onFormInputChanged);
  }

  FutureOr<void> _onInit(WorkerFormInitEvent event, Emitter<WorkerFormState> emit) {
    emit(state.copyWith(
      initialWorkerData: event.data,
      workerData: event.data,
      isReadonly: event.isReadonly,
      formUpdated: event.formUpdated,
    ));
    if (event.data != null) {
      final name = NameInput.dirty(value: event.data!.name, isRequired: true);
      final familyName = NameInput.dirty(value: event.data!.familyname, isRequired: true);
      final surname = NameInput.dirty(value: event.data!.name, isRequired: false);
      final email = EmailInput.dirty(event.data!.email);
      final date = DateInput.dirty(
          value: event.data!.birthDate == null
              ? ''
              : '${event.data!.birthDate!.day}-${event.data!.birthDate!.month}-${event.data!.birthDate!.year}');
      final note = NoteInput.dirty(value: event.data!.note ?? '');
      emit(state.copyWith(
        email: email,
        birthDate: date,
        familyname: familyName,
        name: name,
        note: note,
        surname: surname,
        isValid: Formz.validate([
          state.name,
          state.familyname,
          state.surname,
          state.email,
          state.birthDate,
          state.note,
        ]),
      ));
    }
  }

  FutureOr<void> _onFormInputChanged(
      WorkerFormStringValueChanged event, Emitter<WorkerFormState> emit) {
    var workerData = state.workerData ?? WorkerData.empty();
    switch (event.fieldFormName) {
      case FieldFormName.name:
        final name = NameInput.dirty(value: event.value, isRequired: true);
        workerData = workerData.copyWith(name: name.value);
        emit(state.copyWith(
          name: name,
        ));
        break;
      case FieldFormName.familyname:
        final name = NameInput.dirty(value: event.value, isRequired: true);
        workerData = workerData.copyWith(familyname: name.value);
        emit(state.copyWith(familyname: name));
        break;
      case FieldFormName.surname:
        final name = NameInput.dirty(value: event.value, isRequired: false);
        workerData = workerData.copyWith(surname: name.value);

        emit(state.copyWith(surname: name));
        break;
      case FieldFormName.birthDate:
        final bd = DateInput.dirty(value: event.value);

        DateTime? date;
        try {
          date = DateInput.DATE_FORMAT.parse(event.value);
        } catch (_) {}
        workerData = workerData.copyWith(birthDate: date);

        emit(state.copyWith(birthDate: bd));
        break;
      case FieldFormName.email:
        final email = EmailInput.dirty(event.value);
        workerData = workerData.copyWith(email: email.value);

        emit(state.copyWith(email: email));
        break;
      case FieldFormName.note:
        final note = NoteInput.dirty(value: event.value);
        workerData = workerData.copyWith(note: note.value);
        emit(state.copyWith(note: note));
        break;
      default:
        throw UnimplementedError('${event.fieldFormName}');
    }
    emit(
      state.copyWith(
        workerData: workerData,
        isValid: Formz.validate([
          state.name,
          state.familyname,
          state.surname,
          state.email,
          state.birthDate,
          state.note,
        ]),
      ),
    );
  }
}
