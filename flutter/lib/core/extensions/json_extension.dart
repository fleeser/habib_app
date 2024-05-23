import 'package:habib_app/core/utils/typedefs.dart';

extension JsonExtension on Json {

  Json jsonFromKeys(List<String> keys) {
    Json json = <String, dynamic>{};

    for (String key in keys) {
      json[key] = this[key];
    }

    return json;
  }
}