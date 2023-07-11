import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_web_app/domain/models/worker_data.dart';

abstract class IStaffApi {
  Stream<List<WorkerData>> getStaffList();
  Future<WorkerData?> getWorker(String id);
  Future<void> saveWorker(WorkerData worker);

  Future<void> delete(String id);
}

class StaffLocalApi extends IStaffApi {
  StaffLocalApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }
  void _init() {
    final jsonValue = _getValue(_collectionKey);
    if (jsonValue != null) {
      final list = List<Map<dynamic, dynamic>>.from(
        json.decode(jsonValue) as List,
      )
          .map((jsonMap) => WorkerData.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _subject.add(list);
    } else {
      _subject.add(const []);
    }
  }

  final SharedPreferences _plugin;
  final _subject = BehaviorSubject<List<WorkerData>>.seeded(const []);
  static const _collectionKey = '__staff_collection_key__';
  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) => _plugin.setString(key, value);

  @override
  Future<void> delete(String id) {
    final list = [..._subject.value];
    final index = list.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw Exception('Not found');
    } else {
      list.removeAt(index);
      _subject.add(list);
      return _setValue(_collectionKey, json.encode(list));
    }
  }

  @override
  Stream<List<WorkerData>> getStaffList() => _subject.asBroadcastStream();

  @override
  Future<WorkerData?> getWorker(String id) async {
    final list = [..._subject.value];
    final index = list.indexWhere((t) => t.id == id);
    if (index == -1) {
      return null;
    } else {
      return list[index];
    }
  }

  @override
  Future<void> saveWorker(WorkerData worker) {
    final list = [..._subject.value];
    final todoIndex = list.indexWhere((t) => t.id == worker.id);
    if (todoIndex >= 0) {
      list[todoIndex] = worker;
    } else {
      list.add(worker);
    }

    _subject.add(list);
    return _setValue(_collectionKey, json.encode(list));
  }
}
