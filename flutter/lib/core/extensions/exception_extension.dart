import 'package:flutter/material.dart';

extension ExceptionExtension on Exception {

  String title(BuildContext context) {
    return 'Unbekannter Fehler';
  }

  String description(BuildContext context) {
    return 'Ein unbekannter Fehler ist aufgetreten.';
  }
}