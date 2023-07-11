import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/presentation/private/worker_form/view/inputs/date_input.dart';
import 'package:test_web_app/presentation/private/worker_form/view/inputs/name_input.dart';
import 'package:test_web_app/presentation/private/worker_form/view/inputs/note_input.dart';
import 'package:test_web_app/presentation/private/worker_form/worker_form.dart';
import 'package:test_web_app/presentation/shared/formz_input/email_input.dart';

part '_worker_form.dart';

class WorkerFormUpdatedData {
  const WorkerFormUpdatedData({
    required this.data,
    required this.isValid,
  });

  final WorkerData? data;
  final bool isValid;
}

class WorkerFormView extends StatelessWidget {
  const WorkerFormView({
    super.key,
    required this.data,
    required this.isReadonly,
    this.formUpdated,
  });

  final WorkerData? data;
  final bool isReadonly;
  final void Function(WorkerFormUpdatedData)? formUpdated;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: BlocProvider(
        create: (context) {
          return WorkerFormBloc()
            ..add(WorkerFormInitEvent(
              data: data,
              isReadonly: isReadonly,
              formUpdated: formUpdated,
            ));
        },
        child: const _WorkerForm(),
      ),
    );
  }
}
