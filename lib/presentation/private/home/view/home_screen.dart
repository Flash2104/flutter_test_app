import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_web_app/presentation/private/home/bloc/home_bloc.dart';
import 'package:test_web_app/services/navigation_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return HomeBloc()..add(const HomeInitialEvent());
        },
        child: _HomeScreenView(child: child));
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
        listenWhen: (previous, current) =>
            previous.initStatus != current.initStatus ||
            previous.logoutStatus != current.logoutStatus,
        listener: (context, state) {
          if ((state.initStatus == HomeInitProcessStatus.success &&
                  state.isLoggedIn != true) ||
              state.logoutStatus == LogoutProcessStatus.success) {
            return context.go(NavigationService.login);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Employees list'), actions: [
            ElevatedButton(
                onPressed: () => context.go(NavigationService.staffList),
                child: const Text('Staff')),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () => context.read<HomeBloc>().add(const HomeLogoutEvent()),
                child: const Text('Logout')),
          ]),
          body: child,
        ));
  }
}
