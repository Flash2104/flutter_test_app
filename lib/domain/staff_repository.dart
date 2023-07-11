import 'package:test_web_app/data/staff_api.dart';
import 'package:test_web_app/domain/models/worker_data.dart';
import 'package:test_web_app/get_it.dart';
import 'package:uuid/uuid.dart';

abstract class IStaffRepository {
  Stream<List<WorkerData>> listStaff();
  Future<WorkerData?> getWorker(String id);
  Future<WorkerData> saveWorker(WorkerData worker);
  Future<void> delete(String id);
}

class StaffRepository implements IStaffRepository {
  final IStaffApi _staffApi = getIt.get<IStaffApi>();

  @override
  Stream<List<WorkerData>> listStaff() => _staffApi.getStaffList();

  @override
  Future<WorkerData?> getWorker(String id) => _staffApi.getWorker(id);

  @override
  Future<WorkerData> saveWorker(WorkerData worker) async {
    if (worker.id.isNotEmpty != true) {
      const uuid = Uuid();
      worker.id = uuid.v4();
    }
    await _staffApi.saveWorker(worker);
    return worker;
  }

  @override
  Future<void> delete(String id) => _staffApi.delete(id);
}
