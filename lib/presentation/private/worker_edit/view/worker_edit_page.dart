import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_web_app/presentation/private/worker_edit/bloc/worker_edit_bloc.dart';
import 'package:test_web_app/presentation/private/worker_form/view/view.dart';
import 'package:test_web_app/services/navigation_service.dart';

class WorkerEditView extends StatelessWidget {
  const WorkerEditView({
    super.key,
    required this.id,
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => WorkerEditBloc()..add(WorkerEditInitEvent(id: id)),
        child: const _WorkerEditView());
  }
}

class _WorkerEditView extends StatelessWidget {
  const _WorkerEditView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerEditBloc, WorkerEditState>(
      listenWhen: (previous, current) => previous.editStatus != current.editStatus,
      listener: (context, state) {
        if (state.editStatus == EditWorkerStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Worker edited successfully')),
            );
          context.go(NavigationService.staffList);
        }
      },
      buildWhen: (previous, current) =>
          previous.editData != current.editData ||
          previous.loadStatus != current.loadStatus ||
          previous.editStatus != current.editStatus,
      builder: (context, state) {
        final inProggress = state.loadStatus == LoadEditWorkerInitStatus.inProgress ||
            state.editStatus == EditWorkerStatus.inProgress;
        if (state.editData == null || inProggress) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return Scaffold(
            appBar: AppBar(
              title: Text('Editing of employee: ${state.editData!.id}'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                WorkerFormView(
                  data: state.editData,
                  isReadonly: false,
                  formUpdated: (updatedData) {
                    context.read<WorkerEditBloc>().add(WorkerEditUpdatedDataEvent(
                          data: updatedData.data,
                          isValid: updatedData.isValid,
                        ));
                  },
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _CancelButton(),
                  const SizedBox(
                    width: 20,
                  ),
                  _SaveButton()
                ])
              ],
            ));
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerEditBloc, WorkerEditState>(
      builder: (context, state) {
        return OutlinedButton(
          key: const Key('workerEditForm_cancel_button'),
          onPressed: state.isValid
              ? () {
                  context.go(NavigationService.staffList);
                }
              : null,
          child: const Text('Cancel'),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerEditBloc, WorkerEditState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('workerEditForm_submit_button'),
          onPressed: state.isValid
              ? () {
                  context.read<WorkerEditBloc>().add(const WorkerEditSubmitEvent());
                }
              : null,
          child: const Text('Submit'),
        );
      },
    );
  }
}
