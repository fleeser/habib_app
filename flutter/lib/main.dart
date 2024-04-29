import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import 'package:habib_app/core/services/database.dart';
import 'package:habib_app/src/app.dart';

Future<void> main() async {
  await dotenv.load();
  
  final MySqlConnection connection = await MySqlConnection.connect(connectionSettings);

  runApp(
    ProviderScope(
      overrides: [
        mySqlConnectionProvider.overrideWithValue(connection)
      ],
      child: const App()
    )
  );
}