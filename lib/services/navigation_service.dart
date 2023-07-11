import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_web_app/presentation/private/home/view/home_screen.dart';
import 'package:test_web_app/presentation/private/staff_list/staff_list.dart';
import 'package:test_web_app/presentation/private/worker_create/view/view.dart';
import 'package:test_web_app/presentation/private/worker_details/view/worker_details_page.dart';
import 'package:test_web_app/presentation/private/worker_edit/view/worker_edit_page.dart';
import 'package:test_web_app/presentation/public/login/login.dart';

class NavigationService {
  static const String login = '/login';

  static const String staffList = '/staff-list';
  static const String staffDetails = '/details/:id';
  static const String staffCreate = '/create';
  static const String staffEdit = '/edit/:id';
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: staffList,
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state, child) {
            return NoTransitionPage(child: HomeScreen(child: child));
          },
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: staffList,
              builder: (context, state) => const StaffListPage(),
              // routes: [
              //   // GoRoute(
              //   //     path: staffDetails,
              //   //     builder: (context, state) => const WorkerDetailsPage(),
              //   //     routes: [
              //   //       GoRoute(
              //   //         path: staffEdit,
              //   //         builder: (context, state) => const WorkerEditView(),
              //   //       ),
              //   //     ]),

              //   // GoRoute(
              //   //   path: staffEdit,
              //   //   builder: (context, state) =>
              //   //       const UserScreen(id: state.pathParameters['userId']),
              //   // ),
              // ])
            ),
            GoRoute(
              path: staffCreate,
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const WorkerCreateView(),
            ),
            GoRoute(
              path: staffDetails,
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) =>
                  WorkerDetailsView(id: state.pathParameters['id'] as String),
            ),
            GoRoute(
              path: staffEdit,
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) =>
                  WorkerEditView(id: state.pathParameters['id'] as String),
            ),
          ]),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: login,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: UniqueKey(),
            child: LoginPage(key: UniqueKey()),
          );
        },
      )
    ],
  );
}
