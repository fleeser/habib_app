enum CustomExceptionCode {
  abc
}

class CustomException implements Exception {

  final CustomExceptionCode code;

  const CustomException(this.code);

  factory CustomException.abc() => const CustomException(CustomExceptionCode.abc);

  String get title {
    return switch (code) {
      CustomExceptionCode.abc => ''
    };
  }

  String get description {
    return switch (code) {
      CustomExceptionCode.abc => ''
    };
  }
}