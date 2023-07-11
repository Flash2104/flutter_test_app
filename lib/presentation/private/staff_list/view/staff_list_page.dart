import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/presentation/private/staff_list/bloc/staff_list_bloc.dart';
import 'package:test_web_app/services/navigation_service.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaffListBloc()..add(const StaffListInitialEvent()),
      child: const _StaffListView(),
    );
  }
}

class _StaffListView extends StatelessWidget {
  const _StaffListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StaffListBloc, StaffListState>(
      listenWhen: (previous, current) => previous.deleteStatus != current.deleteStatus,
      listener: (context, state) {
        if (state.deleteStatus == StaffListDeleteStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Worker deleted successfully')),
            );
        }
        if (state.deleteStatus == StaffListDeleteStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Worker deletion failed')),
            );
        }
      },
      buildWhen: (previous, current) => previous.loadStatus != current.loadStatus,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () => context.go(NavigationService.staffCreate),
                  child: const Text('Create')),
            ),
            const _StaffListContent(),
          ],
        );
      },
    );
  }
}

class _StaffListContent extends StatelessWidget {
  const _StaffListContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffListBloc, StaffListState>(
      buildWhen: (previous, current) =>
          previous.list != current.list || previous.loadStatus != current.loadStatus,
      builder: (context, state) {
        if (state.loadStatus == LoadStaffListStatus.inProgress) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state.list.isEmpty) {
          if (state.loadStatus == LoadStaffListStatus.inProgress) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state.loadStatus != LoadStaffListStatus.success) {
            return const SizedBox();
          } else {
            return Center(
              child: Text(
                'Worker list is empty!',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }
        }
        return CupertinoScrollbar(
            child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: state.list.length,
          itemBuilder: (context, index) {
            return Card(
              child: _StaffListTile(
                index: index,
                worker: state.list[index],
              ),
            );
          },
        ));
      },
    );
  }
}

class _StaffListTile extends StatelessWidget {
  const _StaffListTile({
    super.key,
    required this.index,
    required this.worker,
  });

  final int index;
  final WorkerData worker;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd.MM.yyyy');
    final birthDate = worker.birthDate != null ? format.format(worker.birthDate!) : null;
    return GestureDetector(
      onTapDown: (details) =>
          context.go(NavigationService.staffDetails.replaceFirst(':id', worker.id)),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide.none,
        ),
        borderOnForeground: true,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(index.toString()),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${worker.name} ${worker.familyname} ${worker.surname}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          if (birthDate != null)
                            Text(birthDate,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Email: ${worker.email}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                          Text('Note: ${worker.note ?? ''}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => context.go(
                              NavigationService.staffEdit.replaceFirst(':id', worker.id)),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () => context
                              .read<StaffListBloc>()
                              .add(StaffListDeleteEvent(worker.id)),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ],
              )),
          onTap: () =>
              context.go(NavigationService.staffDetails.replaceFirst(':id', worker.id)),
        ),
      ),
    );
  }
}
