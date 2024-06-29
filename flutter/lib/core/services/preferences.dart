import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

@riverpod
Preferences preferences(PreferencesRef ref) {
  return Preferences(
    sharedPreferences: ref.read(sharedPreferencesProvider)
  );
}

class Preferences {

  final SharedPreferences _sharedPreferences;

  const Preferences({
    required SharedPreferences sharedPreferences
  }) : _sharedPreferences = sharedPreferences;

  static const String _mySqlHostKey = 'mysql-host';
  static const String _mySqlPortKey = 'mysql-port';
  static const String _mySqlUserKey = 'mysql-user';
  static const String _mySqlPasswordKey = 'mysql-password';
  static const String _mySqlDbKey = 'mysql-db';

  Future<bool> setMySqlHost(String host) async {
    try {
      return await _sharedPreferences.setString(_mySqlHostKey, host);
    } catch (_) {
      return false;
    }
  }

  String? getMySqlHost() {
    return _sharedPreferences.getString(_mySqlHostKey);
  }

  Future<bool> setMySqlPort(int port) async {
    try {
      return await _sharedPreferences.setInt(_mySqlPortKey, port);
    } catch (_) {
      return false;
    }
  }

  int? getMySqlPort() {
    return _sharedPreferences.getInt(_mySqlPortKey);
  }

  Future<bool> setMySqlUser(String user) async {
    try {
      return await _sharedPreferences.setString(_mySqlUserKey, user);
    } catch (_) {
      return false;
    }
  }

  String? getMySqlUser() {
    return _sharedPreferences.getString(_mySqlUserKey);
  }

  Future<bool> setMySqlPassword(String password) async {
    try {
      return await _sharedPreferences.setString(_mySqlPasswordKey, password);
    } catch (_) {
      return false;
    }
  }

  String? getMySqlPassword() {
    return _sharedPreferences.getString(_mySqlPasswordKey);
  }

  Future<bool> setMySqlDb(String db) async {
    try {
      return await _sharedPreferences.setString(_mySqlDbKey, db);
    } catch (_) {
      return false;
    }
  }

  String? getMySqlDb() {
    return _sharedPreferences.getString(_mySqlDbKey);
  }
  
  bool get connectionSettingsComplete {
    return getMySqlHost() != null
      && getMySqlPort() != null
      && getMySqlUser() != null
      && getMySqlPassword() != null
      && getMySqlDb() != null;
  }
}
