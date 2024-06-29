import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/error/custom_exception.dart';

extension ObjectExtension on Object {

  String get errorTitle {
    if (this is ErrorDetails) return (this as ErrorDetails).error.errorTitle;
    if (this is CustomException) return (this as CustomException).title;
    return 'Unbekannter Fehler';
  }

  String get errorDescription {
    if (this is ErrorDetails) return (this as ErrorDetails).error.errorDescription;
    if (this is CustomException) return (this as CustomException).description;
    return 'Ein unbekannter Fehler ist aufgetreten.';
  }
}