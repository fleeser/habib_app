import 'package:equatable/equatable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/core/services/preferences.dart';

part 'settings_page_notifier.g.dart';

class Settings {

  final String? mySqlHost;
  final int? mySqlPort;
  final String? mySqlUser;
  final String? mySqlPassword;
  final String? mySqlDb;

  const Settings({
    this.mySqlHost,
    this.mySqlPort,
    this.mySqlUser,
    this.mySqlPassword,
    this.mySqlDb
  });

  factory Settings.fromPreferences(Preferences preferences) {
    return Settings(
      mySqlHost: preferences.getMySqlHost(),
      mySqlPort: preferences.getMySqlPort(),
      mySqlUser: preferences.getMySqlUser(),
      mySqlPassword: preferences.getMySqlPassword(),
      mySqlDb: preferences.getMySqlDb()
    );
  }
}

enum SettingsPageStatus {
  initial,
  loading,
  success,
  failure
}

class SettingsPageState extends Equatable {
  
  final SettingsPageStatus status;
  final Exception? exception;
  final Settings settings;

  const SettingsPageState({
    this.status = SettingsPageStatus.initial,
    this.exception,
    required this.settings
  });

  SettingsPageState copyWith({
    SettingsPageStatus? status,
    Exception? exception,
    Settings? settings,
    bool removeException = false
  }) {
    return SettingsPageState(
      status: status ?? this.status,
      exception: removeException ? null : exception ?? this.exception,
      settings: settings ?? this.settings
    );
  }

  @override
  List<Object?> get props => [
    status,
    exception,
    settings
  ];
}

@riverpod
class SettingsPageNotifier extends _$SettingsPageNotifier {

  late final Preferences _preferences;

  @override
  SettingsPageState build() {
    _preferences = ref.read(preferencesProvider);
    return SettingsPageState(settings: Settings.fromPreferences(_preferences));
  }

  Future<void> saveSettings({
    String? mySqlHost,
    int? mySqlPort,
    String? mySqlUser,
    String? mySqlPassword,
    String? mySqlDb
  }) async {
    if (state.status == SettingsPageStatus.loading) return;

    state = state.copyWith(
      status: SettingsPageStatus.loading,
      removeException: true
    );

    final Settings settings = Settings(
      mySqlHost: mySqlHost,
      mySqlPort: mySqlPort,
      mySqlUser: mySqlUser,
      mySqlPassword: mySqlPassword,
      mySqlDb: mySqlDb
    );

    try {
      Validator.validateSettings(settings);
    } catch (exception) {
      // TODO
    }

    await _preferences.setMySqlHost(settings.mySqlHost!);
    await _preferences.setMySqlPort(settings.mySqlPort!);
    await _preferences.setMySqlUser(settings.mySqlUser!);
    await _preferences.setMySqlPassword(settings.mySqlPassword!);
    await _preferences.setMySqlDb(settings.mySqlDb!);

    final ConnectionSettings connectionSettings = ConnectionSettings(
      host: settings.mySqlHost!,
      port: settings.mySqlPort!,
      user: settings.mySqlUser!,
      password: settings.mySqlPassword!,
      db: settings.mySqlDb!
    );
    
    late final MySqlConnection connection;
    try {
      ref.read(mySqlConnectionProvider).close();
      connection = await MySqlConnection.connect(connectionSettings);
    } catch (exception) {
      /*state = state.copyWith(
        status: SettingsPageStatus.failure,
        exception: exception
      );*/
      return;
    }

    databaseProvider.overrideWithValue(Database(connection: connection));

    state = SettingsPageState(
      status: SettingsPageStatus.success,
      settings: settings
    );
  }
}







