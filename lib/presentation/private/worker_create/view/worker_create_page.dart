import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_web_app/presentation/private/worker_create/bloc/worker_create_bloc.dart';
import 'package:test_web_app/presentation/private/worker_form/view/view.dart';
import 'package:test_web_app/services/navigation_service.dart';

class WorkerCreateView extends StatelessWidget {
  const WorkerCreateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkerCreateBloc(),
      child: const _WorkerCreateView(),
    );
  }
}

class _WorkerCreateView extends StatelessWidget {
  const _WorkerCreateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerCreateBloc, WorkerCreateState>(
      listenWhen: (previous, current) => previous.createStatus != current.createStatus,
      listener: (context, state) {
        if (state.createStatus == CreateWorkerStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Worker created successfully')),
            );
          context.go(NavigationService.staffList);
        }
      },
      buildWhen: (previous, current) =>
          previous.createData != current.createData ||
          previous.createStatus != current.createStatus,
      builder: (context, state) {
        if (state.createStatus == CreateWorkerStatus.inProgress) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Adding new employee'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              WorkerFormView(
                data: state.createData,
                isReadonly: false,
                formUpdated: (updatedData) {
                  context.read<WorkerCreateBloc>().add(WorkerCreateUpdatedDataEvent(
                        data: updatedData.data,
                        isValid: updatedData.isValid,
                      ));
                },
              ),
              Center(child: _SaveButton())
            ],
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerCreateBloc, WorkerCreateState>(
      builder: (context, state) {
        return OutlinedButton(
          key: const Key('workerCreateForm_submit_button'),
          onPressed: state.isValid
              ? () {
                  context.read<WorkerCreateBloc>().add(const WorkerCreateSubmitEvent());
                }
              : null,
          child: const Text('Submit'),
        );
      },
    );
  }
}
