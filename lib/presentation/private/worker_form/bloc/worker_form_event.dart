part of 'worker_form_bloc.dart';

enum FieldFormName {
  name,
  familyname,
  surname,
  email,
  birthDate,
  note,
}

abstract class WorkerFormEvent extends Equatable {
  const WorkerFormEvent();

  @override
  List<Object?> get props => [];
}

class WorkerFormInitEvent extends WorkerFormEvent {
  const WorkerFormInitEvent({
    required this.data,
    required this.isReadonly,
    required this.formUpdated,
  });

  final WorkerData? data;
  final bool isReadonly;
  final void Function(WorkerFormUpdatedData)? formUpdated;

  @override
  List<Object?> get props => [
        data,
        isReadonly,
        formUpdated,
      ];
}

class WorkerFormStringValueChanged extends WorkerFormEvent {
  const WorkerFormStringValueChanged({
    required this.value,
    required this.fieldFormName,
  });

  final String value;
  final FieldFormName fieldFormName;

  @override
  List<Object> get props => [value, fieldFormName];
}
