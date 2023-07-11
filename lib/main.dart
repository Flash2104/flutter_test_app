import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app.dart';
import 'app_bloc_observer.dart';
import 'get_it.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: HydratedStorage.webStorageDirectory);
  await registerDependencies();

  Bloc.observer = AppBlocObserver();
  runApp(App());
}
