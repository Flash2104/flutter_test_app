import 'package:flutter/material.dart';
import 'package:test_web_app/get_it.dart';
import 'package:test_web_app/services/navigation_service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = getIt.get<NavigationService>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: navigationService.router,
      builder: (context, child) => child!,
    );
  }
}
