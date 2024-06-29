import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/src/features/settings/presentation/app/settings_page_notifier.dart';

class Validator {

  static void validateSettings(Settings settings) {
    final String? mySqlHost = settings.mySqlHost;
    if (mySqlHost == null || mySqlHost.isEmpty) throw Exception('Der Host darf nicht leer sein.');

    final int? mySqlPort = settings.mySqlPort;
    if (mySqlPort == null) throw Exception('Der Port darf nicht leer sein.');

    final String? mySqlUser = settings.mySqlUser;
    if (mySqlUser == null || mySqlUser.isEmpty) throw Exception('Der Benutzer darf nicht leer sein.');

    final String? mySqlPassword = settings.mySqlPassword;
    if (mySqlPassword == null || mySqlPassword.isEmpty) throw Exception('Das Passwort darf nicht leer sein.');

    final String? mySqlDb = settings.mySqlDb;
    if (mySqlDb == null || mySqlDb.isEmpty) throw Exception('Die Datenbank darf nicht leer sein.');
  }

  static void validateCustomerCreate({
    String? firstName,
    String? lastName,
    String? title,
    String? occupation,
    String? phone,
    String? mobile,
    String? addressPostalCode,
    String? addressCity,
    String? addressStreet
  }) {
    if (firstName == null || firstName.isEmpty || firstName.length > 100) throw Exception('Der Vorname muss zwischen 1 und 100 Zeichen haben.');
    if (lastName == null || lastName.isEmpty || lastName.length > 100) throw Exception('Der Nachname muss zwischen 1 und 100 Zeichen haben.');
    if (title != null && title.length > 50) throw Exception('Der Titel darf nicht länger als 50 Zeichen sein.');
    if (occupation != null && occupation.length > 100) throw Exception('Der Beruf darf nicht länger als 100 Zeichen sein.');
    if (phone != null && phone.length > 20) throw Exception('Die Telefonnummer darf nicht länger als 20 Zeichen sein.');
    if (mobile != null && mobile.length > 20) throw Exception('Die Mobilnummer darf nicht länger als 20 Zeichen sein.');
    if (addressCity == null || addressCity.isEmpty || addressCity.length > 100) throw Exception('Die Stadt muss zwischen 1 und 100 Zeichen haben.');
    if (addressPostalCode == null || addressPostalCode.length != 5) throw Exception('Die Postleitzahl muss genau 5 Zeichen lang sein.');
    if (addressStreet == null || addressStreet.isEmpty || addressStreet.length > 100) throw Exception('Die Straße und Hausnummer müssen zusammen zwischen 1 und 100 Zeichen lang sein.');
  }

  static void validateCustomerUpdate({
    String? firstName,
    String? lastName,
    String? title,
    String? occupation,
    String? phone,
    String? mobile,
    String? addressPostalCode,
    String? addressCity,
    String? addressStreet
  }) {
    if (firstName == null || firstName.isEmpty || firstName.length > 100) throw Exception('Der Vorname muss zwischen 1 und 100 Zeichen haben.');
    if (lastName == null || lastName.isEmpty || lastName.length > 100) throw Exception('Der Nachname muss zwischen 1 und 100 Zeichen haben.');
    if (title != null && title.length > 50) throw Exception('Der Titel darf nicht länger als 50 Zeichen sein.');
    if (occupation != null && occupation.length > 100) throw Exception('Der Beruf darf nicht länger als 100 Zeichen sein.');
    if (phone != null && phone.length > 20) throw Exception('Die Telefonnummer darf nicht länger als 20 Zeichen sein.');
    if (mobile != null && mobile.length > 20) throw Exception('Die Mobilnummer darf nicht länger als 20 Zeichen sein.');
    if (addressCity == null || addressCity.isEmpty || addressCity.length > 100) throw Exception('Die Stadt muss zwischen 1 und 100 Zeichen haben.');
    if (addressPostalCode == null || addressPostalCode.length != 5) throw Exception('Die Postleitzahl muss genau 5 Zeichen lang sein.');
    if (addressStreet == null || addressStreet.isEmpty || addressStreet.length > 100) throw Exception('Die Straße und Hausnummer müssen zusammen zwischen 1 und 100 Zeichen lang sein.');
  }

  static void validateAuthorCreate({
    String? firstName,
    String? lastName,
    String? title
  }) {
    if (firstName == null || firstName.isEmpty || firstName.length > 100) throw Exception('Der Vorname muss zwischen 1 und 100 Zeichen haben.');
    if (lastName == null || lastName.isEmpty || lastName.length > 100) throw Exception('Der Nachname muss zwischen 1 und 100 Zeichen haben.');
    if (title != null && title.length > 50) throw Exception('Der Titel darf nicht länger als 50 Zeichen sein.');
  }

  static void validateCategoryCreate({
    String? name
  }) {
    if (name == null || name.isEmpty || name.length > 100) throw Exception('Der Name muss zwischen 1 und 100 Zeichen haben.');
  }

  static void validatePublisherCreate({
    String? name,
    String? city
  }) {
    if (name == null || name.isEmpty || name.length > 100) throw Exception('Der Name muss zwischen 1 und 100 Zeichen haben.');
    if (city == null || city.isEmpty || city.length > 100) throw Exception('Die Stadt muss zwischen 1 und 100 Zeichen haben.');
  }

  static void validateCategoryUpdate({
    String? name
  }) {
    if (name == null || name.isEmpty || name.length > 100) throw Exception('Der Name muss zwischen 1 und 100 Zeichen haben.');
  }

  static void validateAuthorUpdate({
    String? firstName,
    String? lastName,
    String? title
  }) {
    if (firstName == null || firstName.isEmpty || firstName.length > 100) throw Exception('Der Vorname muss zwischen 1 und 100 Zeichen haben.');
    if (lastName == null || lastName.isEmpty || lastName.length > 100) throw Exception('Der Nachname muss zwischen 1 und 100 Zeichen haben.');
    if (title != null && title.length > 50) throw Exception('Der Titel darf nicht länger als 50 Zeichen sein.');
  }

  static void validatePublisherUpdate({
    String? name,
    String? city
  }) {
    if (name == null || name.isEmpty || name.length > 100) throw Exception('Der Name muss zwischen 1 und 100 Zeichen haben.');
    if (city == null || city.isEmpty || city.length > 100) throw Exception('Die Stadt muss zwischen 1 und 100 Zeichen haben.');
  }

  static void validateBookCreate({
    String? title,
    String? isbn10,
    String? isbn13,
    List<int>? authorIds,
    List<int>? categoriesIds,
    int? edition,
    DateTime? publishDate,
    List<int>? publisherIds,
    bool? bought,
    DateTime? receivedAt
  }) {
    if (title == null || title.isEmpty || title.length > 255) throw Exception('Der Titel muss zwischen 1 und 255 Zeichen haben.');
    if (isbn10 != null && isbn10.length != 10) throw Exception('Die ISBN10 muss genau 10 Zeichen lang sein.');
    if (isbn13 != null && isbn13.length != 13) throw Exception('Die ISBN13 muss genau 10 Zeichen lang sein.');
    if ((authorIds ?? []).isEmpty) throw Exception('Es muss mindestens einen Autor geben.');
    if ((categoriesIds ?? []).isEmpty) throw Exception('Es muss mindestens eine Kategorie geben.');
    if (publishDate != null && publishDate.isAfter(DateTime.now())) throw Exception('Das Veröffentlichungsdatum darf nicht in der Zukunft liegen.');
    if ((publisherIds ?? []).isEmpty) throw Exception('Es muss mindestens einen Verlag geben.');
    if (receivedAt != null && receivedAt.isAfter(DateTime.now())) throw Exception('Das Erhaltungsdatum darf nicht in der Zukunft liegen.');
  }

  static void validateBookUpdate({
    String? title,
    String? isbn10,
    String? isbn13,
    List<int>? authorIds,
    List<int>? categoriesIds,
    int? edition,
    DateTime? publishDate,
    List<int>? publisherIds,
    bool? bought,
    DateTime? receivedAt
  }) {
    if (title == null || title.isEmpty || title.length > 255) throw Exception('Der Titel muss zwischen 1 und 255 Zeichen haben.');
    if (isbn10 != null && isbn10.length != 10) throw Exception('Die ISBN10 muss genau 10 Zeichen lang sein.');
    if (isbn13 != null && isbn13.length != 13) throw Exception('Die ISBN13 muss genau 10 Zeichen lang sein.');
    if ((authorIds ?? []).isEmpty) throw Exception('Es muss mindestens einen Autor geben.');
    if ((categoriesIds ?? []).isEmpty) throw Exception('Es muss mindestens eine Kategorie geben.');
    if (publishDate != null && publishDate.isAfter(DateTime.now())) throw Exception('Das Veröffentlichungsdatum darf nicht in der Zukunft liegen.');
    if ((publisherIds ?? []).isEmpty) throw Exception('Es muss mindestens einen Verlag geben.');
    if (receivedAt != null && receivedAt.isAfter(DateTime.now())) throw Exception('Das Erhaltungsdatum darf nicht in der Zukunft liegen.');
  }

  static void validateBorrowUpdate({
    DateTime? endDate,
    BorrowStatus? status
  }) {
    if (endDate == null) throw Exception('Das Rückgabedatum darf nicht leer sein.');
  }

  static void validateBorrowCreate({
    DateTime? endDate,
    BorrowStatus? status
  }) { }
}