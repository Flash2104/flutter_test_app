part of 'worker_form_view.dart';

class _WorkerForm extends StatelessWidget {
  const _WorkerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerFormBloc, WorkerFormState>(
      listenWhen: (previous, current) =>
          previous.workerData != current.workerData ||
          previous.isValid != current.isValid,
      listener: (context, state) {
        if (state.formUpdated != null && state.workerData != null) {
          state.formUpdated!(WorkerFormUpdatedData(
            data: state.workerData,
            isValid: state.isValid,
          ));
        }
      },
      builder: (context, state) => Align(
          alignment: const Alignment(0, -1 / 3),
          child: IgnorePointer(
            ignoring: state.isReadonly,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  children: [
                    _NameInput(
                      fieldName: 'First name',
                      type: FieldFormName.name,
                      inputGetter: (state) => state.name,
                      initDataGetter: (data) => data.name,
                      isRequired: true,
                    ),
                    const Padding(padding: EdgeInsets.all(12)),
                    _NameInput(
                      fieldName: 'Family name',
                      inputGetter: (state) => state.familyname,
                      initDataGetter: (data) => data.familyname,
                      type: FieldFormName.familyname,
                      isRequired: true,
                    ),
                    const Padding(padding: EdgeInsets.all(12)),
                    _NameInput(
                      fieldName: 'Surname',
                      inputGetter: (state) => state.surname,
                      initDataGetter: (data) => data.surname,
                      type: FieldFormName.surname,
                      isRequired: false,
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(12)),
                const Wrap(
                  children: [
                    _EmailInput(),
                    Padding(padding: EdgeInsets.all(12)),
                    _DateInput(),
                    Padding(padding: EdgeInsets.all(12)),
                    _NoteInput(),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class _NameInput extends StatefulWidget {
  const _NameInput({
    super.key,
    required this.fieldName,
    required this.type,
    required this.inputGetter,
    required this.initDataGetter,
    required this.isRequired,
  });
  final String fieldName;
  final FieldFormName type;
  final bool isRequired;
  final NameInput Function(WorkerFormState) inputGetter;
  final String? Function(WorkerData) initDataGetter;

  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _textFieldController.addListener(() => context.read<WorkerFormBloc>().add(
        WorkerFormStringValueChanged(
            value: _textFieldController.text, fieldFormName: widget.type)));
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerFormBloc, WorkerFormState>(
      listenWhen: (previous, current) =>
          previous.initialWorkerData != current.initialWorkerData,
      listener: (context, state) {
        if (state.initialWorkerData != null) {
          final selection = _textFieldController.selection;
          _textFieldController.text =
              widget.initDataGetter(state.initialWorkerData!) ?? '';
          _textFieldController.selection = selection;
        }
      },
      buildWhen: (previous, current) {
        return widget.inputGetter(previous) != widget.inputGetter(current);
      },
      builder: (context, state) {
        String? errorText;
        switch (widget.inputGetter(state).displayError) {
          case NameValidationError.empty:
            errorText = '${widget.fieldName} required';
            break;
          case NameValidationError.invalid:
            errorText = '${widget.fieldName} is not valid';
            break;
          default:
        }
        final keyName = widget.fieldName.replaceAll(' ', '');
        return TextFormField(
          key: Key('workerForm_${keyName}Input_textField'),
          keyboardType: TextInputType.name,
          readOnly: state.isReadonly,
          controller: _textFieldController,
          decoration: InputDecoration(
            labelText: '${widget.fieldName} ${widget.isRequired ? ' (*)' : ''}',
            errorText: errorText,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput({
    super.key,
  });

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _textFieldController.addListener(() => context.read<WorkerFormBloc>().add(
        WorkerFormStringValueChanged(
            value: _textFieldController.text, fieldFormName: FieldFormName.email)));
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerFormBloc, WorkerFormState>(
      listenWhen: (previous, current) =>
          previous.initialWorkerData != current.initialWorkerData,
      listener: (context, state) {
        if (state.initialWorkerData != null) {
          final selection = _textFieldController.selection;
          _textFieldController.text = state.initialWorkerData!.email;
          _textFieldController.selection = selection;
        }
      },
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        String? errorText;
        switch (state.email.displayError) {
          case EmailValidationError.empty:
            errorText = 'Email is required';
            break;
          case EmailValidationError.invalid:
            errorText = 'Email is not valid';
            break;
          default:
        }
        return TextFormField(
          key: const Key('workerForm_emailInput_textField'),
          onChanged: (email) => context.read<WorkerFormBloc>().add(
              WorkerFormStringValueChanged(
                  value: email, fieldFormName: FieldFormName.email)),
          keyboardType: TextInputType.emailAddress,
          controller: _textFieldController,
          decoration: InputDecoration(
            labelText: 'Email (*)',
            errorText: errorText,
          ),
        );
      },
    );
  }
}

class _DateInput extends StatefulWidget {
  const _DateInput({
    super.key,
  });

  @override
  State<_DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<_DateInput> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _textFieldController.addListener(() => context.read<WorkerFormBloc>().add(
        WorkerFormStringValueChanged(
            value: _textFieldController.text, fieldFormName: FieldFormName.birthDate)));
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerFormBloc, WorkerFormState>(
      listenWhen: (previous, current) =>
          previous.initialWorkerData != current.initialWorkerData,
      listener: (context, state) {
        if (state.initialWorkerData != null) {
          String date = state.initialWorkerData!.birthDate != null
              ? DateInput.DATE_FORMAT.format(state.initialWorkerData!.birthDate!)
              : '';
          final selection = _textFieldController.selection;
          _textFieldController.text = date;
          _textFieldController.selection = selection;
        }
      },
      buildWhen: (previous, current) => previous.birthDate != current.birthDate,
      builder: (context, state) {
        String? errorText;
        switch (state.birthDate.displayError) {
          case DateValidationError.empty:
            errorText = 'Birthdate is required';
            break;
          case DateValidationError.invalid:
            errorText = 'Birthdate is not valid';
            break;
          default:
        }
        return TextFormField(
          key: const Key('workerForm_birthDateInput_textField'),
          onChanged: (bd) => context.read<WorkerFormBloc>().add(
              WorkerFormStringValueChanged(
                  value: bd, fieldFormName: FieldFormName.birthDate)),
          keyboardType: TextInputType.datetime,
          controller: _textFieldController,
          decoration: InputDecoration(
            labelText: 'Birthdate - ${DateInput.DATE_FORMAT.pattern} (*)',
            errorText: errorText,
          ),
        );
      },
    );
  }
}

class _NoteInput extends StatefulWidget {
  const _NoteInput({
    super.key,
  });

  @override
  State<_NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<_NoteInput> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _textFieldController.addListener(() => context.read<WorkerFormBloc>().add(
        WorkerFormStringValueChanged(
            value: _textFieldController.text, fieldFormName: FieldFormName.note)));
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerFormBloc, WorkerFormState>(
      listenWhen: (previous, current) =>
          previous.initialWorkerData != current.initialWorkerData,
      listener: (context, state) {
        if (state.initialWorkerData != null) {
          final selection = _textFieldController.selection;
          _textFieldController.text = state.initialWorkerData!.note ?? '';
          _textFieldController.selection = selection;
        }
      },
      buildWhen: (previous, current) => previous.note != current.note,
      builder: (context, state) {
        String? errorText;
        switch (state.note.displayError) {
          case NoteValidationError.invalid:
            errorText = 'Note is not valid';
            break;
          default:
        }
        return TextFormField(
          key: const Key('workerForm_noteInput_textField'),
          onChanged: (note) => context.read<WorkerFormBloc>().add(
              WorkerFormStringValueChanged(
                  value: note, fieldFormName: FieldFormName.note)),
          keyboardType: TextInputType.text,
          controller: _textFieldController,
          decoration: InputDecoration(
            labelText: 'Note',
            errorText: errorText,
          ),
        );
      },
    );
  }
}
