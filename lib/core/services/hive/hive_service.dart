import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_hive_model.dart' hide HiveTableConstant;


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    // register adapter
    _registerAdapter();
    await _openBoxes();
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  // box open
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  // box close
  Future<void> _close() async {
    await Hive.close();
  }

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);



  Future<void> register(AuthHiveModel user) async {
    await _authBox.put(user.authId, user);
  }

  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  AuthHiveModel? getUserById(String authId) {
    return _authBox.get(authId);
  }

  bool isEmailRegistered(String email) {
    return _authBox.values.any((user) => user.email == email);
  }

  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }
}
