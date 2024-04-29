import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  
  static String mysqlHost = dotenv.env['MYSQL_HOST']!;
  static int mysqlPort = int.parse(dotenv.env['MYSQL_PORT']!);
  static String mysqlUser = dotenv.env['MYSQL_USER']!;
  static String mysqlPassword = dotenv.env['MYSQL_PASSWORD']!;
  static String mysqlDb = dotenv.env['MYSQL_DB']!;
}