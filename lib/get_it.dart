import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_web_app/data/secure_storage.dart';
import 'package:test_web_app/data/staff_api.dart';
import 'package:test_web_app/domain/authentication_repository.dart';
import 'package:test_web_app/domain/staff_repository.dart';
import 'package:test_web_app/services/navigation_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerDependencies() async {
  getIt.registerSingleton<ISecureStorage>(SecureStorage());
  getIt.registerSingleton<IAuthenticationRepository>(AuthenticationRepository());
  getIt.registerSingleton<NavigationService>(NavigationService());

  getIt.registerSingleton<IStaffApi>(
      StaffLocalApi(plugin: await SharedPreferences.getInstance()));
  getIt.registerSingleton<IStaffRepository>(StaffRepository());
}
