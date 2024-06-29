import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habib_app/core/services/preferences.dart';
import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/app.dart';

Future<void> main() async {
  await dotenv.load();

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final Preferences preferences = Preferences(sharedPreferences: sharedPreferences);

  final ConnectionSettings connectionSettings = ConnectionSettings(
    host: preferences.getMySqlHost() ?? '',
    port: preferences.getMySqlPort() ?? 0,
    user: preferences.getMySqlUser(),
    password: preferences.getMySqlPassword(),
    db: preferences.getMySqlDb()
  );

  MySqlConnection? connection;
  try {
    connection = await MySqlConnection.connect(connectionSettings);
  } catch (_) { }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        preferencesProvider.overrideWithValue(preferences),
        if (connection != null) mySqlConnectionProvider.overrideWithValue(connection)
      ],
      child: const App()
    )
  );
}