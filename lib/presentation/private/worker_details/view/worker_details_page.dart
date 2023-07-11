import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_web_app/presentation/private/worker_details/bloc/worker_details_bloc.dart';
import 'package:test_web_app/presentation/private/worker_form/view/view.dart';
import 'package:test_web_app/services/navigation_service.dart';

class WorkerDetailsView extends StatelessWidget {
  const WorkerDetailsView({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkerDetailsBloc()..add(WorkerDetailsInitEvent(id: id)),
      child: _WorkerDetailsView(id: id),
    );
  }
}

class _WorkerDetailsView extends StatelessWidget {
  const _WorkerDetailsView({
    super.key,
    required this.id,
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerDetailsBloc, WorkerDetailsState>(
      listenWhen: (previous, current) => previous.loadStatus != current.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadWorkerStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Worker ($id) not found')),
            );
          context.pop();
        }
      },
      buildWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus ||
          previous.workerData != current.workerData,
      builder: (context, state) {
        if (state.workerData == null || state.loadStatus == LoadWorkerStatus.inProgress) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return Scaffold(
            appBar: AppBar(
              title: const Text('Employee details'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                WorkerFormView(
                  data: state.workerData,
                  isReadonly: true,
                  formUpdated: null,
                ),
                Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _EditButton(),
                      ],
                    ))
              ],
            ));
      },
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkerDetailsBloc, WorkerDetailsState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('workerDetailsForm_delete_button'),
          onPressed: state.loadStatus == LoadWorkerStatus.success
              ? () {
                  context.go(NavigationService.staffEdit
                      .replaceFirst(':id', state.workerData!.id));
                }
              : null,
          child: const Text('Edit'),
        );
      },
    );
  }
}
