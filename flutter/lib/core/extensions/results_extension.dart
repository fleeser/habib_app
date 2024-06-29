import 'package:mysql1/mysql1.dart';

import 'package:habib_app/core/utils/typedefs.dart';

extension ResultsExtension on Results {

  Json toJson() {
    return first.fields;
  }

  List<Json> toJsonList() {
    return map((ResultRow row) => row.fields).toList();
  }
}