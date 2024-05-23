import 'package:flutter/material.dart';

import 'package:habib_app/core/res/theme/colors/hb_colors.dart';

enum BorrowStatus {

  borrowed('Verliehen', HBColors.blue500, 'borrowed'),
  exceeded('Überschritten', HBColors.orange500, 'exceeded'),
  warnded('Angemahnt', HBColors.red500, 'warned'),
  returned('Zurückgegeben', HBColors.green500, 'returned');

  final String title;
  final Color color;
  final String databaseValue;

  const BorrowStatus(this.title, this.color, this.databaseValue);

  static fromDatabaseValue(String value) => BorrowStatus.values.firstWhere((BorrowStatus status) => status.databaseValue == value);
}