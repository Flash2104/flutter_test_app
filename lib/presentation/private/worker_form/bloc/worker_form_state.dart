part of 'worker_form_bloc.dart';

class WorkerFormState extends Equatable {
  const WorkerFormState({
    this.name = const NameInput.pure(isRequired: true),
    this.familyname = const NameInput.pure(isRequired: true),
    this.surname = const NameInput.pure(isRequired: false),
    this.email = const EmailInput.pure(),
    this.birthDate = const DateInput.pure(),
    this.note = const NoteInput.pure(),
    this.isValid = false,
    this.isReadonly = false,
    this.workerData,
    this.formUpdated,
    this.initialWorkerData,
  });

  final NameInput name;
  final NameInput familyname;
  final NameInput surname;
  final EmailInput email;
  final DateInput birthDate;
  final NoteInput note;
  final bool isValid;
  final bool isReadonly;
  final WorkerData? initialWorkerData;
  final WorkerData? workerData;
  final void Function(WorkerFormUpdatedData)? formUpdated;

  WorkerFormState copyWith({
    NameInput? name,
    NameInput? familyname,
    NameInput? surname,
    EmailInput? email,
    DateInput? birthDate,
    NoteInput? note,
    bool? isValid,
    bool? isReadonly,
    WorkerData? initialWorkerData,
    WorkerData? workerData,
    void Function(WorkerFormUpdatedData)? formUpdated,
  }) {
    return WorkerFormState(
      name: name ?? this.name,
      familyname: familyname ?? this.familyname,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      note: note ?? this.note,
      isValid: isValid ?? this.isValid,
      isReadonly: isReadonly ?? this.isReadonly,
      initialWorkerData: initialWorkerData ?? this.initialWorkerData,
      workerData: workerData ?? this.workerData,
      formUpdated: formUpdated ?? this.formUpdated,
    );
  }

  @override
  List<Object?> get props => [
        familyname,
        name,
        surname,
        email,
        birthDate,
        note,
        isValid,
        isReadonly,
        workerData,
        initialWorkerData,
        formUpdated,
      ];
}
